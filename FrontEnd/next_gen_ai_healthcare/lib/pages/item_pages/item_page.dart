import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_bloc/item_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_detail_page.dart';
import 'package:next_gen_ai_healthcare/widgets/item_widget.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final TextEditingController searchController = TextEditingController();
  bool searchItem = false;
  late Map<String, dynamic> userLocation;
  @override
  void initState() {
    context.read<ItemBloc>().add(const ItemRequired());
    getLocation();
    super.initState();
  }

  getLocation() {
    userLocation =
        (context.read<AuthBloc>().state as AuthLoadingSuccess).user.location ??
            {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ItemPage"),
        actions: [
          searchItem
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      TextField(
                        onSubmitted: (searchTerm) {
                          context.read<ItemBloc>().add(ItemSearchRequired(
                              searchTerm: searchTerm, location: userLocation));
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(width: 0))),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            searchItem = true;
                          });
                        },
                        child: const Icon(Icons.close_sharp),
                      )
                    ],
                  ))
              : InkWell(
                  onTap: () {
                    setState(() {
                      searchItem = true;
                    });
                  },
                  child: const Icon(Icons.search),
                )
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          switch (state) {
            case ItemLoadingState():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ItemSuccessState():
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ItemBloc>().add(const ItemRequired());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: state.items.isEmpty
                      ? const Center(
                          child: Text("No Items Added Yet!"),
                        )
                      : GridView.builder(
                          itemCount: state.items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.85,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return ItemWidget(
                              description: state.items[index].description,
                              images: state.items[index].images,
                              title: state.items[index].itemName,
                              seller: state.items[index].seller,
                              sold: state.items[index].sold,
                              rating: state.items[index].rating,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemDetailPage(
                                            item: state.items[index])));
                              },
                            );
                          }),
                ),
              );

            case ItemErrorState():
              return RefreshIndicator(
                  child: Center(
                    child: Text(
                      state.error,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  onRefresh: () async {
                    context.read<ItemBloc>().add(const ItemRequired());
                  });
            default:
              return const Center(
                child: Text("No items yet"),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (BlocProvider(
                        create: (context) =>
                            CreateItemBloc(storeData: StoreDataImp()),
                        child: const AddItem(),
                      ))));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
