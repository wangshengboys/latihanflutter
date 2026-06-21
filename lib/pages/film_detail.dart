import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie_detail_model.dart';
import '../services/api_service_dio.dart';
import '../widgets/glass_container.dart';
import 'reviews_page.dart';

class FilmDetailPage extends StatefulWidget {
  final int movieId;

  const FilmDetailPage({super.key, required this.movieId});

  @override
  State<FilmDetailPage> createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  final ApiServiceDio _apiService = ApiServiceDio();
  late Future<MovieDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiService.getMovieDetail(widget.movieId);
  }

  List<Widget> _buildStars(double rating) {
    List<Widget> stars = [];
    double scaledRating = rating / 2;
    int fullStars = scaledRating.floor();
    bool hasHalfStar = (scaledRating - fullStars) >= 0.5;
    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.orange, size: 24));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.orange, size: 24));
      } else {
        stars.add(
          const Icon(Icons.star_border, color: Colors.orange, size: 24),
        );
      }
    }
    return stars;
  }

  Future<void> _launchVideo(String videoKey) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (!await launchUrl(url)) {
      debugPrint('Tidak dapat membuka video: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieDetail>(
      future: _futureDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final movie = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: const GlassContainer(
              borderRadius: 0,
              blur: 15,
              child: SizedBox.expand(),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl.isNotEmpty
                      ? movie.backdropUrl
                      : movie.posterUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie.genres.isNotEmpty
                            ? movie.genres.join(', ')
                            : 'Genre tidak tersedia',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          ..._buildStars(movie.voteAverage),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Tanggal Rilis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Pemeran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        movie.cast.isNotEmpty
                            ? movie.cast.join(', ')
                            : 'Tidak ada data pemeran',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'Sinopsis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie.overview,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        'Trailer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildVideoSection(context, movie),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewsPage(movieId: movie.id),
                              ),
                            );
                          },
                          child: const Text(
                            'Lihat Semua Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoSection(BuildContext context, MovieDetail movie) {
    if (movie.videos.isEmpty) {
      return const Text('Trailer tidak tersedia',
          style: TextStyle(color: Colors.black54));
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movie.videos.length,
        itemBuilder: (context, index) {
          final video = movie.videos[index];
          return GestureDetector(
            onTap: () {
              _launchVideo(video.key);
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(video.youtubeThumbnail),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 40),
              ),
            ),
          );
        },
      ),
    );
  }
}
