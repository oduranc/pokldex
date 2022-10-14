import 'package:flutter/material.dart';
import 'package:pokldex/models/pokedex.dart';
import 'package:pokldex/models/pokemon.dart';
import 'package:pokldex/services/networking.dart';
import 'package:pokldex/widgets/pokemon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Pokedex>? _pokedexes = [];
  late List<Pokemon>? _pokemons = [];
  late int selectedPokedex = 1;
  late String selectedPokedexStr = 'NATIONAL';
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getPokedexes();
    _getPokemonList();
  }

  void _getPokedexes() async {
    _pokedexes = (await Networking().getPokedexes('pokedex'));
  }

  void _getPokemonList() async {
    _pokemons = (await Networking().getPokemonList(selectedPokedex));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(Icons.list),
            onSelected: (newValue) {
              setState(() {
                isLoaded = false;
                int index = newValue - 1 > 9 ? newValue - 2 : newValue - 1;
                selectedPokedexStr =
                    _pokedexes![index].name.toString().toUpperCase();
                selectedPokedex = newValue;
              });
              _getPokemonList();
            },
            itemBuilder: (context) {
              return List.generate(_pokedexes!.length, (index) {
                return PopupMenuItem(
                  value: index + 1 > 9 ? index + 2 : index + 1,
                  child: Text(_pokedexes![index].name.toString().toUpperCase()),
                );
              });
            },
          ),
        ],
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _pokemons!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: ((context, index) {
            return PokemonCard(pokemon: _pokemons![index]);
          }),
        ),
      ),
    );
  }
}
