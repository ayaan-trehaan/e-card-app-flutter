import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../models/link.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Auth Methods
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({required String email, required String password}) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // Profile Methods
  Future<Profile?> getProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    
    if (response == null) return null;
    return Profile.fromJson(response);
  }

  Future<Profile?> getProfileByUsername(String username) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('username', username)
        .maybeSingle();
    
    if (response == null) return null;
    return Profile.fromJson(response);
  }

  Future<void> createProfile(Map<String, dynamic> profileData) async {
    await client.from('profiles').insert(profileData);
  }

  Future<void> updateProfile(String id, Map<String, dynamic> profileData) async {
    await client.from('profiles').update(profileData).eq('id', id);
  }

  // Links Methods
  Future<List<LinkModel>> getLinks(String profileId) async {
    final response = await client
        .from('links')
        .select()
        .eq('profile_id', profileId)
        .order('sort_order', ascending: true);
    
    return (response as List).map((json) => LinkModel.fromJson(json)).toList();
  }

  Future<void> addLink(Map<String, dynamic> linkData) async {
    await client.from('links').insert(linkData);
  }

  Future<void> updateLink(String id, Map<String, dynamic> linkData) async {
    await client.from('links').update(linkData).eq('id', id);
  }

  Future<void> deleteLink(String id) async {
    await client.from('links').delete().eq('id', id);
  }

  // Storage Methods
  Future<String?> uploadAvatar(String userId, List<int> bytes, String extension) async {
    final filePath = '$userId/avatar.$extension';
    await client.storage.from('avatars').uploadBinary(
      filePath,
      Uint8List.fromList(bytes),
      fileOptions: const FileOptions(upsert: true),
    );
    return client.storage.from('avatars').getPublicUrl(filePath);
  }
}
