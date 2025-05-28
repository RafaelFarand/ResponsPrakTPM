import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import 'loginpage.dart';
import 'tambahpage.dart';
import '../services/movie_service.dart';
import 'detailpage.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halo, ${widget.username}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => TambahPage()));
        },
      ),
      body: FutureBuilder<List<Movie>>(
  future: MovieService.getMovie(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData) {
      final items = snapshot.data!;

      if (items.isEmpty) {
        return Center(child: Text("Belum ada data film."));
      }

      return GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final movie = items[index];

          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(),
                  settings: RouteSettings(arguments: movie),
                ),
              );

              if (result == true) {
                setState(() {}); // refresh
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // ignore: unnecessary_null_comparison
                image: movie.imgUrl != null
                    ? DecorationImage(
                        image: NetworkImage(movie.imgUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("⭐ ${movie.rating.toString()}"),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(child: Text("Tidak ada data."));
    }
  },
),

    );
  }
}
