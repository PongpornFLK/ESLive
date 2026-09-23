import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // setsup Client supabase
  final SupabaseClient supa = Supabase.instance.client;

  // sign in with email and password
  // Get email , pass ( String )
  Future<AuthResponse> signIn(String email, String password) async {
    return await supa.auth.signInWithPassword(email: email, password: password);
  }

  // sign up with email and password
  Future<AuthResponse> signUp(String email, String password) async {
    return await supa.auth.signUp(email: email, password: password);
  }

  //Sign out
  Future<void> signOut() async {
    await supa.auth.signOut();
  }

  // Get User Email
  // เผื่อต้องการแสดงใน Page , App
  String? getUserEmail() {
    final session = supa.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }
}
