import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
import 'package:pokedex_flutter/models/pokemon.dart';
import 'package:pokedex_flutter/data/querydefinitions.dart';

class GraphQLGateway {
  static const pokemonGraphUri = "https://graphql-pokemon.herokuapp.com/";
  static const QUERY_COUNT = 15;

  GraphQLClient client;

  GraphQLGateway() {
    client = new GraphQLClient(
        link: graphql_flutter.HttpLink(uri: pokemonGraphUri) as Link,
        cache: graphql_flutter.InMemoryCache());
  }

  Future<List<Pokemon>> getPokemons() async {
    var res = await client.query(
        QueryOptions(document: query_pokemons, variables: {'count': 20}));

    return (res.data['pokemons'] as List)
        .map((p) => Pokemon.fromJson(p))
        .toList();
  }

  Future<List<Pokemon>> getPokemonsRange(start, end) async {
    var res = await client.query(QueryOptions(
        document: query_pokemonsRange,
        variables: {'start': start, 'end': end}));

    return (res.data['pokemonsRange'] as List)
        .map((p) => Pokemon.fromJson(p))
        .toList();
  }
}
