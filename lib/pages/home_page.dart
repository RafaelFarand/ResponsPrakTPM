import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'create_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool isLoading = true;
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMovies();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _loadMovies() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Movie> fetchedMovies = await ApiService.getMovies();
      setState(() {
        movies = fetchedMovies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackbar('Failed to load movies: $e');
    }
  }

  Future<void> _deleteMovie(int movieId) async {
    bool confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete) {
      try {
        bool success = await ApiService.deleteMovie(movieId);
        if (success) {
          _showSuccessSnackbar('Movie deleted successfully');
          _loadMovies(); // Refresh the list
        } else {
          _showErrorSnackbar('Failed to delete movie');
        }
      } catch (e) {
        _showErrorSnackbar('Error deleting movie: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text('Are you sure you want to delete this movie?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        elevation: 4,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.person, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Welcome, $username'),
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMovies,
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.pink))
                : movies.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No movies found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pull to refresh or add a new movie',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.pink.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 60,
                            height: 90,
                            color: Colors.grey.shade200,
                            child:
                                movie.imgUrl != null && movie.imgUrl!.isNotEmpty
                                    ? Image.network(
                                      movie.imgUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    )
                                    : Center(
                                      child: Icon(
                                        Icons.movie,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.pink.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Year: ${movie.year}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${movie.rating}/10',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CreatePage(movie: movie),
                                ),
                              ).then((_) => _loadMovies());
                            } else if (value == 'delete') {
                              _deleteMovie(movie.id!);
                            }
                          },
                          itemBuilder:
                              (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.pink),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailPage(movieId: movie.id!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePage()),
          ).then((_) => _loadMovies());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
