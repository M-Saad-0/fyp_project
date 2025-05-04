import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/borrowing_process_bloc/borrowing_process_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_request_order_bloc/item_request_order_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/theme_bloc/theme_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/wishlist_bloc/wishlist_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/your_items_bloc/your_items_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/auth/splash_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_request_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/wishtlist_items.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/your_items_page.dart';
import 'package:next_gen_ai_healthcare/pages/settings/settings_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final User user =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user;
    final String name = user.userName;
    return SafeArea(
      child: Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          height: 50,
        ),
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            name
                .trim()
                .split(" ")
                .map((e) => e[0])
                .toList()
                .join()
                .toUpperCase(),
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(name),
        // Text(user.location.toString()), //TODO: Do something about it
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 0,
        ),
        const SizedBox(
          height: 10,
        ),

        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => ItemRequestOrderBloc(
                          orderAndPaymentImp: OrderAndPaymentImp())),
                  BlocProvider(
                    create: (context) => BorrowingProcessBloc(
                      orderAndPaymentImp: OrderAndPaymentImp(),
                    ),
                  ),
                ],
                child: ItemOrderPage(
                  user: user,
                ),
              );
            }));
          },
          leading: const Icon(Icons.inbox),
          title: const Text("Orders"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),

        // ListTile(
        //   onTap: () {},
        //   leading: const Icon(Icons.outbox),
        //   title: const Text("Your Order"),
        //   trailing: const Icon(Icons.arrow_forward_ios_outlined),
        // ),

        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => ItemRequestOrderBloc(
                              orderAndPaymentImp: OrderAndPaymentImp()),
                          child: ItemRequestPage(
                            user: user,
                          ),
                        )));
          },
          leading: const Icon(Icons.pending_actions),
          title: const Text("Requests"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),

        ListTile(
          onTap: () {},
          leading: const Icon(Icons.history),
          title: const Text("History"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => YourItemsBloc(
                              itemImp: RetrieveDataImp()),
                          child: YourItemsPage(userId:user.userId),
                        )));
          },
          leading: const Icon(Icons.biotech),
          title: const Text("Your Items"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) =>
                              WishlistBloc(wishlistOps: WishlistOps()),
                          child: WishtlistItems(user: user),
                        )));
          },
          leading: const Icon(Icons.favorite_outline_outlined),
          title: const Text("Wishlist"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),

        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ])),
    );
  }
}
