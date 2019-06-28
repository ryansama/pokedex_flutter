import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_flutter/data/graphql_gateway.dart';
import 'package:pokedex_flutter/theme/hyperball_theme.dart';
import 'package:transparent_image/transparent_image.dart';
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
          return _buildDetailsView(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: hyperBallTheme(),
            home: Scaffold(body: Center(child: CircularProgressIndicator())));
      },
    );
  }

  Widget _buildDetailsView(Pokemon p) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: _buildBanner(p),
            ),
            new Positioned(
              //Place it at the top, and not use the entire screen
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                automaticallyImplyLeading: true,
                //`true` if you want Flutter to automatically add Back Button when needed,
                //or `false` if you want to force your own back button every where
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context, false),
                ),
                backgroundColor: Colors.transparent, //No more green
                elevation: 0.0, //Shadow gone
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _buildBanner(Pokemon p) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 250,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  'https://img.pokemondb.net/artwork/${getUrlFriendlyName(p.name)}.jpg',
            ),
          ),
        ],
      ),
    );
  }

  String getUrlFriendlyName(String name) => name = name
      .replaceAll("'", "")
      .replaceAll(".", "-")
      .replaceAll(" ", "")
      .toLowerCase();
}
