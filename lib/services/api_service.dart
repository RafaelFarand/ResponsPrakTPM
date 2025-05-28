import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = 'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1';

  static Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies'));
      
      if (response.statusCode == 200) {
        final movieModel = MovieModel.fromJson(json.decode(response.body));
        return movieModel.data ?? [];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Movie> getMovieById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movies/$id'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Jika response berupa object langsung
        if (jsonData is Map<String, dynamic>) {
          return Movie.fromJson(jsonData);
        }
        // Jika response berupa MovieModel
        else {
          final movieModel = MovieModel.fromJson(jsonData);
          if (movieModel.data != null && movieModel.data!.isNotEmpty) {
            return movieModel.data!.first;
          }
        }
        throw Exception('Movie not found');
      } else {
        throw Exception('Failed to load movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> createMovie(Movie movie) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/movies'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.toJson()),
      );
      
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateMovie(String id, Movie movie) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/movies/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.toJson()),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMovie(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/movies/$id'));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
