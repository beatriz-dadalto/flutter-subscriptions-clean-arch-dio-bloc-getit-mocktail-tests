import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/author.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/author_avatar.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailAuthorsSection extends StatelessWidget {
  final List<Author> authors;

  const SubscriptionDetailAuthorsSection({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    if (authors.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return AuthorAvatar(author: authors[index]);
        },
      ),
    );
  }
}
