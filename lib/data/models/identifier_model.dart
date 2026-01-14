import '../../domain/entities/identifier.dart';

/// Data model for [Identifier] entity.
///
/// This class is responsible for handling the conversion between JSON data
/// from the API, the data model itself, and the domain [Identifier] entity.
class IdentifierModel {
  final String slug;

  const IdentifierModel({required this.slug});

  /// Creates an [IdentifierModel] from a JSON [Map].
  ///
  /// Converts JSON data received from the API into an [IdentifierModel] instance.
  factory IdentifierModel.fromJson(Map<String, dynamic> json) {
    return IdentifierModel(slug: json['slug'] as String? ?? '');
  }

  /// Converts the [IdentifierModel] instance to a JSON [Map].
  ///
  /// This is typically used when sending data to the API.
  Map<String, dynamic> toJson() {
    return {'slug': slug};
  }

  /// Converts the [IdentifierModel] instance to its corresponding domain [Identifier] entity.
  ///
  /// This method facilitates the mapping from the data layer to the domain layer.
  Identifier toEntity() {
    return Identifier(slug: slug);
  }

  /// Creates an [IdentifierModel] from a domain [Identifier] entity.
  ///
  /// This is typically used when converting a domain entity back to a model
  /// for operations like sending data to the API.
  factory IdentifierModel.fromEntity(Identifier entity) {
    return IdentifierModel(slug: entity.slug);
  }
}
