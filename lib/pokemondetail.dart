import 'package:cached_network_image/cached_network_image.dart';
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
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBasicInfoRow(p),
                    _buildTypesRow(p),
                    _buildEvolutionRow(p),
                    _buildStrongWeakRow(p),
                    _buildMovesRow(p)
                  ]),
                )
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

  Padding _buildEvolutionRow(Pokemon p) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var evolutionRow = List<Widget>();
    if (p.prevEvolutions != null) {
      for (var pe in p.prevEvolutions) {
        evolutionRow.add(CircleAvatar(
            backgroundColor: Colors.transparent,
            child: CachedNetworkImage(
              imageUrl:
                  "https://img.pokemondb.net/sprites/sun-moon/icon/${getUrlFriendlyName(pe.name)}.png",
            )));

        evolutionRow
            .add(Icon(Icons.arrow_forward_ios, color: Color(0xff424242)));
      }
    }

    evolutionRow.add(CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CachedNetworkImage(
          imageUrl:
              "https://img.pokemondb.net/sprites/sun-moon/icon/${getUrlFriendlyName(p.name)}.png",
        )));

    if (p.evolutions != null) {
      for (var e in p.evolutions) {
        evolutionRow
            .add(Icon(Icons.arrow_forward_ios, color: Color(0xff424242)));

        evolutionRow.add(CircleAvatar(
            backgroundColor: Colors.transparent,
            child: CachedNetworkImage(
              imageUrl:
                  "https://img.pokemondb.net/sprites/sun-moon/icon/${getUrlFriendlyName(e.name)}.png",
            )));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Evolution", style: textTheme.headline),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: evolutionRow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTypesRow(Pokemon p) {
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
                style: TextStyle(
                    color: Colors.white,
                    shadows: <Shadow>[Shadow(blurRadius: 2.0)])),
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
                  style: TextStyle(
                      color: Colors.white,
                      shadows: <Shadow>[Shadow(blurRadius: 2.0)])),
            ),
          ),
          color: typeColorMap[secondType],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: typeChips),
    );
  }

  Padding _buildBasicInfoRow(Pokemon p) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

  _buildStrongWeakRow(Pokemon p) {
    List<Widget> resistantTypes = new List<Widget>();
    List<Widget> weakTypes = new List<Widget>();

    resistantTypes.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child:
          Text("Resists", style: TextStyle(color: Colors.white, fontSize: 20)),
    ));

    weakTypes.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text("Weaknesses",
          style: TextStyle(color: Colors.white, fontSize: 20)),
    ));

    for (var r in p.resistant) {
      resistantTypes.add(_buildTypeCard(r));
    }

    for (var w in p.weaknesses) {
      weakTypes.add(_buildTypeCard(w));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.green[400],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: resistantTypes),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.red[400],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: weakTypes),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTypeCard(type) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
      ),
      child: Container(
        width: 100,
        height: 30,
        child: Center(
          child: Text(type,
              style: TextStyle(
                  color: Colors.white,
                  shadows: <Shadow>[Shadow(blurRadius: 2.0)])),
        ),
      ),
      color: typeColorMap[type],
    );
  }

  _buildMovesRow(Pokemon p) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    List<Fast> fastMoves = p.attacks.fast;
    List<Special> specialMoves = p.attacks.special;
    var moveRows = List<Widget>();

    moveRows.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Attacks", style: textTheme.headline),
    ));

    for (var fm in fastMoves) {
      var moveRow = new List<Widget>();

      moveRow.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 6.0, right: 6.0),
        child: Text(fm.name, style: textTheme.body2),
      ));

      var numPills = fm.damage / 10;
      for (int i = 0; i < numPills; i++) {
        moveRow.add(_buildAttackPowerPill(fm));
      }
      moveRows.add(Row(children: moveRow));
    }

    for (var sm in specialMoves) {
      var moveRow = new List<Widget>();

      moveRow.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 6.0, right: 6.0),
        child: Text(sm.name, style: textTheme.body2),
      ));

      var numPills = sm.damage / 10;
      for (int i = 0; i < 8; i++) {
        moveRow.add(_buildAttackPowerPill(sm));
      }
      moveRows.add(Row(children: moveRow));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: moveRows),
          ),
        ),
      ),
    );
  }

  Padding _buildAttackPowerPill(fm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
        ),
        child: Container(
          width: 20,
          height: 10,
        ),
        color: typeColorMap[fm.type],
      ),
    );
  }
}
