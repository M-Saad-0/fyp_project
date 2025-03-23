
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_history_bloc/chat_history_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/chat_pages/chat_page.dart';
import 'package:next_gen_ai_healthcare/pages/chat_pages/drawer_history.dart';

class AiChatBot extends StatefulWidget {
  const AiChatBot({super.key});

  @override
  State<AiChatBot> createState() => _AiChatBotState();
}

class _AiChatBotState extends State<AiChatBot>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> slideAnimation;
  bool dragAnimation = false;
  late AuthState authState;
  
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    authState = context.read<AuthBloc>().state;
    
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    slideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (!dragAnimation) {
            animationController.forward();
          }
          else if (dragAnimation) {
            animationController.reverse();
          }
          dragAnimation=!dragAnimation;
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            animationController.value += details.primaryDelta! / 275;
          } else if (details.delta.dx < 0) {
            animationController.value += details.primaryDelta! / 275;
          }
        },
        child: Stack(
          children: [
            BlocProvider(
              create:
                  (context) { final bloc = ChatHistoryBloc(
                    chatBloc: context.read<ChatBloc>(),
                    
                  );
                  bloc.add(LoadChatHistoryByDay());
                  return bloc;
                  },
              child:  DrawerHistory(user: (authState as AuthLoadingSuccess).user),
            ),
            AnimatedBuilder(
              animation: slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(265 * slideAnimation.value, 0),
                  child: GestureDetector(
                    onTap: () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      }
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        title: const Text("AI Chat"),
                        leading: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            if (animationController.isCompleted) {
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                          },
                        ),
                      ),
                      body:  const ChatPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
