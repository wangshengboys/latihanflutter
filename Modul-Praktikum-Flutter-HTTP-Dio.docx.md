**Praktikum Flutter**

**HTTP GET Request**

_Implementasi dengan Package http & Dio_

Studi Kasus: Movie App dengan TMDB API

### **Tujuan Praktikum**

- Memahami konsep HTTP GET request dan response JSON

- Mampu melakukan request API menggunakan package http (default Flutter)

- Mampu melakukan request API menggunakan package Dio

- Mampu membuat model/class object untuk parsing data JSON

- Mampu menampilkan data API dalam ListView

- Mampu membuat halaman detail dengan data tambahan (video, review, similar movies)

### **URI Path dan Daftar Endpoint API yang Digunakan**

| Tujuan                    | Endpoint
| **Base URI Path**         | https://api.themoviedb.org/3         |
| **Discover Movie**        | GET /discove movie                                                            
| **Detail Movie \+ Video** | GET /movie/{movie_id}?append_to_response=videos                                           
| **Review Movie**          | GET /movie/{movie_id}/reviews                              
| **Similar Movie**         | GET /movie/{movie_id}/similar                                                             
| **Base URL Gambar**       | https://image.tmdb.org/t/p/original/{poster\_path}                                       
| **Bearer Token**          | eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZDQ3Mzk2MmI3NjU0Mzc4YzQyMjdlOGE3ZDc5N2E4NCIsIm5iZiI6MTU3MDE2MTUzMS4wNjksInN1YiI6IjVkOTZjMzdiMjljNjI2MDAyYzg3YjIyNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.edflbNEq1efP1xK5m2kWcjzfGZlPVs5ZEJbw7zKRh7o

⚠ Catatan: Ganti 'xxxxxx' pada header Authorization dengan API Read Access Token (Bearer Token) Anda. Daftar di themoviedb.org → Settings → API.

# **Bagian 1 — Persiapan Project & Dependencies**

## **1.1 Membuat Project Flutter Baru**

| flutter create movie_app cd movie_app |
| :------------------------------------ |

## **1.2 Menambahkan Dependencies**

Buka file pubspec.yaml dan tambahkan package berikut pada bagian dependencies:

dependencies:
flutter:
sdk: flutter

http: ^1.2.0 # package HTTP default Flutter
dio: ^5.4.0 # package HTTP alternatif (lebih powerful)
cached_network_image: ^3.3.1 # untuk menampilkan & cache gambar dari URL
flutter pub get

## **1.3 Struktur Folder Project**

Buat struktur folder berikut di dalam folder lib/ agar project lebih terorganisir:

lib/
├── main.dart
├── models/
│ ├── movie_model.dart
│ ├── movie_detail_model.dart
│ ├── review_model.dart
│ └── video_model.dart
├── services/
│ ├── api_service_http.dart # implementasi dengan package http
│ └── api_service_dio.dart # implementasi dengan package Dio
└── pages/
├── movie_list_page.dart
└── movie_detail_page.dart

# **Bagian 2 — Konsep HTTP GET & Perbandingan http vs Dio**

## **2.1 Apa itu HTTP GET?**

HTTP GET adalah metode request yang digunakan untuk **mengambil data** dari server tanpa mengubah data di server. Response yang diterima umumnya berupa data dalam format **JSON** (JavaScript Object Notation).

Client (Flutter App) Server (TMDB API)
| |
|--- GET /discover/movie --------->|
| Header: Authorization: Bearer |
| |
|<---- 200 OK + JSON response -----|
| |
parsing JSON -> Object Dart

## **2.2 Perbandingan Package http vs Dio**

| Aspek                  | package: http                    | package: dio                                 |
| :--------------------- | :------------------------------- | :------------------------------------------- |
| **Instalasi**          | Bawaan/default Flutter, ringan   | Perlu ditambahkan, lebih besar               |
| **Konfigurasi Header** | Manual setiap request            | Bisa diset sekali di BaseOptions (global)    |
| **Interceptor**        | Tidak ada (manual)               | Built-in (logging, auth, retry)              |
| **Timeout**            | Manual dengan .timeout()         | Built-in di BaseOptions                      |
| **Cancel Request**     | Tidak didukung langsung          | Didukung dengan CancelToken                  |
| **Cocok untuk**        | Project kecil, request sederhana | Project besar, banyak endpoint & konfigurasi |

# **Bagian 3 — Membuat Model (Class Object) untuk JSON**

Setiap response JSON dari API akan dipetakan ke dalam class Dart agar data lebih mudah diakses dan type-safe.

## **3.1 Model: Movie (untuk Discover & Similar)**

Buat file **lib/models/movie_model.dart**

class Movie {
final int id;
final String title;
final String overview;
final String? posterPath;
final String? backdropPath;
final double voteAverage;
final String releaseDate;

Movie({
required this.id,
required this.title,
required this.overview,
this.posterPath,
this.backdropPath,
required this.voteAverage,
required this.releaseDate,
});

// Factory constructor untuk parsing dari JSON
factory Movie.fromJson(Map<String, dynamic> json) {
return Movie(
id: json['id'] ?? 0,
title: json['title'] ?? '',
overview: json['overview'] ?? '',
posterPath: json['poster_path'],
backdropPath: json['backdrop_path'],
voteAverage: (json['vote_average'] ?? 0).toDouble(),
releaseDate: json['release_date'] ?? '',
);
}

// Getter untuk URL gambar poster
String get posterUrl => posterPath != null
? 'https://image.tmdb.org/t/p/original$posterPath'
: '';
}

// Model untuk membungkus response list (results + pagination)
class MovieResponse {
final int page;
final List<Movie> results;
final int totalPages;
final int totalResults;

MovieResponse({
required this.page,
required this.results,
required this.totalPages,
required this.totalResults,
});

factory MovieResponse.fromJson(Map<String, dynamic> json) {
return MovieResponse(
page: json['page'] ?? 1,
results: (json['results'] as List)
.map((item) => Movie.fromJson(item))
.toList(),
totalPages: json['total_pages'] ?? 0,
totalResults: json['total_results'] ?? 0,
);
}
}

## **3.2 Model: Video (untuk Trailer)**

Buat file **lib/models/video_model.dart**

class VideoModel {
final String id;
final String key; // ID video YouTube
final String name;
final String site; // contoh: 'YouTube'
final String type; // contoh: 'Trailer', 'Teaser'

VideoModel({
required this.id,
required this.key,
required this.name,
required this.site,
required this.type,
});

factory VideoModel.fromJson(Map<String, dynamic> json) {
return VideoModel(
id: json['id'] ?? '',
key: json['key'] ?? '',
name: json['name'] ?? '',
site: json['site'] ?? '',
type: json['type'] ?? '',
);
}

// URL thumbnail trailer dari YouTube
String get youtubeThumbnail =>
'https://img.youtube.com/vi/$key/0.jpg';

// URL untuk membuka video di YouTube
String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}

## **3.3 Model: MovieDetail (Detail \+ Videos)**

Buat file **lib/models/movie_detail_model.dart**. Model ini menangani response dari endpoint **append_to_response=videos**, sehingga ada field **videos** berupa object berisi **results** (list video).

import 'video_model.dart';

class MovieDetail {
final int id;
final String title;
final String overview;
final String? posterPath;
final String? backdropPath;
final double voteAverage;
final int runtime;
final String releaseDate;
final List<String> genres;
final List<VideoModel> videos;

MovieDetail({
required this.id,
required this.title,
required this.overview,
this.posterPath,
this.backdropPath,
required this.voteAverage,
required this.runtime,
required this.releaseDate,
required this.genres,
required this.videos,
});

factory MovieDetail.fromJson(Map<String, dynamic> json) {
return MovieDetail(
id: json['id'] ?? 0,
title: json['title'] ?? '',
overview: json['overview'] ?? '',
posterPath: json['poster_path'],
backdropPath: json['backdrop_path'],
voteAverage: (json['vote_average'] ?? 0).toDouble(),
runtime: json['runtime'] ?? 0,
releaseDate: json['release_date'] ?? '',
genres: (json['genres'] as List? ?? [])
.map((g) => g['name'] as String)
.toList(),
// Parsing nested object 'videos' -> 'results'
videos: json['videos'] != null
? (json['videos']['results'] as List)
.map((v) => VideoModel.fromJson(v))
.toList()
: [],
);
}

String get posterUrl => posterPath != null
? 'https://image.tmdb.org/t/p/original$posterPath'
: '';

String get backdropUrl => backdropPath != null
? 'https://image.tmdb.org/t/p/original$backdropPath'
: '';
}

## **3.4 Model: Review**

Buat file **lib/models/review_model.dart**

class ReviewModel {
final String id;
final String author;
final String content;
final double? rating;
final String createdAt;

ReviewModel({
required this.id,
required this.author,
required this.content,
this.rating,
required this.createdAt,
});

factory ReviewModel.fromJson(Map<String, dynamic> json) {
return ReviewModel(
id: json['id'] ?? '',
author: json['author'] ?? '',
content: json['content'] ?? '',
rating: json['author_details'] != null
? (json['author_details']['rating'] as num?)?.toDouble()
: null,
createdAt: json['created_at'] ?? '',
);
}
}

// Model untuk membungkus response list review
class ReviewResponse {
final int page;
final List<ReviewModel> results;
final int totalPages;
final int totalResults;

ReviewResponse({
required this.page,
required this.results,
required this.totalPages,
required this.totalResults,
});

factory ReviewResponse.fromJson(Map<String, dynamic> json) {
return ReviewResponse(
page: json['page'] ?? 1,
results: (json['results'] as List)
.map((item) => ReviewModel.fromJson(item))
.toList(),
totalPages: json['total_pages'] ?? 0,
totalResults: json['total_results'] ?? 0,
);
}
}

# **Bagian 4 — Implementasi dengan Package http**

## **4.1 Membuat Konstanta API**

Buat file **lib/services/api_constants.dart** untuk menyimpan konfigurasi yang digunakan berulang:

class ApiConstants {
static const String baseUrl = 'https://api.themoviedb.org/3';
static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original';

// Ganti dengan API Read Access Token milik Anda
static const String bearerToken = 'xxxxxx';

static Map<String, String> get headers => {
'Authorization': 'Bearer $bearerToken',
'Content-Type': 'application/json;charset=utf-8',
};
}

## **4.2 Service dengan Package http**

Buat file **lib/services/api_service_http.dart**

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import 'api_constants.dart';

class ApiServiceHttp {

// 1. GET Discover Movie (list movie)
Future<MovieResponse> getDiscoverMovies() async {
final url = Uri.parse('${ApiConstants.baseUrl}/discover/movie');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat data movie: ${response.statusCode}');
    }

}

// 2. GET Detail Movie + Videos
Future<MovieDetail> getMovieDetail(int movieId) async {
final url = Uri.parse(
'${ApiConstants.baseUrl}/movie/$movieId?append_to_response=videos',
);

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail movie: ${response.statusCode}');
    }

}

// 3. GET Review Movie
Future<ReviewResponse> getMovieReviews(int movieId) async {
final url = Uri.parse('${ApiConstants.baseUrl}/movie/$movieId/reviews');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ReviewResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat review: ${response.statusCode}');
    }

}

// 4. GET Similar Movie
Future<MovieResponse> getSimilarMovies(int movieId) async {
final url = Uri.parse('${ApiConstants.baseUrl}/movie/$movieId/similar');

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat similar movie: ${response.statusCode}');
    }

}
}

⚠ Catatan: Perhatikan: dengan package http, response.body berupa String yang harus di-decode manual menggunakan json.decode(), dan setiap method harus mengecek statusCode secara manual

# **Bagian 5 — Implementasi dengan Package Dio**

## **5.1 Konfigurasi Dio dengan BaseOptions & Interceptor**

Buat file **lib/services/api_service_dio.dart**. Dio memungkinkan konfigurasi header dan base URL dilakukan sekali saja:

import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import 'api_constants.dart';

class ApiServiceDio {
final Dio \_dio = Dio(
BaseOptions(
baseUrl: ApiConstants.baseUrl,
headers: ApiConstants.headers,
connectTimeout: const Duration(seconds: 10),
receiveTimeout: const Duration(seconds: 10),
),
);

ApiServiceDio() {
// Interceptor untuk logging request & response (opsional, untuk debugging)
\_dio.interceptors.add(
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
final response = await \_dio.get('/discover/movie');
return MovieResponse.fromJson(response.data);
} on DioException catch (e) {
throw Exception('Gagal memuat data movie: ${e.message}');
}
}

// 2. GET Detail Movie + Videos
Future<MovieDetail> getMovieDetail(int movieId) async {
try {
final response = await \_dio.get(
'/movie/$movieId',
queryParameters: {'append_to_response': 'videos'},
);
return MovieDetail.fromJson(response.data);
} on DioException catch (e) {
throw Exception('Gagal memuat detail movie: ${e.message}');
}
}

// 3. GET Review Movie
Future<ReviewResponse> getMovieReviews(int movieId) async {
try {
final response = await \_dio.get('/movie/$movieId/reviews');
return ReviewResponse.fromJson(response.data);
} on DioException catch (e) {
throw Exception('Gagal memuat review: ${e.message}');
}
}

// 4. GET Similar Movie
Future<MovieResponse> getSimilarMovies(int movieId) async {
try {
final response = await \_dio.get('/movie/$movieId/similar');
return MovieResponse.fromJson(response.data);
} on DioException catch (e) {
throw Exception('Gagal memuat similar movie: ${e.message}');
}
}
}

💡 Tips: Dengan Dio, response.data sudah otomatis berupa Map\<String, dynamic\> (tidak perlu json.decode manual), dan error ditangani lewat exception DioException yang lebih informatif

# **Bagian 6 — Halaman List Movie (ListView)**

## **6.1 Movie List Page**

Buat file **lib/pages/movie_list_page.dart**

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../services/api_service_dio.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
const MovieListPage({super.key});

@override
State<MovieListPage> createState() => \_MovieListPageState();
}

class \_MovieListPageState extends State<MovieListPage> {
final ApiServiceDio \_apiService = ApiServiceDio();
late Future<MovieResponse> \_futureMovies;

@override
void initState() {
super.initState();
// Panggil API saat halaman pertama kali dibuka
\_futureMovies = \_apiService.getDiscoverMovies();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Discover Movies'),
),
body: FutureBuilder<MovieResponse>(
future: \_futureMovies,
builder: (context, snapshot) {
// 1. Loading state
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}

          // 2. Error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. Success state
          final movies = snapshot.data!.results;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: movie.posterUrl,
                    width: 56,
                    height: 84,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(movie.voteAverage.toStringAsFixed(1)),
                  ],
                ),
                onTap: () {
                  // Navigasi ke halaman detail, kirim movie.id
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailPage(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );

}
}

# **Bagian 7 — Halaman Detail Movie (Video, Review, Similar)**

## **7.1 Struktur Halaman Detail**

Halaman detail akan menampilkan tiga jenis data sekaligus, sehingga digunakan tiga FutureBuilder/Future terpisah, atau menggabungkannya dengan Future.wait.

- Header: backdrop image, poster, judul, rating, genre

- Trailer: thumbnail video dari endpoint videos

- Reviews: daftar review dari pengguna

- Similar Movies: daftar film serupa (horizontal list)

## **7.2 Movie Detail Page**

Buat file **lib/pages/movie_detail_page.dart**

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import '../models/movie_model.dart';
import '../services/api_service_dio.dart';

class MovieDetailPage extends StatefulWidget {
final int movieId;

const MovieDetailPage({super.key, required this.movieId});

@override
State<MovieDetailPage> createState() => \_MovieDetailPageState();
}

class \_MovieDetailPageState extends State<MovieDetailPage> {
final ApiServiceDio \_apiService = ApiServiceDio();

late Future<MovieDetail> \_futureDetail;
late Future<ReviewResponse> \_futureReviews;
late Future<MovieResponse> \_futureSimilar;

@override
void initState() {
super.initState();
// Panggil 3 endpoint sekaligus saat halaman dibuka
\_futureDetail = \_apiService.getMovieDetail(widget.movieId);
\_futureReviews = \_apiService.getMovieReviews(widget.movieId);
\_futureSimilar = \_apiService.getSimilarMovies(widget.movieId);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: FutureBuilder<MovieDetail>(
future: \_futureDetail,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}
if (snapshot.hasError) {
return Center(child: Text('Error: ${snapshot.error}'));
}

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // ── App bar dengan backdrop image ──
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorWidget: (c, u, e) => Container(color: Colors.grey),
                  ),
                ),
              ),

              // ── Konten utama ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster + info dasar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterUrl,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text('${movie.voteAverage}'),
                                    const SizedBox(width: 12),
                                    Text('${movie.runtime} min'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: movie.genres
                                      .map((g) => Chip(label: Text(g)))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Text('Sinopsis',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(movie.overview),

                      const SizedBox(height: 16),
                      const Text('Trailer',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildVideoSection(movie),

                      const SizedBox(height: 16),
                      const Text('Ulasan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildReviewSection(),

                      const SizedBox(height: 16),
                      const Text('Film Serupa',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildSimilarSection(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

}

Lanjutkan kelas **\_MovieDetailPageState** dengan menambahkan tiga method berikut di bawah method **build()**:

// ── Section: Trailer ──
Widget \_buildVideoSection(MovieDetail movie) {
if (movie.videos.isEmpty) {
return const Text('Trailer tidak tersedia');
}

    final trailer = movie.videos.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: trailer.youtubeThumbnail,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 56,
          ),
        ],
      ),
    );

}

// ── Section: Reviews ──
Widget \_buildReviewSection() {
return FutureBuilder<ReviewResponse>(
future: \_futureReviews,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}
if (snapshot.hasError) {
return Text('Error: ${snapshot.error}');
}

        final reviews = snapshot.data!.results;

        if (reviews.isEmpty) {
          return const Text('Belum ada ulasan');
        }

        return Column(
          children: reviews.take(3).map((review) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.author,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (review.rating != null)
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              Text(' ${review.rating}'),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );

}

// ── Section: Similar Movies ──
Widget \_buildSimilarSection() {
return FutureBuilder<MovieResponse>(
future: \_futureSimilar,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}
if (snapshot.hasError) {
return Text('Error: ${snapshot.error}');
}

        final similar = snapshot.data!.results;

        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final movie = similar[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    // Buka detail movie serupa (replace halaman saat ini)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movieId: movie.id),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      width: 110,
                      height: 160,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

}
}

# **Bagian 8 — Menjalankan Aplikasi (main.dart)**

import 'package:flutter/material.dart';
import 'pages/movie_list_page.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Movie App',
theme: ThemeData(
primarySwatch: Colors.blue,
useMaterial3: true,
),
home: const MovieListPage(),
);
}
}

# **Bagian 9 — Latihan dan Tugas Praktikum**

📝 Tugas Praktikum: Buat kedua versi service (ApiServiceHttp dan ApiServiceDio) dan bandingkan jumlah baris kode serta cara penanganan error pada masing-masing implementasi.

## **Soal Latihan**

1. Implementasikan Latihan Praktikum ini hingga aplikasi movie dapat dijalankan.

2. Customize atau gunakan UI yang telah kalian sudah siapkan pada pertemuan 11 untuk list_movie_page.dart dan detail_movie_page.dart.

3. Tambahkan search bar di MovieListPage yang memanggil endpoint /search/movie?query={keyword} (buat method baru di service).

4. Tambahkan penanganan jika movie.videos kosong dan movie.genres kosong agar UI tidak error/blank.

5. Buat halaman terpisah 'Semua Review' yang menampilkan seluruh data review (bukan hanya 3 teratas) dengan pagination menggunakan field page dan total_pages.

##

##

## **Referensi**

- TMDB API Documentation: developer.themoviedb.org/reference/intro/getting-started

- Package http: pub.dev/packages/http

- Package dio: pub.dev/packages/dio

- Package cached_network_image: pub.dev/packages/cached_network_image
