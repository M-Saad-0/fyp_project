import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_bloc/item_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';
import 'package:next_gen_ai_healthcare/widgets/item_widget.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ItemPage"),
      ),
      body: BlocProvider(
        create: (context) => ItemBloc(retrieveData: RetrieveDataImp()),
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            switch(state) {
              case ItemLoadingState():
                return const Center(child: CircularProgressIndicator(),);
              case ItemSuccessState():
                return RefreshIndicator(
              onRefresh: () async {
                  context.read<ItemBloc>().add(const ItemRequired());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: state.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.85,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return  ItemWidget(description: state.items[index].description, images: state.items[index].images, title: state.items[index].itemName, seller: state.items[index].seller, sold: state.items[index].sold, rating: state.items[index].rating,
                        
                      );
                    }),
              ),
            );
          
              case ItemErrorState():
                return RefreshIndicator(child: Center(child: Text(state.error, style: TextStyle(color: Theme.of(context).colorScheme.error),),), onRefresh: ()async{
                  context.read<ItemBloc>().add(const ItemRequired());
                });
               default:
                return const Center(child: Text("No items yet"),);
            }
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>(BlocProvider(
          create: (context) => CreateItemBloc(storeData: StoreDataImp()),
          child: const AddItem(),)
        )));
      }, child: const Icon(Icons.add),),
    );
  }
}