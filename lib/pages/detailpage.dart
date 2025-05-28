import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'editpage.dart';

class DetailPage extends StatefulWidget {
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Movie movie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movie = ModalRoute.of(context)!.settings.arguments as Movie;
  }

  void refreshMovie(Movie newMovie) {
    setState(() {
      movie = newMovie;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###", "id_ID");
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Film"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditPage(movie: movie)),
              );
              if (updated == true) {
                final refreshed = Movie.fromJson(await MovieService.getMovieById(int.parse(movie.id)));
                refreshMovie(refreshed);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Hapus Film"),
                  content: Text("Yakin ingin menghapus film ini?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Batal")),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Hapus"),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await MovieService.deleteMovie(int.parse(movie.id));
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageContainer(movie),
              _detailContainer(movie, formatter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageContainer(Movie movie) {
  return Container(
    padding: EdgeInsets.all(12),
    width: double.infinity,
    child: movie.imgUrl.isNotEmpty
        ? Image.network(
            movie.imgUrl,
            fit: BoxFit.contain, 
          )
        : Image.asset(
            'assets/placeholder.png',
            fit: BoxFit.contain,
          ),
  );
}

  Widget _detailContainer(Movie movie, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(movie.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, size: 18, color: Colors.amber),
              SizedBox(width: 4),
              Text("${movie.rating}", style: TextStyle(fontSize: 14)),
              SizedBox(width: 16),
              Text(movie.year, style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text("Genre: ${movie.genre.join(', ')}", style: TextStyle(fontSize: 16)),
          Text("year: ${movie.year}", style: TextStyle(fontSize: 16)),
          Text("Sutradara: ${movie.director}", style: TextStyle(fontSize: 16)),
          Text("sinopsis: ${movie.synopsis}", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Text(movie.title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
