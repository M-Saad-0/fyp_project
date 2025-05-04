import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_bloc/item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/your_items_bloc/your_items_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';

import 'package:next_gen_ai_healthcare/widgets/your_item_widget.dart';

class YourItemsPage extends StatefulWidget {
  final String userId ;
  const YourItemsPage({super.key, required this.userId});

  @override
  State<YourItemsPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<YourItemsPage> {
  String itemId = "";
  @override
  void initState() {
    context.read<YourItemsBloc>().add(YourItemsLoadEvent(userId: widget.userId));
    super.initState();
  }

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YourItemsPage"),
        actions: itemId==""?[
          IconButton(icon: const Icon(Icons.delete), onPressed: (){
            context.read<YourItemsBloc>().add(YourItemsDeleteEvent(itemId: widget.userId));
            setState(() {
              itemId = "";
            });
          },),
          const VerticalDivider(),
          IconButton(icon: const Icon(Icons.edit), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(
              create: (context) => CreateItemBloc(storeData: StoreDataImp()),
              child: AddItem(),
            )));
          },),
          const VerticalDivider(),
          IconButton(icon: const Icon(Icons.close), onPressed: (){
            setState(() {
              itemId = "";
            });
          },),
        ]:[],
          ),
      body: BlocBuilder<YourItemsBloc, YourItemsState>(
        builder: (context, state) {
          switch (state) {
            case YourItemsLoadingState():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case YourItemsSuccessState():
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<YourItemsBloc>().add(YourItemsLoadEvent(userId: widget.userId));
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
                            return GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  itemId = state.items[index].itemId;
                                });
                              },
                              child: YourItemWidget(
                                description: state.items[index].description,
                                images: state.items[index].images,
                                title: state.items[index].itemName,
                                seller: state.items[index].seller,
                                sold: state.items[index].sold,
                                rating: state.items[index].rating,
                              
                                darkenBackground: itemId == state.items[index].itemId,
                              ),
                            );
                          }),
                ),
              );

            case YourItemsErrorState():
              return RefreshIndicator(
                  child: Center(
                    child: Text(
                      state.errorMessage,
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
