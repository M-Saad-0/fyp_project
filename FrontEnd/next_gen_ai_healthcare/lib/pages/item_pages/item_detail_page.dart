import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_payment_page.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.itemName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: item.images.length,
                itemBuilder: (context, index) {
                  return Image.network(item.images[index], fit: BoxFit.cover);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(item.itemName,
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text("Seller: ${item.seller}",
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.rating.toString()),
                const SizedBox(
                  width: 5,
                ),
                StarRating(
                  rating: item.rating,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(item.description,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              item.sold > 0 ? "Sold Out" : "Available",
              style: TextStyle(
                color: item.sold > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  switch (state) {
                    case ReviewLoading():
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ReviewSuccess():
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: state.reviewModel.length,
                          itemBuilder: (context, index) {
                            final nameInitials = state
                                .reviewModel[index].renterName
                                .split(" ")
                                .map((e) => e[0])
                                .join()
                                .toUpperCase();
                            return Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Text(nameInitials),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(state.reviewModel[index].renterName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                    ],
                                  ),
                                  Text(state.reviewModel[index].review,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  StarRating(
                                    rating:
                                        state.reviewModel[index].personRating,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    case ReviewError():
                    default:
                      return const Center(
                        child: Text("No Reviews Yet!"),
                      );
                  }
                })
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: item.sold > 0
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => ItemOrderBloc(
                                  orderAndPaymentImp: OrderAndPaymentImp()),
                              child: ItemPaymentPage(item: item),
                            )),
                  );
                },
          child: const Text("Proceed to Payment"),
        ),
      ),
    );
  }
}
