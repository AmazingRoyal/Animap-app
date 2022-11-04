import 'package:animap/models/detail_anime.dart';
import 'package:animap/models/season_now.dart';
import 'package:animap/models/top_anime.dart';
import 'package:http/http.dart' as http;

import 'dart:developer' as log_dev;

class RemoteService {

  var malId="";

  RemoteService({
    this.malId = ""
  });

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
  
  Future<DetailAnime?> getDetailAnime() async {
    var client = http.Client();

    var uri = Uri.parse("https://api.jikan.moe/v4/anime/"+malId);
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      log_dev.log("200");
      return detailAnimeFromJson(json);
    }else if(response.statusCode == 304) {
      log_dev.log("304");
    }else if(response.statusCode == 400) {
      log_dev.log("400");
    }else if(response.statusCode == 404) {
      log_dev.log("404");
    }else if(response.statusCode == 405) {
      log_dev.log("405");
    }else if(response.statusCode == 429) {
      log_dev.log("429");
    }else if(response.statusCode == 500) {
      log_dev.log("500");
    }else if(response.statusCode == 503) {
      log_dev.log("503");
    }
    return null;
  }
}