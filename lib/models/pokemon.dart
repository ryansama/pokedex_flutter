import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  String id;
  String name;
  String classification;
  List<String> types;
  List<String> resistant;
  List<String> weaknesses;
  Weight weight;
  Height height;
  double fleeRate;
  EvolutionRequirements evolutionRequirements;
  List<Evolutions> evolutions;
  List<Evolutions> prevEvolutions;
  int maxCP;
  int maxHP;
  Attacks attacks;

  Pokemon(
      {this.id,
      this.name,
      this.classification,
      this.types,
      this.resistant,
      this.weaknesses,
      this.weight,
      this.height,
      this.fleeRate,
      this.evolutionRequirements,
      this.evolutions,
      this.prevEvolutions,
      this.maxCP,
      this.maxHP,
      this.attacks});

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonToJson(this);
}

@JsonSerializable()
class Weight {
  String minimum;
  String maximum;

  Weight({this.minimum, this.maximum});

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);
  Map<String, dynamic> toJson() => _$WeightToJson(this);
}

@JsonSerializable()
class Height {
  String minimum;
  String maximum;

  Height({this.minimum, this.maximum});

  factory Height.fromJson(Map<String, dynamic> json) => _$HeightFromJson(json);
  Map<String, dynamic> toJson() => _$HeightToJson(this);
}

@JsonSerializable()
class EvolutionRequirements {
  int amount;
  String name;

  EvolutionRequirements({this.amount, this.name});

  factory EvolutionRequirements.fromJson(Map<String, dynamic> json) =>
      _$EvolutionRequirementsFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionRequirementsToJson(this);
}

@JsonSerializable()
class Evolutions {
  String id;
  String name;

  Evolutions({this.id, this.name});

  factory Evolutions.fromJson(Map<String, dynamic> json) =>
      _$EvolutionsFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionsToJson(this);
}

@JsonSerializable()
class Attacks {
  List<Fast> fast;
  List<Special> special;

  Attacks({this.fast, this.special});

  factory Attacks.fromJson(Map<String, dynamic> json) =>
      _$AttacksFromJson(json);
  Map<String, dynamic> toJson() => _$AttacksToJson(this);
}

@JsonSerializable()
class Fast {
  String name;
  String type;
  int damage;

  Fast({this.name, this.type, this.damage});

  factory Fast.fromJson(Map<String, dynamic> json) => _$FastFromJson(json);
  Map<String, dynamic> toJson() => _$FastToJson(this);
}

@JsonSerializable()
class Special {
  String name;
  String type;
  int damage;

  Special({this.name, this.type, this.damage});

  factory Special.fromJson(Map<String, dynamic> json) =>
      _$SpecialFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialToJson(this);
}
