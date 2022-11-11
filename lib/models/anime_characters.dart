// To parse this JSON data, do
//
//     final animeCharacters = animeCharactersFromJson(jsonString);

import 'dart:convert';

AnimeCharacters animeCharactersFromJson(String str) => AnimeCharacters.fromJson(json.decode(str));

String animeCharactersToJson(AnimeCharacters data) => json.encode(data.toJson());

class AnimeCharacters {
    AnimeCharacters({
      this.data,
    });

    List<Datum>? data;

    factory AnimeCharacters.fromJson(Map<String, dynamic> json) => AnimeCharacters(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.character,
        required this.role,
        required this.voiceActors,
    });

    Character character;
    String role;
    List<VoiceActor> voiceActors;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        character: Character.fromJson(json["character"]),
        role: json["role"],
        voiceActors: List<VoiceActor>.from(json["voice_actors"].map((x) => VoiceActor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "character": character.toJson(),
        "role": role,
        "voice_actors": List<dynamic>.from(voiceActors.map((x) => x.toJson())),
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
    Map<String, Img> images;
    String name;

    factory Character.fromJson(Map<String, dynamic> json) => Character(
        malId: json["mal_id"] ?? 0,
        url: json["url"] ?? "null",
        images: Map.from(json["images"]).map((k, v) => MapEntry<String, Img>(k, Img.fromJson(v))),
        name: json["name"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "name": name,
    };
}

class Img {
    Img({
        required this.imageUrl,
        required this.smallImageUrl,
    });

    String imageUrl;
    String smallImageUrl;

    factory Img.fromJson(Map<String, dynamic> json) => Img(
        imageUrl: json["image_url"] ?? "null",
        smallImageUrl: json["small_image_url"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
    };
}

class VoiceActor {
    VoiceActor({
        required this.person,
        required this.language,
    });

    Person person;
    String language;

    factory VoiceActor.fromJson(Map<String, dynamic> json) => VoiceActor(
        person: Person.fromJson(json["person"]),
        language: json["language"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "person": person.toJson(),
        "language": language,
    };
}

class Person {
    Person({
        required this.malId,
        required this.url,
        required this.images,
        required this.name,
    });

    int malId;
    String url;
    Images images;
    String name;

    factory Person.fromJson(Map<String, dynamic> json) => Person(
        malId: json["mal_id"]  ?? 0,
        url: json["url"] ?? "null",
        images: Images.fromJson(json["images"]),
        name: json["name"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": images.toJson(),
        "name": name,
    };
}

class Images {
    Images({
        required this.jpg,
    });

    Jpg jpg;

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        jpg: Jpg.fromJson(json["jpg"]),
    );

    Map<String, dynamic> toJson() => {
        "jpg": jpg.toJson(),
    };
}

class Jpg {
    Jpg({
        required this.imageUrl,
    });

    String imageUrl;

    factory Jpg.fromJson(Map<String, dynamic> json) => Jpg(
        imageUrl: json["image_url"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
    };
}
