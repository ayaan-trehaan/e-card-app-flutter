import 'package:flutter/material.dart';
import '../models/link.dart';
import '../services/supabase_service.dart';

class LinkManager extends StatefulWidget {
  final String profileId;
  const LinkManager({super.key, required this.profileId});

  @override
  State<LinkManager> createState() => _LinkManagerState();
}

class _LinkManagerState extends State<LinkManager> {
  List<LinkModel> _links = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLinks();
  }

  Future<void> _fetchLinks() async {
    final links = await SupabaseService().getLinks(widget.profileId);
    setState(() {
      _links = links;
      _loading = false;
    });
  }

  Future<void> _addLink() async {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: urlController, decoration: const InputDecoration(labelText: 'URL')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await SupabaseService().addLink({
                'profile_id': widget.profileId,
                'title': titleController.text,
                'url': urlController.text,
                'sort_order': _links.length,
              });
              if (mounted) Navigator.pop(context);
              _fetchLinks();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your Links', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add),
              label: const Text('Add Link'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = _links.removeAt(oldIndex);
              _links.insert(newIndex, item);
            });
            // Update sort order in database
          },
          children: _links.map((link) => ListTile(
            key: ValueKey(link.id),
            title: Text(link.title),
            subtitle: Text(link.url),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await SupabaseService().deleteLink(link.id);
                _fetchLinks();
              },
            ),
          )).toList(),
        ),
      ],
    );
  }
}
EOF
