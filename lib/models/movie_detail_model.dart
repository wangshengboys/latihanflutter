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
  final List<String> cast;

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
    required this.cast,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    // Ekstrak nama aktor dari credits -> cast
    List<String> castList = [];
    if (json['credits'] != null && json['credits']['cast'] != null) {
      final castData = json['credits']['cast'] as List;
      // Ambil 5 aktor pertama saja agar tidak terlalu panjang
      castList = castData
          .take(5)
          .map((c) => c['name'] as String)
          .toList();
    }

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
      videos: json['videos'] != null && json['videos']['results'] != null
          ? (json['videos']['results'] as List)
              .map((v) => VideoModel.fromJson(v))
              .toList()
          : [],
      cast: castList,
    );
  }

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/original$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';
}
