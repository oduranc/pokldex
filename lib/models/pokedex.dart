List<Pokedex> pokedexFromJson(dynamic json) =>
    List<Pokedex>.from(json.map((x) => Pokedex.fromJson(x)));

class Pokedex {
  String? name;
  String? url;

  Pokedex({this.name, this.url});

  Pokedex.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nam'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
