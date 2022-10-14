import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokldex/models/pokemon_data.dart';
import 'package:pokldex/models/pokemon_specie.dart';
import 'package:pokldex/models/pokemon.dart';
import 'package:pokldex/models/specific_data.dart';
import 'package:pokldex/services/networking.dart';
import 'package:pokldex/util/constants.dart';
import 'package:pokldex/util/custom_theme.dart';
import 'package:pokldex/widgets/label.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage(
      {Key? key, required this.pokemon, required this.specificData})
      : super(key: key);
  final Pokemon pokemon;
  final SpecificData specificData;

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final double coverHeight = 180;
  final double profileHeight = 144;
  final double verticalPadding = 15;
  PokemonSpecie? _pokemonSpecie;
  PokemonData? _pokemonData;
  bool isLoaded = false;

  void _getPokeData() async {
    _pokemonSpecie = (await Networking().getPokemonSpecie(widget.pokemon));
    _pokemonData = (await Networking().getPokemonData(widget.pokemon));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPokeData();
  }

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Scaffold(
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(bottom, context, top),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    _pokemonSpecie != null
                        ? _pokemonSpecie!.name.toUpperCase()
                        : '',
                    style: nameTitle,
                  ),
                  buildSection(buildTypes()),
                  buildAddInfo(),
                  buildSection(buildBaseRow()),
                  buildSection(buildSectionRows(
                      'Abilities',
                      _pokemonData != null
                          ? _pokemonData!.abilities!.length
                          : 0,
                      abilities)),
                  buildSection(buildSectionRows(
                      'Egg Groups',
                      _pokemonSpecie != null
                          ? _pokemonSpecie!.eggGroups.length
                          : 0,
                      eggGroups)),
                  buildSection(buildSectionRows(
                      'Base Stats',
                      _pokemonData != null ? _pokemonData!.stats!.length : 0,
                      stats)),
                  buildSection(buildOthers()),
                  buildSection(buildShiny()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack buildTop(double bottom, BuildContext context, double top) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: Container(
            color: CustomTheme.colorString(widget.specificData.color!),
            height: coverHeight,
          ),
        ),
        Positioned(
          top: 30,
          left: 5,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        Positioned(
          top: 50,
          right: 50,
          child: Text(
            '#${widget.pokemon.entryNumber.toString()}',
            style: nameTitle,
          ),
        ),
        Positioned(
          top: top,
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(widget.specificData.image!),
          ),
        ),
      ],
    );
  }

  GridView buildAddInfo() {
    return GridView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
      ),
      children: <Widget>[
        Label(
            data: _pokemonSpecie != null
                ? _pokemonSpecie!.isBaby
                    ? 'BABY'
                    : 'NOT BABY'
                : '',
            color: Colors.transparent),
        Label(
            data: _pokemonSpecie != null
                ? _pokemonSpecie!.isLegendary
                    ? 'LEGENDARY'
                    : 'NOT LEGENDARY'
                : '',
            color: Colors.transparent),
        Label(
            data: _pokemonSpecie != null
                ? _pokemonSpecie!.isMythical
                    ? 'MYTHICAL'
                    : 'NOT MYTHICAL'
                : '',
            color: Colors.transparent),
      ],
    );
  }

  GridView buildTypes() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.specificData.types!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.specificData.types!.length,
        childAspectRatio: widget.specificData.types!.length == 2 ? 5 : 10,
      ),
      itemBuilder: (context, index) {
        return Label(
          data: widget.specificData.types![index]['type']['name'].toUpperCase(),
          color: CustomTheme.colorString(
            widget.specificData.color!,
          ),
        );
      },
    );
  }

  SizedBox buildBaseRow() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Text(
                'Base exp',
                style: smallTitles,
              ),
              Text(_pokemonData != null
                  ? _pokemonData!.baseExperience.toString()
                  : ''),
            ],
          ),
          const VerticalDivider(),
          Column(
            children: <Widget>[
              const Text(
                'Height',
                style: smallTitles,
              ),
              Text(_pokemonData != null
                  ? '${_pokemonData!.height.toString()} dm'
                  : ''),
            ],
          ),
          const VerticalDivider(),
          Column(
            children: <Widget>[
              const Text(
                'Weight',
                style: smallTitles,
              ),
              Text(_pokemonData != null
                  ? '${_pokemonData!.weight.toString()} hg'
                  : ''),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildSection(dynamic section) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: section,
    );
  }

  Column buildSectionRows(String title, int length, Function section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: mediumTitles,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: section(index),
              ),
            );
          },
        ),
      ],
    );
  }

  Column buildOthers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Others',
          style: mediumTitles,
        ),
        ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: others(),
        )
      ],
    );
  }

  List<Widget> stats(int index) {
    return <Widget>[
      Expanded(
        flex: 2,
        child: Text(
          _pokemonData!.stats![index].stat!.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(child: Text(_pokemonData!.stats![index].baseStat!.toString())),
      Text('${_pokemonData!.stats![index].effort!.toString()} EFFORT'),
    ];
  }

  List<Widget> abilities(int index) {
    return <Widget>[
      Text(
        _pokemonData!.abilities![index].ability!.name.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(_pokemonData!.abilities![index].isHidden! ? 'HIDDEN' : 'NOT HIDDEN'),
    ];
  }

  List<Widget> eggGroups(int index) {
    return <Widget>[
      Text(_pokemonSpecie!.eggGroups[index].name.toUpperCase()),
    ];
  }

  List<Widget> others() {
    return <Widget>[
      paddingRow(
        'BASE HAPPINESS',
        _pokemonSpecie != null ? _pokemonSpecie!.baseHappiness.toString() : '',
      ),
      paddingRow(
        'CAPTURE RATE',
        _pokemonSpecie != null ? _pokemonSpecie!.captureRate.toString() : '',
      ),
      paddingRow(
        'GROWTH RATE',
        _pokemonSpecie != null ? _pokemonSpecie!.growthRate.name : '',
      ),
      paddingRow(
        'SHAPE',
        _pokemonSpecie != null ? _pokemonSpecie!.shape.name : '',
      ),
    ];
  }

  Padding paddingRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data.toUpperCase()),
        ],
      ),
    );
  }

  Column buildShiny() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Shiny',
          style: mediumTitles,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _pokemonData != null
                  ? Image.network(_pokemonData!.sprites!.frontShiny!)
                  : Container(),
              _pokemonData != null
                  ? Image.network(_pokemonData!.sprites!.backShiny!)
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
