class Movie {
  final int? id;
  final String title;
  final int year;
  final String? genre;
  final String? director;
  final double rating;
  final String? synopsis;
  final String? imgUrl;
  final String? website;

  Movie({
    this.id,
    required this.title,
    required this.year,
    this.genre,
    this.director,
    required this.rating,
    this.synopsis,
    this.imgUrl,
    this.website,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      genre: json['genre'],
      director: json['director'],
      rating: (json['rating'] ?? 0).toDouble(),
      synopsis: json['synopsis'],
      imgUrl: json['imgUrl'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'year': year,
      'genre': genre,
      'director': director,
      'rating': rating,
      'synopsis': synopsis,
      'website': website,
    };
  }
}

class MovieResponse {
  final String status;
  final String message;
  final List<Movie> data;

  MovieResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Movie> movieList = list.map((i) => Movie.fromJson(i)).toList();

    return MovieResponse(
      status: json['status'],
      message: json['message'],
      data: movieList,
    );
  }
}

class SingleMovieResponse {
  final String status;
  final String message;
  final Movie data;

  SingleMovieResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SingleMovieResponse.fromJson(Map<String, dynamic> json) {
    return SingleMovieResponse(
      status: json['status'],
      message: json['message'],
      data: Movie.fromJson(json['data']),
    );
  }
}