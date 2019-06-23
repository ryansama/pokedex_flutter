import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_flutter/client_provider.dart';
import 'querydefinitions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PokemonGraphClientProvider(
        child: MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokeList(items: List<String>.generate(10000, (i) => "Item $i")),
    ));
  }
}

class PokeList extends StatelessWidget {
  final List<String> items;

  PokeList({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Query(
            options: QueryOptions(
                document: pokemonList, variables: {'count': 20}),
            builder: (QueryResult result, { VoidCallback refetch }) {
              if (result.errors != null) {
                return Text(result.errors.toString());
              }

              if (result.loading) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }

              List pokemons = result.data['pokemons']; 

              return ListView.builder(
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(pokemons[index]['name']),
                  );
                },
              );
            },
          )),
    );
  }
}
