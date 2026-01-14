import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/author.dart';
import 'package:flutter/material.dart';

class AuthorAvatar extends StatelessWidget {
  final Author author;
  final double size;

  const AuthorAvatar({super.key, required this.author, this.size = 60});

  bool get _hasValidPhoto =>
      author.photoSmallUrl != null && author.photoSmallUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage: _hasValidPhoto
              ? NetworkImage(author.photoSmallUrl ?? '')
              : null,
          child: _hasValidPhoto
              ? null
              : Text(
                  _getInitials(),
                  style: TextStyle(
                    fontSize: size / 2.5,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: size + 20,
          child: Text(
            author.name,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getInitials() {
    final names = author.name.trim().split(' ');
    if (names.isEmpty) return '?';
    if (names.length == 1) {
      return names.first[0].toUpperCase();
    }
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }
}
