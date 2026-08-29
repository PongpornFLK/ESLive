/// Supabase project connection details for the Flutter client.
///
/// The anon key is safe to embed in client code — it identifies the project,
/// not a user. Access control is enforced entirely by RLS policies on the
/// database side, not by keeping this value secret.
class SupabaseConfig {
  static const String url = 'https://qzozbrrojvovrklzlokr.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6b3picnJvanZvdnJrbHpsb2tyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY3Mzk0NzAsImV4cCI6MjEwMjMxNTQ3MH0.k2BljEg7oExbgYxLwkR9iDfHalEMc0W2aD8xBmXvWhM';
}
