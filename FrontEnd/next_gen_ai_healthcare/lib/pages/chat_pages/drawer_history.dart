import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_history_bloc/chat_history_bloc.dart';

class DrawerHistory extends StatefulWidget {
  final User user;
  const DrawerHistory({super.key, required this.user});

  @override
  State<DrawerHistory> createState() => _DrawerHistoryState();
}

class _DrawerHistoryState extends State<DrawerHistory> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ChatHistoryBloc>().add(LoadChatHistoryByDay());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.sizeOf(context).width * .70,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Text(
                "Your History",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                builder: (context, state) {
                  switch (state) {
                    case ChatHistoryLoading():
                      return const Center(child: CircularProgressIndicator());
                    case ChatHistoryError():
                      return Center(child: Text(state.message));
                    case ChatHistoryLoaded():
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.keys.isEmpty
                              ?  [
                                  const SizedBox(height: 250,),
                                  const Icon(Icons.content_paste_search_sharp),
                                  const SizedBox(height: 10,),

                                   const Text("No prompt stored yet"),
                                  
                                ]
                              : state.keys
                                  .map(
                                    (key) => ListTile(
                                      leading: const Icon(Icons.history),
                                      title: Text(key.split("T")[0]),
                                      onTap: () async {
                                        context
                                            .read<ChatHistoryBloc>()
                                            .add(LoadChatHistoryOfADay(key));
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      );
                    default:
                      return const Center(child: Text('No chat history found'));
                  }
                },
              ),
              const Spacer(),
              Divider(
                height: 0,
              ),
              ListTile(
                // tileColor: Theme.of(context).colorScheme.surface,
                leading: CircleAvatar(
                  backgroundImage: widget.user.picture != null &&
                          widget.user.picture!.isNotEmpty
                      ? NetworkImage(widget.user.picture!)
                      : null,
                  child: widget.user.picture == null ||
                          widget.user.picture!.isEmpty
                      ? Text(widget.user.userName
                          .trim()
                          .split(" ")
                          .map((e) => e[0])
                          .join()
                          .toUpperCase())
                      : null,
                ),
                title: Text(widget.user.userName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
