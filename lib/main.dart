import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_flutter/data/graphql_gateway.dart';
import 'package:pokedex_flutter/pokemondetail.dart';
import 'package:transparent_image/transparent_image.dart';
import 'models/pokemon.dart';
import 'theme/hyperball_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex Flutter',
      theme: hyperBallTheme(),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
  bool reachedEnd = false;
  int nextRangeIndex = GraphQLGateway.QUERY_COUNT;
  List<Pokemon> pokemon = new List<Pokemon>();

  final gateway = new GraphQLGateway();
  void _getMoreData() async {
    if (reachedEnd) {
      return;
    }

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await gateway.getPokemonsRange(
          nextRangeIndex == GraphQLGateway.QUERY_COUNT ? 0 : nextRangeIndex,
          nextRangeIndex + GraphQLGateway.QUERY_COUNT);
      nextRangeIndex = nextRangeIndex + GraphQLGateway.QUERY_COUNT;
      if (response.length == 0) {
        reachedEnd = true;
      }
      setState(() {
        isLoading = false;
        pokemon.addAll(response);
      });
    }
  }

  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: pokemon.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == pokemon.length) {
          return _buildProgressIndicator();
        } else {
          var pokemonName = pokemon.elementAt(index).name;
          return new ListTile(
            contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
            leading: CircleAvatar(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      "https://img.pokemondb.net/sprites/sun-moon/icon/${getUrlFriendlyName(pokemonName)}.png"),
              backgroundColor: Colors.transparent,
            ),
            title: Text(pokemonName),
            onTap: () {
              print("Tapped on $pokemonName");
              navigateToDetail(pokemon.elementAt(index).id);
            },
          );
        }
      },
      controller: _scrollController,
    );
  }

  String getUrlFriendlyName(String name) => name = name
      .replaceAll("'", "")
      .replaceAll(".", "-")
      .replaceAll(" ", "")
      .toLowerCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex Flutter"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void navigateToDetail(String id) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PokemonDetail(id)),
    );
  }
}
