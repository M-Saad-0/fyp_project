import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_payment_page.dart';
import 'package:next_gen_ai_healthcare/widgets/show_toast.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;

  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {

  bool itemAddedToWishList = false;
  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.itemName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: widget.item.images.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Image.network(widget.item.images[index],
                            fit: BoxFit.contain));
                  },
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                  text: TextSpan(
                      text: "Rs ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      children: [
                    TextSpan(
                        text: widget.item.price.toString(),
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600))
                  ])),
              const SizedBox(
                height: 10,
              ),
              Text(widget.item.itemName,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Text("Seller: ${widget.item.seller}",
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.item.rating.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                  const VerticalDivider(),
                  Text(
                    "Rented ${widget.item.sold.toString()} times",
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                  const VerticalDivider(),
                  Text(
                    widget.item.isRented ? "Rented" : "Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 13,
                        color: widget.item.isRented ? Colors.red : Colors.green),
                  ),
                  const Spacer(),
                  BlocProvider(
                    create: (context) => WishlistBloc(wishlistOps: WishlistOps())
                      ..add(WishlistGetCurrentEvent(
                          itemId: widget.item.itemId, userId: user.userId)),
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                        builder: (context, state) {
                      if (state is WishlistCurrentState) {
                        itemAddedToWishList = state.currentState;
                        print("object");
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return IconButton(
                              onPressed: () {
                                setState(() {
                                  itemAddedToWishList = !itemAddedToWishList;
                                });
                                if (itemAddedToWishList) {
                                  context.read<WishlistBloc>().add(WishlistAddEvent(
                                      itemId: widget.item.itemId,
                                      userId: user.userId));
                                } else if (!itemAddedToWishList) {
                                  context.read<WishlistBloc>().add(
                                      WishlistDeleteEvent(
                                          itemId: widget.item.itemId,
                                          userId: user.userId));
                                }
                              },
                              icon: itemAddedToWishList
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border));
                        }
                      );
                    }),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.item.description,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
                switch (state) {
                  case ReviewLoading():
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ReviewSuccess():
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.reviewModel.length,
                        itemBuilder: (context, index) {
                          final nameInitials = state.reviewModel[index].renterName
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
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(
                                  height: 8,
                                ),
                                StarRating(
                                  rating: state.reviewModel[index].personRating,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  case ReviewError():
                  default:
                    return const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text("No Reviews Yet!"),
                        ),
                      ],
                    );
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: widget.item.isRented
              ? () {
                  showToastMessage("${widget.item.itemName} already rented");
                }
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => ItemOrderBloc(
                                  orderAndPaymentImp: OrderAndPaymentImp()),
                              child: ItemPaymentPage(item: widget.item),
                            )),
                  );
                },
          child: const Text("Proceed to Payment"),
        ),
      ),
    );
  }
}
