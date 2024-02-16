import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ContentInitalizing.dart';

class TmdbService {
  static String apiKey = '99df30052fbbba30be71c4f7eb9064a1';
  static String url = 'https://api.themoviedb.org/3';
  final String imageUrl = 'https://image.tmdb.org/t/p/w500';


  Future<List<Movie>> getPopularMovies2024() async {
    final response = await http.get(Uri.parse('$url/discover/movie?api_key=$apiKey&primary_release_year=2024&sort_by=popularity.desc'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];      

      List<Movie> movies = data.map((json) {
        return Movie(          
          title: json['title'] ?? 'Unknown Title',
          releaseDate: json['release_date']?? 'Unknown Release Date',        
          imagePath: '$imageUrl${json['poster_path']}',          
           rating: json['vote_average'].toString(),
           overview: json['overview'] ?? 'Not Available',
        );
      }).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies for this year');
    }
  }

  Future<List<Movie>> getHighestGrossingOfAllTime() async {
    final String url = 'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=revenue.desc';
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];            

      List<Movie> movies = data.map((json) {
        return Movie(          
          title: json['title'] ?? 'Unknown Title',
          releaseDate: json['release_date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
          overview: json['overview'] ?? 'Not Available',
        );
      }).toList();
      return movies;
    } else {
      throw Exception('Failed to load highest grossing movies of all time');
    }
  }

   Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$url/movie/now_playing?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((json) {
        return Movie(          
         title: json['title'] ?? 'Unknown Title',
         releaseDate: json['release_date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
          overview: json['overview'] ?? 'Not Available',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load the current cinema listing');
    }
  }
  
  Future<List<TVSeries>> getTVShowsAiringTonight(String countryCode) async {
  final DateTime now = DateTime.now();
  final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.get(Uri.parse('$url/tv/airing_today?api_key=$apiKey&air_date=$formattedDate&region=$countryCode'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];

    List<TVSeries> series = data.map((json) {      
      String title = json['original_name'] ?? 'Unknown Title';      
      String releaseDate = json['first_air_date'] ?? 'Unknown Release Date';
      String imagePath = json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'No Image';
      String rating = json['vote_average']?.toString() ?? '0.0';
      String overview = json['overview'] ?? 'Not Available';

      return TVSeries(        
        title: title,        
        releaseDate: releaseDate,
        imagePath: imagePath,
        rating: rating,
        overview: overview,
      );
    }).toList();

    return series;
  } else {
    throw Exception('Failed to load TV shows airing tonight');
  }
}

Future<List<Movie>> getActorMovies(String actorName) async {
  try {
    // Step 1: Search for the actor
    var actorSearchRes = await http.get(Uri.parse(TmdbService.url + '/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}'));
 
    if (actorSearchRes.statusCode == 200) {
      var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
      if (actorData.isNotEmpty) {
        var actorId = actorData[0]['id'];

        if (actorId != null) {
          // Step 2: Get movies by actor ID
          var moviesRes = await http.get(Uri.parse(
              TmdbService.url + '/person/$actorId/movie_credits?api_key=${TmdbService.apiKey}'));

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
    throw Exception("Something went wrong! $e");
  }
}

Future<List<TVSeries>> getActorTvSeries(String actorName) async {
  try {
    // Step 1: Search for the actor
    var actorSearchRes = await http.get(Uri.parse(TmdbService.url + '/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}'));

    if (actorSearchRes.statusCode == 200) {
      var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
      if (actorData.isNotEmpty) {
        var actorId = actorData[0]['id'];

        if (actorId != null) {
          // Step 2: Get TV series by actor ID
          var tvSeriesRes = await http.get(Uri.parse(
              TmdbService.url + '/person/$actorId/tv_credits?api_key=${TmdbService.apiKey}'));

          if (tvSeriesRes.statusCode == 200) {
            var tvSeriesData = jsonDecode(tvSeriesRes.body)['cast'] as List;          

            return tvSeriesData.map((json) => TVSeries.fromJson(json)).toList();
          } else {
            throw Exception("Failed to get actor's TV series");
          }
        } else {
          throw Exception("Actor ID is null");
        }
      } else {
        throw Exception("Series not found");
      }
    } else {
      throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

Future<List<Content>> searchMoviesAndSeries(String searchTerm) async {
  try {
    // Search for both movies and TV series by name using the 'multi' endpoint
    var searchRes = await http.get(Uri.parse(
        '$url/search/multi?query=${Uri.encodeComponent(searchTerm)}&page=1&api_key=$apiKey'));

    if (searchRes.statusCode == 200) {
      var searchData = jsonDecode(searchRes.body)['results'] as List;

      return searchData
          .map((json) => Content.fromJson(json))
          .where((content) => content.title != null && content.title.isNotEmpty)
          .toList();
    } else {
      throw Exception("Failed to search for movies and TV series. Status code: ${searchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

}