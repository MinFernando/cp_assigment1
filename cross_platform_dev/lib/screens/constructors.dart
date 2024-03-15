import 'dart:convert'; // needed for JSON parsing
import 'package:cp_assignment/screens/content_initializing.dart'; 
import 'package:http/http.dart' as http; // needed for making HTTP requests

class TmdbService {
  static String apiKey = '99df30052fbbba30be71c4f7eb9064a1'; // API key for TMDB
  static String url = 'https://api.themoviedb.org/3'; // Base URL for TMDB API
  static String imageUrl = 'https://image.tmdb.org/t/p/w500'; // Base URL for movie image retrieval

  // Method to fetch popular movies for the current year
  Future<List<Movie>> getPopularMoviesThisYear() async {
    final int currentYear = DateTime.now().year; // Get the current year

    try {
      final response = await http.get(Uri.parse('$url/discover/movie?api_key=$apiKey&primary_release_year=$currentYear&sort_by=popularity.desc')); // HTTP GET request to fetch popular movies

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results']; // Parsing JSON response

        List<Movie> movies = data.map((json) {
          // Mapping JSON data to Movie objects
          return Movie(
            title: json['title'] ?? 'Unknown Title',
            releaseDate: json['release_date'] ?? 'Unknown Release Date',
            imagePath: '$imageUrl${json['poster_path']}',
            rating: json['vote_average'].toString(),
            overview: json['overview'] ?? 'Not Available',
          );
        }).toList();
        return movies;
      } else {
        throw Exception('Failed to load popular movies for this year');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to fetch highest grossing movies of all time
  Future<List<Movie>> getHighestGrossingOfAllTime() async {
    try {
      final response = await http.get(Uri.parse('$url/discover/movie?api_key=$apiKey&primary_release_year=2015&sort_by=popularity.desc')); // HTTP GET request to fetch highest grossing movies

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results']; // Parsing JSON response

        List<Movie> movies = data.map((json) {
          // Mapping JSON data to Movie objects
          return Movie(
            title: json['title'] ?? 'Unknown Title',
            releaseDate: json['release_date'] ?? 'Unknown Release Date',
            imagePath: '$imageUrl${json['poster_path']}',
            rating: json['vote_average'].toString(),
            overview: json['overview'] ?? 'Not Available',
          );
        }).toList();
        return movies;
      } else {
        throw Exception('Failed to load highest grossing movies of all time');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to fetch currently playing movies in the cinema
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response = await http.get(Uri.parse('$url/movie/now_playing?api_key=$apiKey')); // HTTP GET request to fetch now playing movies

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results']; // Parsing JSON response

        List<Movie> movies = data.map((json) {
          // Mapping JSON data to Movie objects
          return Movie(
            title: json['title'] ?? 'Unknown Title',
            releaseDate: json['release_date'] ?? 'Unknown Release Date',
            imagePath: '$imageUrl${json['poster_path']}',
            rating: json['vote_average'].toString(),
            overview: json['overview'] ?? 'Not Available',
          );
        }).toList();

        return movies;
      } else {
        throw Exception('Failed to load the current cinema listing');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to fetch TV shows airing tonight based on country code
  Future<List<TVSeries>> getTVShowsAiringTonight(String countryCode) async {
    try {
      final DateTime now = DateTime.now();
      final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final response = await http.get(Uri.parse('$url/tv/airing_today?api_key=$apiKey&air_date=$formattedDate&region=$countryCode')); // HTTP GET request to fetch TV shows airing tonight

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results']; // Parsing JSON response

        List<TVSeries> series = data.map((json) {
          // Mapping JSON data to TVSeries objects
          return TVSeries(
            title: json['original_name'] ?? 'Unknown Title',
            releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
            imagePath: json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'Not available',
            rating: json['vote_average']?.toString() ?? '0.0',
            overview: json['overview'] ?? 'Not Available',
          );
        }).toList();

        return series;
      } else {
        throw Exception('Failed to load TV shows airing tonight');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to fetch movies featuring a specific actor
  Future<List<Movie>> getActorMovies(String actorName) async {
    try {
      var actorSearchRes = await http.get(Uri.parse('${TmdbService.url}/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}')); // Searching for the actor

      if (actorSearchRes.statusCode == 200) {
        var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
        if (actorData.isNotEmpty) {
          var actorId = actorData[0]['id'];

          if (actorId != null) {
            var moviesRes = await http.get(Uri.parse('${TmdbService.url}/person/$actorId/movie_credits?api_key=${TmdbService.apiKey}')); // Getting movies by actor ID

            if (moviesRes.statusCode == 200) {
              return (jsonDecode(moviesRes.body)['cast'] as List)
                  .map((json) => Movie.fromJson(json))
                  .toList();
            } else {
              throw Exception("Failed to get actor's movies");
            }
          } else {
            throw Exception("Actor ID is null");
          }
        } else {
          throw Exception("Movie not found");
        }
      } else {
        throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to fetch TV series featuring a specific actor
  Future<List<TVSeries>> getActorTvSeries(String actorName) async {
    try {
      var actorSearchRes = await http.get(Uri.parse('${TmdbService.url}/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}'));

      if (actorSearchRes.statusCode == 200) {
        var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
        if (actorData.isNotEmpty) {
          var actorId = actorData[0]['id'];

          if (actorId != null) {
            var tvSeriesRes = await http.get(Uri.parse('${TmdbService.url}/person/$actorId/tv_credits?api_key=${TmdbService.apiKey}'));

            if (tvSeriesRes.statusCode == 200) {
              var tvSeriesData = jsonDecode(tvSeriesRes.body)['cast'] as List;

              return tvSeriesData.map((json) {
                // Mapping JSON data to TVSeries objects
                return TVSeries(
                  title: json['original_name'] ?? 'Unknown Title',
                  releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
                  imagePath: json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'Not available',
                  rating: json['vote_average']?.toString() ?? '0.0',
                  overview: json['overview'] ?? 'Not Available',
                );
              }).toList();
            } else {
              throw Exception("Failed to get actor's TV series");
            }
          } else {
            throw Exception("Actor ID is null");
          }
        } else {
          throw Exception("Actor not found");
        }
      } else {
        throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }

  // Method to search for movies and TV series based on search term
  Future<List<dynamic>> searchMoviesAndSeries(String searchTerm) async {
    try {
      var searchRes = await http.get(Uri.parse('$url/search/multi?query=${Uri.encodeComponent(searchTerm)}&page=1&api_key=$apiKey'));

      if (searchRes.statusCode == 200) {
        var searchData = jsonDecode(searchRes.body)['results'] as List;

        // filter out any data related to a person
        var filteredSearchData = searchData.where((json) => json['media_type'] != 'person').toList();

        return filteredSearchData.map((json) {
          if (json['media_type'] == 'movie') {
            return Movie.fromJson(json);
          } else if (json['media_type'] == 'tv') {
            return TVSeries.fromJson(json);
          } else {
            return null;
          }
        }).where((content) => content != null).toList(); // Ensure null content is still filtered out
      } else {
        throw Exception("Failed to search for movies and TV series. Status code: ${searchRes.statusCode}");
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection and try again. Error: $e');
    }
  }
}
