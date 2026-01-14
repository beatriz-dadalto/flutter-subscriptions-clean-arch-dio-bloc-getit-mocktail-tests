import 'package:equatable/equatable.dart';

/// Pure domain entity - represents an Author in the business domain.
///
/// This class is independent of JSON or API details, focusing solely on
/// the author's attributes and business logic.
class Author extends Equatable {
  final String name;
  final String? description;
  final String? photoSmallUrl;
  final String? photoLargeUrl;

  const Author({
    required this.name,
    this.description,
    this.photoSmallUrl,
    this.photoLargeUrl,
  });

  /// Factory constructor for creating fake [Author] instances, typically used in tests.
  ///
  /// Allows easy creation of mock author data for testing purposes.
  factory Author.fake({
    required String name,
    String? bio,
    String? photoSmallUrl,
    String? photoLargeUrl,
  }) {
    return Author(
      name: name,
      description: bio,
      photoSmallUrl: photoSmallUrl,
      photoLargeUrl: photoLargeUrl,
    );
  }

  /// Business helper
  bool get hasPhoto => photoSmallUrl != null || photoLargeUrl != null;
  bool get hasDescription => description != null && description!.isNotEmpty;
  String? get bestPhotoUrl => photoLargeUrl ?? photoSmallUrl;

  @override
  List<Object?> get props => [name, description, photoSmallUrl, photoLargeUrl];

  @override
  String toString() => 'Author(name: $name)';
}
