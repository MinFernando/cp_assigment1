
class Content {
  final String title;
  final String releaseDate;
  final String imagePath;
  final String rating;
  final String overview;
  final String actor;

  Content({
    required this.title,
    required this.releaseDate,
    required this.imagePath,
    required this.rating,
    required this.overview,
    required this.actor
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    // Check if the entry is a TV series
    if (json['original_name'] != null) {
      return TVSeries.fromJson(json);
    } else {
      // Assume it's a movie
      return Movie.fromJson(json);
    }
  }
}

class Movie extends Content {
  Movie({
    required String title,
    required String releaseDate,
    required String imagePath,
    required String rating,
    required String overview,
    required String actor,
  }) : super(
          title: title,
          releaseDate: releaseDate,
          imagePath: imagePath,
          rating: rating,
          overview: overview,
          actor:actor,
        );

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown Title',
      releaseDate: json['release_date'] ?? 'Unknown Release Date',
      imagePath: json['poster_path'] ?? '',
      rating: json['vote_average']?.toString() ?? '0.0',
      overview: json['overview'] ?? 'Not Available',
      actor: json["actor"] ?? 'Not known',
    );
  }
}

class TVSeries extends Content {
  TVSeries({
    required String title,
    required String releaseDate,
    required String imagePath,
    required String rating,
    required String overview,
    required String actor,
  }) : super
      (
        title: title,
        releaseDate: releaseDate,
        imagePath: imagePath,
        rating: rating,
        overview: overview,
        actor: actor,
      );

  factory TVSeries.fromJson(Map<String, dynamic> json) {
    return TVSeries(
      title: json['original_name'] ?? 'Unknown Title',
      releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
      imagePath: json['poster_path'] ?? 'No Image Available',
      rating: json['vote_average']?.toString() ?? '0.0',
      overview: json['overview'] ?? 'Not Available',
      actor: json["actor"] ?? 'Not known',
    );
  }
}
