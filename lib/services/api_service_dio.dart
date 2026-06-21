import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import 'api_constants.dart';

class ApiServiceDio {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: ApiConstants.headers,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiServiceDio() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );
  }

  // 1. GET Discover Movie (list movie)
  Future<MovieResponse> getDiscoverMovies() async {
    try {
      final response = await _dio.get('/discover/movie');
      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal memuat data movie: ${e.message}');
    }
  }

  // 2. GET Detail Movie + Videos + Credits (Aktor)
  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {'append_to_response': 'videos,credits'},
      );
      return MovieDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal memuat detail movie: ${e.message}');
    }
  }

  // 3. GET Review Movie
  Future<ReviewResponse> getMovieReviews(int movieId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/reviews',
        queryParameters: {'page': page},
      );
      return ReviewResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal memuat review: ${e.message}');
    }
  }

  // 4. GET Similar Movie
  Future<MovieResponse> getSimilarMovies(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/similar');
      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal memuat similar movie: ${e.message}');
    }
  }

  // 5. GET Search Movie
  Future<MovieResponse> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Gagal mencari movie: ${e.message}');
    }
  }
}
