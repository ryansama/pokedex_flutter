const pokemonList = r"""
 query pokemon($count:Int!) {
    pokemons(first: $count) {
            id,
            name
          }
  }
""";