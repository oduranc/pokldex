import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokldex/models/pokemon_data.dart';
import 'package:pokldex/models/pokemon_specie.dart';
import 'package:pokldex/models/pokedex.dart';
import 'package:pokldex/models/pokemon.dart';
import 'package:pokldex/models/specific_data.dart';
import 'package:pokldex/util/constants.dart';

class Networking {
  Future<http.Response?> fetchData(String modelName, String data) async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse('$url/$modelName/$data'));
      return response;
    } finally {
      client.close();
    }
  }

  Future<List<Pokedex>> getPokedexes(String name) async {
    var response;
    List<Pokedex> _model = [];
    response = await fetchData(name, '?limit=40');
    _model = pokedexFromJson(json.decode(response!.body)['results']);
    return _model;
  }

  Future<List<Pokemon>> getPokemonList(int pokedexNumber) async {
    var response;
    List<Pokemon> _model = [];
    response = await fetchData('pokedex', pokedexNumber.toString());
    _model = pokemonsFromJson(json.decode(response!.body)['pokemon_entries']);
    return _model;
  }

  Future<SpecificData> getSpecificData(Pokemon pokemon) async {
    var response =
        await fetchData('pokemon', pokemon.pokemonSpecies!.name.toString());
    var resp = json.decode(response!.body);
    var image = resp['sprites']['front_default'];
    var types = resp['types'];
    var response2 = await fetchData(
        'pokemon-species', pokemon.pokemonSpecies!.name.toString());
    var resp2 = json.decode(response2!.body);
    var color = resp2['color']['name'];
    SpecificData sd = SpecificData.fromJson(image, types, color);
    SpecificData _model = sd;
    return _model;
  }

  Future<PokemonSpecie> getPokemonSpecie(Pokemon pokemon) async {
    var response;
    PokemonSpecie _model;
    response = await fetchData(
        'pokemon-species', pokemon.pokemonSpecies!.name.toString());
    _model = pokemonSpecieFromJson(response.body);
    return _model;
  }

  Future<PokemonData> getPokemonData(Pokemon pokemon) async {
    var response;
    PokemonData _model;
    response =
        await fetchData('pokemon', pokemon.pokemonSpecies!.name.toString());
    _model = pokemonDataFromJson(response.body);
    return _model;
  }
}
