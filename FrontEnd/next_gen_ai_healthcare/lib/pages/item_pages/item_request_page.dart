import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/borrowing_process_bloc/borrowing_process_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/location_map_page.dart';

class ItemRequestPage extends StatefulWidget {
  final User user;
  const ItemRequestPage({super.key, required this.user});

  @override
  State<ItemRequestPage> createState() => _ItemRequestPageState();
}

class _ItemRequestPageState extends State<ItemRequestPage> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    BlocProvider.of<ItemRequestOrderBloc>(context)
        .add(ItemRequestRequired(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your request"),
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
                return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final itemDocs = state.itemDocs[index];
                      final Color color = itemDocs['requestStatus'] == "Pending"
                          ? Colors.yellowAccent
                          : itemDocs['requestStatus'] == "Rejected"
                              ? Colors.redAccent
                              : Colors.greenAccent;
                      return BlocProvider(
                        create: (context) => BorrowingProcessBloc(
                            orderAndPaymentImp: OrderAndPaymentImp()),
                        child: BlocBuilder<BorrowingProcessBloc,
                            BorrowingProcessState>(
                          builder: (context, state) {
                            String requestStatus = itemDocs['requestStatus'];
                            if (state is BorrowingProcessSuccessState) {
                              requestStatus =
                                  state.borrowedItem['requestStatus'];
                            }
                            return Card(
                              child: ListTile(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return LocationMapPage(
                                              itemLocation: item.location,
                                              userLocation:
                                                  widget.user.location!,
                                              itemId: item.itemId);
                                        });
                                  },
                                  title: Text(item.itemName),
                                  subtitle: Text("${item.price} RS"),
                                  leading: Image(
                                      image: NetworkImage(item.images[0])),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      (state is BorrowingProcessSuccessState)
                                          ? Text(
                                              state.borrowedItem[
                                                  'requestStatus'],
                                              style: TextStyle(color: color),
                                            )
                                          : Text(
                                              itemDocs['requestStatus'],
                                              style: TextStyle(color: color),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      requestStatus ==
                                              RequestStatuses.Pending.name
                                          ? PopupMenuButton(
                                              itemBuilder: (context) {
                                              return <PopupMenuItem>[
                                                PopupMenuItem(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              BorrowingProcessBloc>()
                                                          .add(BorrowingProcessActionEvent(
                                                              itemBorrowed:
                                                                  itemDocs,
                                                              newRequestStatus:
                                                                  RequestStatuses
                                                                      .Accepted
                                                                      .name));
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.check),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Accept")
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              BorrowingProcessBloc>()
                                                          .add(BorrowingProcessActionEvent(
                                                              itemBorrowed:
                                                                  itemDocs,
                                                              newRequestStatus:
                                                                  RequestStatuses
                                                                      .Rejected
                                                                      .name));
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons.close),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Reject")
                                                      ],
                                                    ))
                                              ];
                                            })
                                          : requestStatus ==
                                                  RequestStatuses.Returing.name
                                              ? PopupMenuButton(
                                                  itemBuilder: (context) =>
                                                      <PopupMenuItem>[
                                                    PopupMenuItem(
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons.handshake),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Confirm Return")
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                BorrowingProcessBloc>()
                                                            .add(BorrowingProcessActionEvent(
                                                                itemBorrowed:
                                                                    itemDocs,
                                                                newRequestStatus:
                                                                    RequestStatuses
                                                                        .Returned
                                                                        .name));
                                                      },
                                                    )
                                                  ],
                                                )
                                              : const SizedBox()
                                    ],
                                  )),
                            );
                          },
                        ),
                      );
                    });
              }
          }
        }));
  }
}
