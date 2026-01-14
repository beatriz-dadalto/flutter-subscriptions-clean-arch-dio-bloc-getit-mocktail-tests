import 'package:equatable/equatable.dart';

/// Pure domain entity - represents a Feature or Benefit in the business domain.
///
/// This class is independent of JSON or API details, focusing solely on
/// the feature's attributes and business logic.
class Feature extends Equatable {
  final String title;
  final String description;

  const Feature({required this.title, required this.description});

  /// Factory constructor for creating fake [Feature] instances, typically used in tests.
  ///
  /// Allows easy creation of mock feature data for testing purposes.
  factory Feature.fake({required String title, required String description}) {
    return Feature(title: title, description: description);
  }

  /// Business helper
  bool get isValid => title.isNotEmpty;
  bool get hasDescription => description.isNotEmpty;

  @override
  List<Object?> get props => [title, description];

  @override
  String toString() => 'Feature(title: $title)';
}
