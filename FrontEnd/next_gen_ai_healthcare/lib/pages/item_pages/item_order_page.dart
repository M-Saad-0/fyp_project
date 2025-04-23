import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';

class ItemOrderPage extends StatefulWidget {
  final User user;
  const ItemOrderPage({super.key, required this.user});

  @override
  State<ItemOrderPage> createState() => _ItemOrderPageState();
}

class _ItemOrderPageState extends State<ItemOrderPage> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    BlocProvider.of<ItemRequestOrderBloc>(context)
        .add(ItemOrderRequired(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your order"),
        ),
        body: BlocBuilder<ItemRequestOrderBloc, ItemRequestOrderState>(
            builder: (context, state) {
          switch (state) {
            case ItemRequestOrderInitial():
              return const SizedBox();
            case ItemRequestOrderLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ItemRequestOrderError():
              return Center(
                child: Text(state.errorMessage),
              );
            case ItemRequestOrderSuccess():
              {
                return ListView.builder(itemBuilder: (context, index) {
                  final item = state.items[index];
                  final itemDocs = state.itemDocs[index];
                  final Color color = itemDocs['requestStatus'] == "Pending"
                      ? Colors.yellowAccent
                      : itemDocs['requestStatus'] == "Rejected"
                          ? Colors.redAccent
                          : Colors.greenAccent;
                  return Card(
                    child: ListTile(
                      title: Text(item.itemName),
                      subtitle: Text("${item.price} RS"),
                      leading: Image(image: NetworkImage(item.images[0])),
                      trailing: Text(
                        itemDocs['requestStatus'],
                        style: TextStyle(color: color),
                      ),
                    ),
                  );
                });
              }
          }
        }));
  }
}
