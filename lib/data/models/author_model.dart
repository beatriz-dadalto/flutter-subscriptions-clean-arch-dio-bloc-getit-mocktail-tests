import '../../domain/entities/author.dart';

/// Data model for [Author] entity.
///
/// This class is responsible for handling the conversion between JSON data
/// from the API, the data model itself, and the domain [Author] entity.
/// It separates serialization logic from the domain entity.
class AuthorModel {
  final String name;
  final String? description;
  final String? photoSmallUrl;
  final String? photoLargeUrl;

  const AuthorModel({
    required this.name,
    this.description,
    this.photoSmallUrl,
    this.photoLargeUrl,
  });

  /// Creates an [AuthorModel] from a JSON [Map].
  ///
  /// Converts JSON data received from the API into an [AuthorModel] instance.
  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      photoSmallUrl: json['photoSmallUrl'] as String?,
      photoLargeUrl: json['photoLargeUrl'] as String?,
    );
  }

  /// Converts the [AuthorModel] instance to a JSON [Map].
  ///
  /// This is typically used when sending data to the API.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (photoSmallUrl != null) 'photoSmallUrl': photoSmallUrl,
      if (photoLargeUrl != null) 'photoLargeUrl': photoLargeUrl,
    };
  }

  /// Converts the [AuthorModel] instance to its corresponding domain [Author] entity.
  Author toEntity() {
    return Author(
      name: name,
      description: description,
      photoSmallUrl: photoSmallUrl,
      photoLargeUrl: photoLargeUrl,
    );
  }

  /// Creates an [AuthorModel] from a domain [Author] entity.
  ///
  /// This is typically used when converting a domain entity back to a model
  /// for operations like sending data to the API.
  factory AuthorModel.fromEntity(Author entity) {
    return AuthorModel(
      name: entity.name,
      description: entity.description,
      photoSmallUrl: entity.photoSmallUrl,
      photoLargeUrl: entity.photoLargeUrl,
    );
  }
}
