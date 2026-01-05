class ApiConfig {
  static const String baseUrl = "https://rpblbedyqmnzpowbumzd.supabase.co/rest/v1";
  static const String anonKey = "eyJhbGciOiJlUzI1NilsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZil6InJwYmxiZWR5cW1uenBvd2J1bXpkliwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYslmV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUplmZAynz3o210xDfq_exf2wUrTs";
  
  static Map<String, String> get headers => {
    "apikey": anonKey,
    "Authorization": "Bearer $anonKey",
    "Content-Type": "application/json",
    "Prefer": "return=representation",
  };
}