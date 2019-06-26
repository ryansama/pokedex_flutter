import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PokemonDetail extends StatefulWidget {
  final id;

  PokemonDetail(this.id);

  @override
  State<StatefulWidget> createState() => PokemonDetailState(id);
}

class PokemonDetailState extends State{
  var id;

  PokemonDetailState(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Text(id),
    ),);
  }
  
}
