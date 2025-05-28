class Movie {
  final String id;
  final String title;
  final String year;
  final String rating;
  final String imgUrl;
  final List<String> genre;
  final String director;
  final String synopsis;
  final String movieUrl;

  Movie({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.rating,
    required this.genre,
    required this.director,
    required this.synopsis,
    required this.year,
    required this.movieUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      year: json['year'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      rating: json['rating'].toString(),
      genre: List<String>.from(json['genre'] ?? []),
      director: json['director'] ?? '',
      synopsis: json['synopsis'] ?? '',
      movieUrl: json['movieUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'imgUrl': imgUrl,
      'rating': rating,
      'genre': genre,
      'director': director,
      'synopsis': synopsis,
      'movieUrl': movieUrl,
    };
  }
}