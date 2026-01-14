import 'package:equatable/equatable.dart';

import 'author.dart';
import 'feature.dart';
import 'identifier.dart';

/// Pure domain entity - represents a Subscription in the business domain.
///
/// This class is independent of JSON or API details, focusing solely on
/// the subscription's attributes and business logic.
class Subscription extends Equatable {
  final Identifier identifier;
  final String name;
  final String shortDescription;
  final String description;
  final String imageLarge;
  final String imageSmall;
  final List<Author> authors;
  final List<Feature> features;

  const Subscription({
    required this.identifier,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageLarge,
    required this.imageSmall,
    required this.authors,
    required this.features,
  });

  /// Factory constructor for creating an empty [Subscription] instance.
  ///
  /// Useful for initial states or when a subscription object needs to be
  /// instantiated without actual data.
  const Subscription.empty()
    : identifier = const Identifier.empty(),
      name = '',
      shortDescription = '',
      description = '',
      imageLarge = '',
      imageSmall = '',
      authors = const [],
      features = const [];

  /// Factory constructor for creating fake [Subscription] instances, typically used in tests.
  ///
  /// Allows easy creation of mock subscription data for testing purposes.
  factory Subscription.fake({
    String slug = 'fake-slug',
    String name = 'Fake Subscription',
    String shortDescription = 'Short description',
    String description = 'Fake description',
    String imageLarge =
        'https://empiricus-app.empiricus.com.br/mock/images/as-melhores-acoes-da-bolsa-large.jpg',
    String imageSmall =
        'https://empiricus-app.empiricus.com.br/mock/images/as-melhores-acoes-da-bolsa-small.jpg',
    List<Author> authors = const [],
    List<Feature> features = const [],
  }) {
    return Subscription(
      identifier: Identifier(slug: slug),
      name: name,
      shortDescription: shortDescription,
      description: description,
      imageLarge: imageLarge,
      imageSmall: imageSmall,
      authors: authors,
      features: features,
    );
  }

  /// Business helper
  String get slug => identifier.slug;
  bool get isValid => identifier.isValid && name.isNotEmpty;
  bool get hasAuthors => authors.isNotEmpty;
  bool get hasFeatures => features.isNotEmpty;
  String get bestImage => imageLarge.isNotEmpty ? imageLarge : imageSmall;
  bool get hasImage => imageLarge.isNotEmpty || imageSmall.isNotEmpty;
  String get authorsNames => authors.map((a) => a.name).join(', ');
  int get featuresCount => features.length;
  Author? get primaryAuthor => authors.isNotEmpty ? authors.first : null;

  @override
  List<Object?> get props => [identifier];

  @override
  String toString() => 'Subscription(slug: $slug, name: $name)';
}
