import 'package:animap/models/season_now.dart';
import 'package:animap/models/top_anime.dart';
import 'package:http/http.dart' as http;

class RemoteService {
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
}