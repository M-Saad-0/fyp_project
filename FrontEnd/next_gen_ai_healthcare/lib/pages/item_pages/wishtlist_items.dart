import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_detail_page.dart';

class WishtlistItems extends StatefulWidget {
  final User user;
  const WishtlistItems({super.key, required this.user});

  @override
  State<WishtlistItems> createState() => _WishtlistItemsState();
}

class _WishtlistItemsState extends State<WishtlistItems> {
  @override
  void initState() {
    context
        .read<WishlistBloc>()
        .add(WishlistFetchEvent(userId: widget.user.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            switch (state) {
              case WishlistLoadingState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case WishlistSuccessState():
                return ListView.builder(
                    itemCount: state.wishlistItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                              state.wishlistItems[index].images[0]),
                          title: Text(state.wishlistItems[index].itemName),
                          subtitle:
                              Text("Rs ${state.wishlistItems[index].price}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text(
                                        "Are you sure you want to remove this item from the wishlist?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                if (context.mounted) {
                                  context.read<WishlistBloc>().add(
                                      WishlistDeleteEvent(
                                          itemId:
                                              state.wishlistItems[index].itemId,
                                          userId: widget.user.userId));
                                }
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider(
                                create: (context) => ReviewBloc(reviewOps: ReviewOps()),
                                child: ItemDetailPage(
                                    item: state.wishlistItems[index]),
                              );
                            }));
                          },
                        ),
                      );
                    });
              case WishlistErrorState():
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              default:
                return const Center(
                  child: Text(
                    "Some unexpected error occured",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
