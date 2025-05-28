import 'dart:convert';
import '../models/movie.dart';
import 'package:http/http.dart' as http;

class MovieService {
  static const url = "https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/movies";

  static Future<List<Movie>> getMovie() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => Movie.fromJson(item)).toList();
  } else {
    throw Exception("Gagal memuat data film");
  }
}


  static Future<Map<String, dynamic>> addMovie(Movie newMovie) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newMovie),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMovieById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateMovie(
    Movie updatedMovie,
  ) async {
    final response = await http.put(
      Uri.parse("$url/${updatedMovie.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedMovie),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }
}
