import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_flutter/data/graphql_gateway.dart';
import 'models/pokemon.dart';

class PokemonDetail extends StatefulWidget {
  final String id;
  PokemonDetail(this.id);

  @override
  State<StatefulWidget> createState() => _PokemonDetailState(id);
}

class _PokemonDetailState extends State<PokemonDetail> {
  final String id;
  Future<Pokemon> pokemon;
  final gateway = new GraphQLGateway();

  _PokemonDetailState(this.id);

  @override
  void initState() {
    super.initState();
    pokemon = gateway.getPokemon(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: pokemon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.id);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
