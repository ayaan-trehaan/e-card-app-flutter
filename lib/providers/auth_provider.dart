import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AppAuthProvider with ChangeNotifier {
  User? _user;
  bool _loading = true;

  AppAuthProvider() {
    _init();
  }

  void _init() {
    _user = SupabaseService.client.auth.currentUser;
    _loading = false;
    notifyListeners();

    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;

  Future<void> signIn(String email, String password) async {
    await SupabaseService.client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await SupabaseService.client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }
}
