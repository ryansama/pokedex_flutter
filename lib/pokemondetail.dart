import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex_flutter/data/graphql_gateway.dart';
import 'package:pokedex_flutter/helpers/typecolordict.dart';
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

  final double IMAGE_HEIGHT = 200.0;

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
        home: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                _buildSliverAppBar(p),
                SliverFillRemaining(child: _buildDetailCards(p))
              ],
            ),
          ),
        ));
  }

  SliverAppBar _buildSliverAppBar(Pokemon p) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () => Navigator.pop(context, false),
      ),
      backgroundColor: Colors.white,
      pinned: true,
      expandedHeight: IMAGE_HEIGHT,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          p.name,
          style: TextStyle(color: Colors.black),
        ),
        background: Stack(children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBannerImage(p),
          )),
          Container(
            height: 350.0,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.white54,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          )
        ]),
      ),
    );
  }

  FadeInImage _buildBannerImage(Pokemon p) {
    return FadeInImage.memoryNetwork(
      fadeInDuration: Duration(milliseconds: 150),
      placeholder: kTransparentImage,
      image:
          'https://img.pokemondb.net/artwork/${getUrlFriendlyName(p.name)}.jpg',
    );
  }

  String getUrlFriendlyName(String name) => name = name
      .replaceAll("'", "")
      .replaceAll(".", "-")
      .replaceAll(" ", "")
      .toLowerCase();

  _buildDetailCards(Pokemon p) {
    return Scaffold(
      body: Column(
        children: <Widget>[_buildBasicInfoRow(p), _buildTypesRow(p)],
      ),
    );
  }

  Row _buildTypesRow(Pokemon p) {
    var typeChips = <Card>[];
    var hasTwoTypes = p.types.length > 1;
    var firstType = p.types[0];

    typeChips.add(
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              topRight: Radius.circular(hasTwoTypes ? 0.0 : 15.0),
              bottomRight: Radius.circular(hasTwoTypes ? 0.0 : 15.0)),
        ),
        child: Container(
          width: 100,
          height: 30,
          child: Center(
            child: Text(firstType,
                style: TextStyle(color: Colors.white, shadows: <Shadow>[Shadow(blurRadius: 2.0)])),
          ),
        ),
        color: typeColorMap[firstType],
      ),
    );

    if (hasTwoTypes) {
      var secondType = p.types[1];
      typeChips.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          child: Container(
            width: 100,
            height: 30,
            child: Center(
              child: Text(secondType,
                  style: TextStyle(color: Colors.white, shadows: <Shadow>[Shadow(blurRadius: 2.0)])),
            ),
          ),
          color: typeColorMap[secondType],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: typeChips
    );
  }

  Padding _buildBasicInfoRow(Pokemon p) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              height: 50.0,
              width: 0.0,
            ),
            Container(
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      p.weight.maximum,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Max wt",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 50.0,
              width: 1.0,
            ),
            Container(
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      p.height.maximum,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Max ht",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 50.0,
              width: 1.0,
            ),
            Container(
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      p.maxHP.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Max HP",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 50.0,
              width: 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
