import '../../domain/entities/subscription.dart';
import 'author_model.dart';
import 'feature_model.dart';
import 'identifier_model.dart';

/// Data model for [Subscription] entity.
///
/// This class is responsible for handling the conversion between JSON data
/// from the API, the data model itself, and the domain [Subscription] entity.
/// It separates serialization logic from the domain entity.
class SubscriptionModel {
  final IdentifierModel identifier;
  final String name;
  final String shortDescription;
  final String description;
  final String imageLarge;
  final String imageSmall;
  final List<AuthorModel> authors;
  final List<FeatureModel> features;

  const SubscriptionModel({
    required this.identifier,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageLarge,
    required this.imageSmall,
    required this.authors,
    required this.features,
  });

  /// Creates a [SubscriptionModel] from a JSON [Map].
  ///
  /// Converts JSON data received from the API into a [SubscriptionModel] instance.
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      identifier: _parseIdentifier(json),
      name: json['name'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageLarge: json['imageLarge'] as String? ?? '',
      imageSmall: json['imageSmall'] as String? ?? '',
      authors: _parseAuthors(json),
      features: _parseFeatures(json),
    );
  }

  /// Parses the 'identifier' field from the JSON [Map] into an [IdentifierModel].
  static IdentifierModel _parseIdentifier(Map<String, dynamic> json) {
    try {
      final identifierJson = json['identifier'] as Map<String, dynamic>?;
      if (identifierJson == null) return const IdentifierModel(slug: '');
      return IdentifierModel.fromJson(identifierJson);
    } catch (e) {
      return const IdentifierModel(slug: '');
    }
  }

  /// Parses the 'authors' field from the JSON [Map] into a list of [AuthorModel]s.
  static List<AuthorModel> _parseAuthors(Map<String, dynamic> json) {
    try {
      final authorsJson = json['authors'] as List<dynamic>?;
      if (authorsJson == null) return const [];

      return authorsJson
          .map((a) => AuthorModel.fromJson(a as Map<String, dynamic>))
          .toList(growable: false);
    } catch (e) {
      return const [];
    }
  }

  /// Parses the 'features' field from the JSON [Map] into a list of [FeatureModel]s.
  static List<FeatureModel> _parseFeatures(Map<String, dynamic> json) {
    try {
      final featuresJson = json['features'] as List<dynamic>?;
      if (featuresJson == null) return const [];

      return featuresJson
          .map((f) => FeatureModel.fromJson(f as Map<String, dynamic>))
          .toList(growable: false);
    } catch (e) {
      return const [];
    }
  }

  /// Converts the [SubscriptionModel] instance to a JSON [Map].
  ///
  /// This is typically used when sending data to the API.
  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier.toJson(),
      'name': name,
      'shortDescription': shortDescription,
      'description': description,
      'imageLarge': imageLarge,
      'imageSmall': imageSmall,
      'authors': authors.map((a) => a.toJson()).toList(growable: false),
      'features': features.map((f) => f.toJson()).toList(growable: false),
    };
  }

  /// Converts the [SubscriptionModel] instance to its corresponding domain [Subscription] entity.
  Subscription toEntity() {
    return Subscription(
      identifier: identifier.toEntity(),
      name: name,
      shortDescription: shortDescription,
      description: description,
      imageLarge: imageLarge,
      imageSmall: imageSmall,
      authors: authors.map((a) => a.toEntity()).toList(growable: false),
      features: features.map((f) => f.toEntity()).toList(growable: false),
    );
  }

  /// Creates a [SubscriptionModel] from a domain [Subscription] entity.
  ///
  /// This is typically used when converting a domain entity back to a model
  /// for operations like sending data to the API.
  factory SubscriptionModel.fromEntity(Subscription entity) {
    return SubscriptionModel(
      identifier: IdentifierModel.fromEntity(entity.identifier),
      name: entity.name,
      shortDescription: entity.shortDescription,
      description: entity.description,
      imageLarge: entity.imageLarge,
      imageSmall: entity.imageSmall,
      authors: entity.authors
          .map((a) => AuthorModel.fromEntity(a))
          .toList(growable: false),
      features: entity.features
          .map((f) => FeatureModel.fromEntity(f))
          .toList(growable: false),
    );
  }
}
