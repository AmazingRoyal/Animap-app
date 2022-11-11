import 'package:animap/models/detail_anime.dart';
import 'package:animap/models/person_voices.dart';
import 'package:animap/models/search_anime.dart';
import 'package:animap/models/season_now.dart';
import 'package:animap/models/top_anime.dart';
import 'package:animap/models/anime_characters.dart';
import 'package:animap/models/upcoming_anime.dart';
import 'package:http/http.dart' as http;

import 'dart:developer' as log_dev;

class RemoteService {

  var malId = "";
  var query = "";

  RemoteService({
    this.malId = "",
    this.query = ""
  });

  // TOP ANIME
  Future <TopAnime?> getTopAnime() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/top/anime");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;

      return topAnimeFromJson(json);
    }
    return null;
  }

  // SEASON NOW
  Future<SeasonNow?> getSeasonNow() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/seasons/now");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;

      return seasonNowFromJson(json);
    }
    return null;
  }
  
  // DETAIL ANIME
  Future<DetailAnime?> getDetailAnime() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/anime/$malId");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      
      return detailAnimeFromJson(json);
    }
    return null;
  }

  // SEARCH ANIME
  Future<SearchAnime?> getSearchAnime() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/anime/?q=$query");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      
      return searchAnimeFromJson(json);
    }
    return null;
  }

  // ANIME CHARACTERS
  Future<AnimeCharacters?> getAnimeCharacters() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/anime/$malId/characters");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      
      return animeCharactersFromJson(json);
    }
    return null;
  }

  // UPCOMING ANIME
  Future<UpcomingAnime?> getUpcomingAnime() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/seasons/upcoming");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      
      return upcomingAnimeFromJson(json);
    }
    return null;
  }

  // PERSON VOICES
  Future<PersonVoices?> getPersonVoices() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/people/$malId/voices");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      
      return personVoicesFromJson(json);
    }
    return null;
  }

}

