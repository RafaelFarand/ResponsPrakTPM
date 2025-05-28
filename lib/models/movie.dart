class MovieModel {
  String? status;
  String? message;
  List<Movie>? data;
  
  MovieModel({this.status, this.message, this.data});
  
  MovieModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Movie>[];
      json['data'].forEach((v) {
        data!.add(Movie.fromJson(v));
      });
    }
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movie {
  String? id;
  String? title;
  String? year;
  double? rating;
  String? imgUrl;
  String? genre;
  String? director;
  String? synopsis;
  String? movieUrl;
  
  Movie({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.imgUrl,
    this.genre,
    this.director,
    this.synopsis,
    this.movieUrl,
  });
  
  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    year = json['year']?.toString();
    rating = double.tryParse(json['rating'].toString());
    imgUrl = json['imgUrl']?.toString();
    genre = json['genre']?.toString();
    director = json['director']?.toString();
    synopsis = json['synopsis']?.toString();
    movieUrl = json['movieUrl']?.toString();
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['rating'] = rating;
    data['imgUrl'] = imgUrl;
    data['genre'] = genre;
    data['director'] = director;
    data['synopsis'] = synopsis;
    data['movieUrl'] = movieUrl;
    return data;
  }
}