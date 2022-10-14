import 'package:flutter/material.dart';
import 'package:pokldex/models/pokemon.dart';
import 'package:pokldex/models/specific_data.dart';
import 'package:pokldex/screens/pokemon_page.dart';
import 'package:pokldex/services/networking.dart';
import 'package:pokldex/util/custom_theme.dart';
import 'package:pokldex/widgets/label.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  SpecificData? _specificData;
  bool isLoaded = false;

  void _getSpecificData() async {
    _specificData = (await Networking().getSpecificData(widget.pokemon));
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSpecificData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonPage(
              pokemon: widget.pokemon,
              specificData: _specificData!,
            ),
          ),
        );
      },
      child: Container(
        color: isLoaded
            ? CustomTheme.colorString(_specificData!.color!)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Label(
                    data: widget.pokemon.entryNumber.toString(),
                    color: isLoaded
                        ? CustomTheme.colorString(_specificData!.color!)
                        : Colors.transparent,
                  ),
                  Label(
                    data: widget.pokemon.pokemonSpecies!.name
                        .toString()
                        .toUpperCase(),
                    color: isLoaded
                        ? CustomTheme.colorString(_specificData!.color!)
                        : Colors.transparent,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              isLoaded ? _specificData!.types!.length : 0,
                          itemBuilder: (context, index) {
                            return Label(
                              data: _specificData!.types![index]['type']['name']
                                  .toUpperCase(),
                              color: isLoaded
                                  ? CustomTheme.colorString(
                                      _specificData!.color!)
                                  : Colors.transparent,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  isLoaded
                      ? Image.network(
                          _specificData!.image.toString(),
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
