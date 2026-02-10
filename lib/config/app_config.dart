class AppConfig {
  static const String productionUrl = "https://e-cardapp.vercel.app";
  
  static String getProfileUrl(String username) {
    return "$productionUrl/$username";
  }
}
