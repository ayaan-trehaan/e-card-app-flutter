import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/profile.dart';
import '../models/link.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicProfilePage extends StatefulWidget {
  final String username;
  const PublicProfilePage({super.key, required this.username});

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  Profile? _profile;
  List<LinkModel> _links = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await SupabaseService().getProfileByUsername(widget.username);
      if (profile != null) {
        final links = await SupabaseService().getLinks(profile.id);
        setState(() {
          _profile = profile;
          _links = links;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Profile not found';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Text(_error!)));

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _profile?.bannerColor != null 
            ? Color(int.parse(_profile!.bannerColor!.replaceAll('#', '0xFF'))) 
            : Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              CircleAvatar(
                radius: 60,
                backgroundImage: _profile?.photoUrl != null ? NetworkImage(_profile!.photoUrl!) : null,
                child: _profile?.photoUrl == null ? const Icon(Icons.person, size: 60) : null,
              ),
              const SizedBox(height: 16),
              Text(
                _profile?.fullName ?? '',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              if (_profile?.jobTitle != null)
                Text(
                  '${_profile!.jobTitle}${_profile?.company != null ? ' at ${_profile!.company}' : ''}',
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
              const SizedBox(height: 16),
              if (_profile?.bio != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _profile!.bio!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              const SizedBox(height: 32),
              ..._links.map((link) => _buildLinkTile(link)),
              const SizedBox(height: 40),
              const Text('Powered by E-Card', style: TextStyle(color: Colors.black45)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkTile(LinkModel link) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 600),
      child: ElevatedButton(
        onPressed: () => launchUrl(Uri.parse(link.url)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link),
            const SizedBox(width: 12),
            Text(link.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
