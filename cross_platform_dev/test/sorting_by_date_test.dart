import 'package:flutter_test/flutter_test.dart';

// Movie class
class Movie {
  String id;
  String title;
  String releaseDate;
  String imagePath;
  String rating;
  String overview;

  Movie({required this.id, required this.title, required this.releaseDate, required this.imagePath, required this.rating, required this.overview});
}

// Mock data generator function
List<Movie> getMockMovies() {
  return [
    Movie(id: '1', title: 'C Movie', releaseDate: '2003-01-01', imagePath: '', rating: '', overview: ''),
    Movie(id: '2', title: 'A Movie', releaseDate: '2001-01-01', imagePath: '', rating: '', overview: ''),
    Movie(id: '3', title: 'B Movie', releaseDate: '2002-01-01', imagePath: '', rating: '', overview: ''),
  ];
}

void sortMovies(List<Movie> movies, {bool sortByDate = false, bool sortByTitle = false}) {
  if (sortByDate) {
    movies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  } else if (sortByTitle) {
    movies.sort((a, b) => a.title.compareTo(b.title));
  }
}
void main() {
  group('Sorting movies', () {
    // Initialize movies with an empty list
    List<Movie> movies = [];

    setUp(() {
      // Assign actual mock data before each test
      movies = getMockMovies();
    });

    test('sorts movies by release date correctly', () {
      sortMovies(movies, sortByDate: true);
      expect(movies[0].releaseDate, '2001-01-01');
      expect(movies[1].releaseDate, '2002-01-01');
      expect(movies[2].releaseDate, '2003-01-01');
    });
  });
}