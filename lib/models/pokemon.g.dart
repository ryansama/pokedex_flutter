// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) {
  return Pokemon(
      id: json['id'] as String,
      name: json['name'] as String,
      classification: json['classification'] as String,
      types: (json['types'] as List)?.map((e) => e as String)?.toList(),
      resistant: (json['resistant'] as List)?.map((e) => e as String)?.toList(),
      weaknesses:
          (json['weaknesses'] as List)?.map((e) => e as String)?.toList(),
      weight: json['weight'] == null
          ? null
          : Weight.fromJson(json['weight'] as Map<String, dynamic>),
      height: json['height'] == null
          ? null
          : Height.fromJson(json['height'] as Map<String, dynamic>),
      fleeRate: (json['fleeRate'] as num)?.toDouble(),
      evolutionRequirements: json['evolutionRequirements'] == null
          ? null
          : EvolutionRequirements.fromJson(
              json['evolutionRequirements'] as Map<String, dynamic>),
      evolutions: (json['evolutions'] as List)
          ?.map((e) =>
              e == null ? null : Evolutions.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      maxCP: json['maxCP'] as int,
      maxHP: json['maxHP'] as int,
      attacks: json['attacks'] == null
          ? null
          : Attacks.fromJson(json['attacks'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'classification': instance.classification,
      'types': instance.types,
      'resistant': instance.resistant,
      'weaknesses': instance.weaknesses,
      'weight': instance.weight,
      'height': instance.height,
      'fleeRate': instance.fleeRate,
      'evolutionRequirements': instance.evolutionRequirements,
      'evolutions': instance.evolutions,
      'maxCP': instance.maxCP,
      'maxHP': instance.maxHP,
      'attacks': instance.attacks
    };

Weight _$WeightFromJson(Map<String, dynamic> json) {
  return Weight(
      minimum: json['minimum'] as String, maximum: json['maximum'] as String);
}

Map<String, dynamic> _$WeightToJson(Weight instance) =>
    <String, dynamic>{'minimum': instance.minimum, 'maximum': instance.maximum};

Height _$HeightFromJson(Map<String, dynamic> json) {
  return Height(
      minimum: json['minimum'] as String, maximum: json['maximum'] as String);
}

Map<String, dynamic> _$HeightToJson(Height instance) =>
    <String, dynamic>{'minimum': instance.minimum, 'maximum': instance.maximum};

EvolutionRequirements _$EvolutionRequirementsFromJson(
    Map<String, dynamic> json) {
  return EvolutionRequirements(
      amount: json['amount'] as int, name: json['name'] as String);
}

Map<String, dynamic> _$EvolutionRequirementsToJson(
        EvolutionRequirements instance) =>
    <String, dynamic>{'amount': instance.amount, 'name': instance.name};

Evolutions _$EvolutionsFromJson(Map<String, dynamic> json) {
  return Evolutions(id: json['id'] as String, name: json['name'] as String);
}

Map<String, dynamic> _$EvolutionsToJson(Evolutions instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

Attacks _$AttacksFromJson(Map<String, dynamic> json) {
  return Attacks(
      fast: (json['fast'] as List)
          ?.map((e) =>
              e == null ? null : Fast.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      special: (json['special'] as List)
          ?.map((e) =>
              e == null ? null : Special.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AttacksToJson(Attacks instance) =>
    <String, dynamic>{'fast': instance.fast, 'special': instance.special};

Fast _$FastFromJson(Map<String, dynamic> json) {
  return Fast(
      name: json['name'] as String,
      type: json['type'] as String,
      damage: json['damage'] as int);
}

Map<String, dynamic> _$FastToJson(Fast instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'damage': instance.damage
    };

Special _$SpecialFromJson(Map<String, dynamic> json) {
  return Special(
      name: json['name'] as String,
      type: json['type'] as String,
      damage: json['damage'] as int);
}

Map<String, dynamic> _$SpecialToJson(Special instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'damage': instance.damage
    };
