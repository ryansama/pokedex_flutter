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

const query_single_pokemon = r"""
    query pokemon($id:String){
    pokemon(id:$id){
      id
      name
      classification
      types
      resistant
      weaknesses
      weight{
        minimum
        maximum
      }
      height{
        minimum
        maximum
      }
      fleeRate
      evolutionRequirements{
        amount
        name
      }
			maxCP
      maxHP
      attacks {
        fast{
          name
         	type
          damage
        }
        special{
          name
          type
          damage
        }
      }
      evolutions {
        id
        name
      }    
    }
  }
""";
