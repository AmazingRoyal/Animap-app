class Favorites 
{
  final int mal_id;
  final String title;
  final String image;
  final num score;
  final String type;
  final int episode;
  final String duration;

  Favorites(
    {
      required this.mal_id,
      required this.title,
      required this.image,
      required this.score,
      required this.type,
      required this.episode,
      required this.duration,
    }
  );

  Map <String, dynamic> toJson() => 
  {
    "mal_id": mal_id,
    "title": title,
    "image": image,
    "score": score,
    "type": type,
    "episode": episode,
    "duration": duration,
  };

  static Favorites fromJson(Map <String, dynamic> json) => Favorites
  (
    mal_id: json['mal_id'],
    title: json['title'],
    image: json['image'],
    score: json['score'],
    type: json['type'],
    episode: json['episode'],
    duration: json['duration'],
  );

}