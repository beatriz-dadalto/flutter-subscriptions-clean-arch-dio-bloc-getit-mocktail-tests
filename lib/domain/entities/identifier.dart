import 'package:equatable/equatable.dart';

/// Entidade que representa o identificador único de um recurso
///
/// Estrutura preparada para extensões futuras.
/// Exemplo de campos que podem ser adicionados:
/// - uuid, type, createdAt, etc.
class Identifier extends Equatable {
  final String slug;

  const Identifier({required this.slug});

  /// Factory para criar identifier vazio (útil em testes)
  const Identifier.empty() : slug = '';

  /// Valida se o identifier é válido
  bool get isValid => slug.isNotEmpty;

  @override
  List<Object?> get props => [slug];
}
