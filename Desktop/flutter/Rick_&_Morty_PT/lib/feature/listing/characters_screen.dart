import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/models.dart';
import 'package:flutter_application_1/data/characters_api.dart';
import 'package:flutter_application_1/feature/detail/character_details.dart';
import 'backdrop.dart';

import 'character_item.dart';

final _characterGridViewMargin = 48.0;
final _characterGridViewSpanCountPortrait = 2;
final _characterGridViewSpanCountLandscape = 4;

final _frontTitle = 'Character';
final _backTitle = 'Personajes Rick & Morty';

class CharacterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CharacterState();
}

class CharacterState extends State<CharacterScreen> {
  final _characters = <Character>[];
  Character? _currentCharacter;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_characters.isEmpty) {
      await _loadCharacters();
    }
  }

  Future _loadCharacters() async {
    final api = Api();
    final characters = await api.getCharacters();
    setState(() {
      _characters.addAll(characters!.toList(growable: true));
    });
  }

  void _onCharacterTapped(Character character) {
    setState(() {
      _currentCharacter = character;
      print("Character tapped");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontTitle: Text(_frontTitle),
      backTitle: Text(_backTitle),
      currentCharacter: _currentCharacter,
      backPanel: _buildBackPanel(),
      frontPanel: _buildFrontPanel(),
    );
  }

  Widget _buildFrontPanel() {
    final chat = _currentCharacter;
    if (chat != null) {
      return CharacterDetailScreen(chat);
    } else {
      return Container();
    }
  }

  Widget _buildBackPanel() {
    if (_characters.isEmpty) {
      return _buildForLoadingState();
    } else {
      return _buildForLoadedState();
    }
  }

  Widget _buildForLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForLoadedState() {
    return Padding(
      padding: EdgeInsets.only(bottom: _characterGridViewMargin),
      child: GridView.count(
          crossAxisCount: _getCharacterGridViewSpanCount(),
          children: _characters
              .map((character) => CharacterItem(character, _onCharacterTapped))
              .toList()),
    );
  }

  int _getCharacterGridViewSpanCount() {
    if (MediaQuery.of(context).orientation == Orientation.portrait)
      return _characterGridViewSpanCountPortrait;
    return _characterGridViewSpanCountLandscape;
  }
}
