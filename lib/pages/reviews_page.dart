import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/api_service_dio.dart';
import '../widgets/glass_container.dart';

class ReviewsPage extends StatefulWidget {
  final int movieId;

  const ReviewsPage({super.key, required this.movieId});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final ApiServiceDio _apiService = ApiServiceDio();
  final ScrollController _scrollController = ScrollController();

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchReviews();
      }
    });
  }

  Future<void> _fetchReviews() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.getMovieReviews(
        widget.movieId,
        page: _currentPage,
      );

      setState(() {
        _currentPage++;
        _reviews.addAll(response.results);
        _totalPages = response.totalPages;

        if (_currentPage > _totalPages) {
          _hasMore = false;
        }
      });
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildStars(double? rating) {
    if (rating == null) return [];
    List<Widget> stars = [];
    double scaledRating = rating / 2;
    int fullStars = scaledRating.floor();
    bool hasHalfStar = (scaledRating - fullStars) >= 0.5;
    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.orange, size: 14));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.orange, size: 14));
      } else {
        stars.add(
          const Icon(Icons.star_border, color: Colors.orange, size: 14),
        );
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Semua Review',
          style: TextStyle(
            color: Colors.black,
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _reviews.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reviews.isEmpty
              ? const Center(
                  child: Text('Tidak ada review untuk film ini.'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _reviews.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _reviews.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final review = _reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  review.author.isNotEmpty
                                      ? review.author[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (review.rating != null)
                                      Row(
                                        children: _buildStars(review.rating),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review.content,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
