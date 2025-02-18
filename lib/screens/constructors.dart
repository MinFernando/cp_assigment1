import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ContentInitalizing.dart';

class TmdbService {
  static String apiKey = '99df30052fbbba30be71c4f7eb9064a1';
  static String url = 'https://api.themoviedb.org/3';
  static String imageUrl = 'https://image.tmdb.org/t/p/w500';


  Future<List<Movie>> getPopularMovies2024() async {

    try{
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
           actor: json["sctor"] ?? "unknown",

        );
      }).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies for this year');
    }
    }catch (e){
      throw Exception('Failed to fetch data. Check your internet connection and try again.');
    }
  }

  Future<List<Movie>> getHighestGrossingOfAllTime() async {

    try{
    final response = await http.get(Uri.parse('$url/discover/movie?api_key=$apiKey&primary_release_year=2015&sort_by=popularity.desc'));
  

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];            

      List<Movie> movies = data.map((json) {
        return Movie(          
          title: json['title'] ?? 'Unknown Title',
          releaseDate: json['release_date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
          overview: json['overview'] ?? 'Not Available',
          actor: json["sctor"] ?? "unknown",

        );
      }).toList();
      return movies;
    } else {
      throw Exception('Failed to load highest grossing movies of all time');
    }
   } catch (e) {
    throw Exception("Failed to fetch data. Check your internet connection and try again. ");
  }
  }

   Future<List<Movie>> getNowPlayingMovies() async {

    try{
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
          actor: json["sctor"] ?? "unknown",

        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load the current cinema listing');
    }
   } catch (e) {
    throw Exception("Failed to fetch data. Check your internet connection and try again. ");
  }
  }
  
  Future<List<TVSeries>> getTVShowsAiringTonight(String countryCode) async {
    try{
      final DateTime now = DateTime.now();
      final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final response = await http.get(Uri.parse('$url/tv/airing_today?api_key=$apiKey&air_date=$formattedDate&region=$countryCode'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];

        List<TVSeries> series = data.map((json) {      
          String title = json['original_name'] ?? 'Unknown Title';      
          String releaseDate = json['first_air_date'] ?? 'Unknown Release Date';
          String imagePath = json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'Not available';
          String rating = json['vote_average']?.toString() ?? '0.0';
          String overview = json['overview'] ?? 'Not Available';
          String actor = json["actor"] ?? "unknown";

          return TVSeries(        
            title: title,        
            releaseDate: releaseDate,
            imagePath: imagePath,
            rating: rating,
            overview: overview,
            actor: actor,
          );
        }).toList();

        return series;
      } else {
        throw Exception('Failed to load TV shows airing tonight');
      }
    } catch (e) {
        throw Exception("Failed to fetch data. Check your internet connection and try again. ");
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
    throw Exception("Failed to fetch data. Check your internet connection and try again. ");
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

            return tvSeriesData.map((json) {
              // Check if the image URL is available
              String? imagePath = json['poster_path'] != null ? '${TmdbService.imageUrl}${json['poster_path']}' : null;

              // Map the JSON data to TVSeries objects
              return TVSeries(
                title: json['original_name'] ?? 'Unknown Title',
                releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
                imagePath : json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'Not available',
                rating: json['vote_average']?.toString() ?? '0.0',
                overview: json['overview'] ?? 'Not Available',
                actor: actorName,
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
    throw Exception("Failed to fetch data. Check your internet connection and try again. Error: $e");
  }
}


Future<List<dynamic>> searchMoviesAndSeries(String searchTerm) async {
  try {
    var searchRes = await http.get(Uri.parse(
        '$url/search/multi?query=${Uri.encodeComponent(searchTerm)}&page=1&api_key=$apiKey'));

    if (searchRes.statusCode == 200) {
      var searchData = jsonDecode(searchRes.body)['results'] as List;

      return searchData.map((json) {
        if (json['media_type'] == 'movie') {
          return Movie.fromJson(json);
        } else if (json['media_type'] == 'tv') {
          return TVSeries.fromJson(json);
        } else if (json['media_type'] == 'person') {
          return Content.fromJson(json);
        } else {
          return null;
        }
      }).where((content) => content != null).toList();
    } else {
      throw Exception("Failed to search for movies and TV series. Status code: ${searchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Failed to fetch data. Check your internet connection and try again. Error: $e");
  }
}

}