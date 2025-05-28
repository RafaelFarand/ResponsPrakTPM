import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = 'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1';

  // Get all movies
  static Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies'));
      
      if (response.statusCode == 200) {
        final movieResponse = MovieResponse.fromJson(json.decode(response.body));
        return movieResponse.data;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get movie by ID
  static Future<Movie> getMovieById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/$id'));
      
      if (response.statusCode == 200) {
        final movieResponse = SingleMovieResponse.fromJson(json.decode(response.body));
        return movieResponse.data;
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create new movie
  static Future<bool> createMovie(Movie movie) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/movies'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(movie.toJson()),
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update movie
  static Future<bool> updateMovie(int id, Movie movie) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/movies/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(movie.toJson()),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete movie
  static Future<bool> deleteMovie(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/movies/$id'));
      
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Login simulation (since no actual login endpoint provided)
  static Future<bool> login(String username, String password) async {
    // Simulate login - in real app, this would call actual login endpoint
    await Future.delayed(Duration(seconds: 1));
    return password == '12345678'; // Simple validation
  }
}