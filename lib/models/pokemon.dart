List<Pokemon> pokemonsFromJson(dynamic json) =>
    List<Pokemon>.from(json.map((x) => Pokemon.fromJson(x)));

class Pokemon {
  int? entryNumber;
  PokemonSpecies? pokemonSpecies;

  Pokemon({this.entryNumber, this.pokemonSpecies});

  Pokemon.fromJson(Map<String, dynamic> json) {
    entryNumber = json['entry_number'];
    pokemonSpecies = json['pokemon_species'] != null
        ? new PokemonSpecies.fromJson(json['pokemon_species'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entry_number'] = this.entryNumber;
    if (this.pokemonSpecies != null) {
      data['pokemon_species'] = this.pokemonSpecies!.toJson();
    }
    return data;
  }
}

class PokemonSpecies {
  String? name;
  String? url;

  PokemonSpecies({this.name, this.url});

  PokemonSpecies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
