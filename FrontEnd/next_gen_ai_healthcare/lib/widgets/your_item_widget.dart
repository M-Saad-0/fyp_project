import 'package:flutter/material.dart';

class YourItemWidget extends StatelessWidget {
  final List<String> images;
  final String title;
  final String seller;
  final int sold;
  final double rating;
  final String description;
  final bool darkenBackground; // 🔥 added this bool

  const YourItemWidget({
    super.key,
    required this.images,
    required this.title,
    required this.seller,
    required this.sold,
    required this.rating,
    required this.description,
    this.darkenBackground = false, // 🔥 default false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = images.isNotEmpty
        ? images[0]
        : 'https://www.accu-chek.com.pk/sites/g/files/iut956/f/styles/image_300x400/public/media_root/product_media_files/product_images/active-mgdl-300x400.png?itok=bgvuYJFy';

    return Stack(
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.5,
              color: theme.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Row(
                      children: [
                        Text(
                          seller,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const VerticalDivider(),
                        Text(
                          '$sold sold',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: theme.primaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    
        // 🔥 ADD overlay if darkenBackground is true
        if (darkenBackground)
          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}
