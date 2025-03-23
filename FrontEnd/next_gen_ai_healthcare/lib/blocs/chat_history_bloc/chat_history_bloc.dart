
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  ChatBloc chatBloc;
  ChatHistoryBloc({required this.chatBloc}) : super(ChatHistoryInitial()) {
    on<LoadChatHistoryByDay>((event, emit) async {
      emit(ChatHistoryLoading());
      try {
        List<String> getKeys = await chatBloc.chatRepositoryImp.getChatKeys();
        emit(ChatHistoryLoaded(getKeys));
      } catch (error) {
        emit(ChatHistoryError(error.toString()));
      }
    });

    on<LoadChatHistoryOfADay>((event, emit) async {
      chatBloc.updateChatHistory =
          (await chatBloc.chatRepositoryImp.getEntireChat(
            event.key,
          )).allChatsPerDay;
    });
  }
}
