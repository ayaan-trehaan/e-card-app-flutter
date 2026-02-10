import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../models/profile.dart';

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({super.key});

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  Profile? _profile;
  bool _loading = true;
  bool _saving = false;

  final _fullNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String? _photoUrl;
  Color _bannerColor = const Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    if (auth.user != null) {
      final profile = await SupabaseService().getProfile(auth.user!.id);
      if (mounted) {
        if (profile != null) {
          setState(() {
            _profile = profile;
            _fullNameController.text = profile.fullName ?? '';
            _jobTitleController.text = profile.jobTitle ?? '';
            _companyController.text = profile.company ?? '';
            _bioController.text = profile.bio ?? '';
            _emailController.text = profile.email ?? '';
            _phoneController.text = profile.phone ?? '';
            _locationController.text = profile.location ?? '';
            _photoUrl = profile.photoUrl;
            if (profile.bannerColor != null) {
              _bannerColor = Color(int.parse(profile.bannerColor!.replaceAll('#', '0xFF')));
            }
            _loading = false;
          });
        }
      }
    }
  }

  Future<void> _handleSave() async {
    setState(() => _saving = true);
    try {
      if (_profile != null) {
        await SupabaseService().updateProfile(_profile!.id, {
          'full_name': _fullNameController.text.trim(),
          'job_title': _jobTitleController.text.trim(),
          'company': _companyController.text.trim(),
          'bio': _bioController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'location': _locationController.text.trim(),
          'banner_color': '#${_bannerColor.value.toRadixString(16).substring(2)}',
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && _profile != null) {
      final bytes = await image.readAsBytes();
      final ext = image.name.split('.').last;
      final url = await SupabaseService().uploadAvatar(_profile!.userId, bytes, ext);
      if (url != null) {
        setState(() => _photoUrl = url);
        await SupabaseService().updateProfile(_profile!.id, {'photo_url': url});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_saving)
            const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
          else
            IconButton(icon: const Icon(Icons.save), onPressed: _handleSave),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                    child: _photoUrl == null ? const Icon(Icons.person, size: 60) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(_fullNameController, 'Full Name', Icons.person),
            const SizedBox(height: 16),
            _buildTextField(_jobTitleController, 'Job Title', Icons.work),
            const SizedBox(height: 16),
            _buildTextField(_companyController, 'Company', Icons.business),
            const SizedBox(height: 16),
            _buildTextField(_bioController, 'Bio', Icons.info, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email', Icons.email),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone', Icons.phone),
            const SizedBox(height: 16),
            _buildTextField(_locationController, 'Location', Icons.map),
            const SizedBox(height: 32),
            const Text('Banner Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showColorPicker(),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: _bannerColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _bannerColor,
            onColorChanged: (color) => setState(() => _bannerColor = color),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
        ],
      ),
    );
  }
}
