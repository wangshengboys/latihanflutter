class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original';

  // Ganti 'xxxxxx' dengan API Read Access Token milik Anda dari themoviedb.org
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzBkNDQxMTA5M2FjNTVhMTFhNTk5MTZjMzkxNGVlOSIsIm5iZiI6MTc4MjAzNTk5NC43NDU5OTk4LCJzdWIiOiI2YTM3YjYxYWU2OTk4ZWM2Yzg4MGNjMzUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.jRcpVu_FA7uGcX9D1fkIM_Eyn0hnzcrRZYDdaAFMTTo';

  static Map<String, String> get headers => {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      };
}
