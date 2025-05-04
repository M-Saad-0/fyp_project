import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/calculate_location_bloc/calculate_location_bloc.dart';
import 'package:next_gen_ai_healthcare/widgets/calculate_location_text.dart';

class ItemWidget extends StatelessWidget {
  final List<String> images;
  final String title;
  final String seller;
  final int sold;
  final double rating;
  final String description;
  final VoidCallback onTap;
  final Map<String, dynamic> itemLocation;
  final Map<String, dynamic> userLocation;

  const ItemWidget(
      {super.key,
      required this.images,
      required this.title,
      required this.seller,
      required this.sold,
      required this.rating,
      required this.description,
      required this.onTap,
      required this.userLocation,
      required this.itemLocation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = images.isNotEmpty
        ? images[0]
        : 'https://www.accu-chek.com.pk/sites/g/files/iut956/f/styles/image_300x400/public/media_root/product_media_files/product_images/active-mgdl-300x400.png?itok=bgvuYJFy';

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
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
                  Text(
                    title,
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                    // style: theme.textTheme.bodyMedium?.copyWith(
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    // ),
                  ),
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
                      BlocProvider(
                          create: (context) => CalculateLocationBloc(),
                          child: CalculateLocationText(
                              userLocation: userLocation,
                              itemLocation: itemLocation))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: theme.primaryColor,
                        size: 16,
                      ),
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
    );
  }
}
