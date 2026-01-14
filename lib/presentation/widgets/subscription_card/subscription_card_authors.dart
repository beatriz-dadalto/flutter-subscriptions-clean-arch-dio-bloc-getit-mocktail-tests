import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/author.dart';
import 'package:flutter/material.dart';

class SubscriptionCardAuthors extends StatelessWidget {
  final List<Author> authors;

  const SubscriptionCardAuthors({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    if (authors.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final authorNames = authors.map((author) => author.name).join(', ');

    return Row(
      children: [
        Icon(Icons.person_outline, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            authorNames,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
