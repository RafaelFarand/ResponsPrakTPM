import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'create_page.dart';

class DetailPage extends StatefulWidget {
  final int movieId;

  const DetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Movie? movie;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMovieDetail();
  }

  Future<void> _loadMovieDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      Movie fetchedMovie = await ApiService.getMovieById(widget.movieId);
      setState(() {
        movie = fetchedMovie;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load movie details: $e';
      });
    }
  }

  Future<void> _deleteMovie() async {
    bool confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete) {
      try {
        bool success = await ApiService.deleteMovie(widget.movieId);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Movie deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete movie'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting movie: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this movie?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink.shade700),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Movie Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: movie != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePage(movie: movie),
                      ),
                    ).then((result) {
                      if (result == true) _loadMovieDetail();
                    });
                  },
                ),
                IconButton(icon: const Icon(Icons.delete), onPressed: _deleteMovie),
              ]
            : [],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorUI()
              : _buildDetailUI(),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Error', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadMovieDetail, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildDetailUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Image
          SizedBox(
            width: double.infinity,
            height: 300,
            child: movie!.imgUrl != null && movie!.imgUrl!.isNotEmpty
                ? Image.network(
                    movie!.imgUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),

          // Movie Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  movie!.title,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                ),
                const SizedBox(height: 12),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      '${movie!.rating}/10',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Movie Info Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow('Year:', movie!.year.toString()),
                        if (movie!.genre?.isNotEmpty ?? false)
                          _buildInfoRow('Genre:', movie!.genre!),
                        if (movie!.director?.isNotEmpty ?? false)
                          _buildInfoRow('Director:', movie!.director!),
                      ],
                    ),
                  ),
                ),

                // Synopsis
                if (movie!.synopsis?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        movie!.synopsis!,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.movie, size: 64, color: Colors.grey),
      ),
    );
  }
}
