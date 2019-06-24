const query_pokemons = r"""
 query pokemon($count:Int!) {
    pokemons(first: $count) {
            id,
            name
          }
  }
""";

const query_pokemonsRange = r"""
 query pokemon($start:Int!, $end:Int!) {
    pokemonsRange(start:$start, end:$end) {
            id,
            name
          }
  }
""";
