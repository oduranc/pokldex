import 'package:flutter/material.dart';
import 'package:pokldex/models/pokedex.dart';
import 'package:pokldex/models/pokemon.dart';
import 'package:pokldex/services/networking.dart';
import 'package:pokldex/util/constants.dart';
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
  bool isEmpty = false;
  String searchedPokemon = '';

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
    searchedPokemon = '';
    setState(() {
      isLoaded = true;
      isEmpty = false;
    });
  }

  void _getSearchedPokemon() async {
    await Future.delayed(const Duration(seconds: 1));
    _pokemons = _pokemons
        ?.where((element) =>
            element.pokemonSpecies!.name!.contains(searchedPokemon))
        .toList();
    setState(() {
      isLoaded = true;
      isEmpty = false;
    });
    if (_pokemons!.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    }
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
        child: Visibility(
          visible: !isEmpty,
          replacement: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Text('Pokémon not found', style: nameTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Image.network(
                        'https://www.pngmart.com/files/22/Surprised-Pikachu-Transparent-PNG.png'),
                  ),
                  const Text(
                    'You can search a specific name or a portion of it.',
                    style: mediumTitles,
                  ),
                ],
              ),
            ),
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: 'Pokémon name',
                          icon: Icon(Icons.search),
                        ),
                        controller:
                            TextEditingController(text: searchedPokemon),
                        onChanged: (value) {
                          searchedPokemon = value;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoaded = false;
                            });
                            _getPokemonList();
                            Navigator.pop(context);
                          },
                          child: const Text('GET ALL'),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoaded = false;
                            });
                            if (searchedPokemon == '') {
                              _getPokemonList();
                            } else {
                              _getSearchedPokemon();
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('SEARCH'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
