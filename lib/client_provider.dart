import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

const pokemonGraphUri = "https://graphql-pokemon.now.sh/";

class PokemonGraphClientProvider extends StatelessWidget {
  PokemonGraphClientProvider({
    @required this.child,
  }) : client = clientFor(
          uri: pokemonGraphUri
        );

  final Widget child;
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id'] as String;
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

final OptimisticCache cache = OptimisticCache(
  dataIdFromObject: uuidFromObject,
);

ValueNotifier<GraphQLClient> clientFor({
  @required String uri
}) {
  Link link = HttpLink(uri: uri) as Link;

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: cache,
      link: link,
    ),
  );
}