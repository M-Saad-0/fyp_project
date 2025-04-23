import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_order_bloc/item_order_bloc.dart';

class ItemPaymentPage extends StatefulWidget {
  final Item item;

  const ItemPaymentPage({super.key, required this.item});

  @override
  State<ItemPaymentPage> createState() => _ItemPaymentPageState();
}

class _ItemPaymentPageState extends State<ItemPaymentPage> {
  String selectedPaymentOption = "Cash on delivery";
  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    return Scaffold(
      appBar: AppBar(title: Text("Payment for ${widget.item.itemName}")),
      body: BlocListener<ItemOrderBloc, ItemOrderState>(
        listener: (context, state) {
          Widget widgetToShow;
          Widget textToShow;
          Icon iconToShow;
          switch (state) {
            case ItemOrderInitial():
              widgetToShow = const Text("Initial State -> Should not be shown");
              textToShow = const Text("Processing your order...");
              iconToShow = const Icon(Icons.access_time_sharp);
            case ItemOrderLoading():
              {
                widgetToShow = const Center(
                  child: CircularProgressIndicator(),
                );
                textToShow = const Text("Loading your order...");
                iconToShow = const Icon(Icons.access_time_sharp, color: Colors.amberAccent,);
              }
            case ItemOrderSuccess():
              {
                Navigator.pop(context);
                widgetToShow = Center(
                  child: Text(state.success),
                );
                textToShow = const Text("Order successful");
                iconToShow = const Icon(Icons.check_circle_outline_outlined, color: Colors.greenAccent,);
              }
            case ItemOrderError():
              {
                Navigator.pop(context);
                widgetToShow = Center(
                  child: Text(state.error),
                );
                textToShow = const Text("Order failed");
              iconToShow = const Icon(Icons.error, color: Colors.redAccent,);

              }
          }
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: textToShow,
                  content: SingleChildScrollView(
                  child: widgetToShow,
                  ),
                  icon: iconToShow,
                  actions: [
                  TextButton(
                    onPressed: () {
                    Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  ),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Choose Payment Method:",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              RadioListTile(
                  title: const Text("Cash on delivery"),
                  secondary: const Icon(Icons.handshake),
                  value: "Cash on delivery",
                  groupValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  }),
              RadioListTile(
                  title: const Text("Card"),
                  secondary: const Icon(Icons.credit_card),
                  value: "Card",
                  groupValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  }),
              RadioListTile(
                  secondary: const Icon(Icons.monetization_on),
                  title: const Text("Easypaisa"),
                  value: "Easypaisa",
                  groupValue: selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentOption = value!;
                    });
                  }),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ItemOrderBloc>(context).add(
                        ItemOrderCreateEvent(
                            item: widget.item,
                            user: user,
                            paymentMethod: selectedPaymentOption));
                  },
                  child: const Text("Proceed")),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
