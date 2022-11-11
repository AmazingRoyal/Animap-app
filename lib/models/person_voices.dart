// To parse this JSON data, do
//
//     final personVoices = personVoicesFromJson(jsonString);

import 'dart:convert';

PersonVoices personVoicesFromJson(String str) => PersonVoices.fromJson(json.decode(str));

String personVoicesToJson(PersonVoices data) => json.encode(data.toJson());

class PersonVoices {
    PersonVoices({
        required this.data,
    });

    List<Datum> data;

    factory PersonVoices.fromJson(Map<String, dynamic> json) => PersonVoices(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.role,
        required this.anime,
        required this.character,
    });

    String role;
    Anime anime;
    Character character;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        role: json["role"] ?? "null",
        anime: Anime.fromJson(json["anime"]),
        character: Character.fromJson(json["character"]),
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "anime": anime.toJson(),
        "character": character.toJson(),
    };
}

class Anime {
    Anime({
        required this.malId,
        required this.url,
        required this.images,
        required this.title,
    });

    int malId;
    String url;
    Map<String, AnimeImage> images;
    String title;

    factory Anime.fromJson(Map<String, dynamic> json) => Anime(
        malId: json["mal_id"] ?? 0,
        url: json["url"] ?? "null",
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, AnimeImage>(k, AnimeImage.fromJson(v))),
        title: json["title"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "title": title,
    };
}

class AnimeImage {
    AnimeImage({
        required this.imageUrl,
        required this.smallImageUrl,
        required this.largeImageUrl,
    });

    String imageUrl;
    String smallImageUrl;
    String largeImageUrl;

    factory AnimeImage.fromJson(Map<String, dynamic> json) => AnimeImage(
        imageUrl: json["image_url"] ?? "null",
        smallImageUrl: json["small_image_url"] ?? "null",
        largeImageUrl: json["large_image_url"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "large_image_url": largeImageUrl,
    };
}

class Character {
    Character({
        required this.malId,
        required this.url,
        required this.images,
        required this.name,
    });

    int malId;
    String url;
    Map<String, CharacterImage> images;
    String name;

    factory Character.fromJson(Map<String, dynamic> json) => Character(
        malId: json["mal_id"] ?? 0,
        url: json["url"] ?? "null",
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, CharacterImage>(k, CharacterImage.fromJson(v))),
        name: json["name"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "name": name,
    };
}

class CharacterImage {
    CharacterImage({
        required this.imageUrl,
        required this.smallImageUrl,
    });

    String imageUrl;
    String smallImageUrl;

    factory CharacterImage.fromJson(Map<String, dynamic> json) => CharacterImage(
        imageUrl: json["image_url"] ?? "null",
        smallImageUrl: json["small_image_url"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
    };
}
