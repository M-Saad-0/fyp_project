
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/widgets/query_and_response_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatEnded) {
            context.read<ChatBloc>().chatRepositoryImp.saveChat(
              context.read<ChatBloc>().chatHistory,
            );
          }
        },
        builder: (context, state) {
          final chatHistory = context.read<ChatBloc>().chatHistory;
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    chatHistory.isEmpty
                        ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text("Ask something!")),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return QueryAndResponseWidget(
                              isLoading: state is ChatStarted,
                              model: chatHistory[index],
                            );
                          }, childCount: chatHistory.length),
                        ),
                  ],
                ),
              ),

              // Input Field
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () {
                        final query = controller.text.trim();
                        if (query.isNotEmpty) {
                          context.read<ChatBloc>().add(
                            StartTheChat(
                              model: AiRequestModel(
                                query: query,
                                image: "",
                                date: DateTime.now().toIso8601String(),
                              ),
                            ),
                          );
                          controller.clear();
                          scrollController.jumpTo(
                            scrollController.position.maxScrollExtent,
                          );
                        }
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
