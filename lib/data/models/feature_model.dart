import '../../domain/entities/feature.dart';

/// Data model for [Feature] entity.
///
/// This class is responsible for handling the conversion between JSON data
/// from the API, the data model itself, and the domain [Feature] entity.
/// It separates serialization logic from the domain entity.
class FeatureModel {
  final String title;
  final String description;

  const FeatureModel({required this.title, required this.description});

  /// Creates a [FeatureModel] from a JSON [Map].
  ///
  /// Converts JSON data received from the API into a [FeatureModel] instance.
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  /// Converts the [FeatureModel] instance to a JSON [Map].
  ///
  /// This is typically used when sending data to the API.
  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description};
  }

  /// Converts the [FeatureModel] instance to its corresponding domain [Feature] entity.
  Feature toEntity() {
    return Feature(title: title, description: description);
  }

  /// Creates a [FeatureModel] from a domain [Feature] entity.
  ///
  /// This is typically used when converting a domain entity back to a model
  /// for operations like sending data to the API.
  factory FeatureModel.fromEntity(Feature entity) {
    return FeatureModel(title: entity.title, description: entity.description);
  }
}
