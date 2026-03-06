import '../../domain/entities/character.dart';

class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
  });

  final int id;
  final String name;
  final String image;
  final String status;
  final String species;

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
    );
  }

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      image: image,
      status: status,
      species: species,
    );
  }
}
