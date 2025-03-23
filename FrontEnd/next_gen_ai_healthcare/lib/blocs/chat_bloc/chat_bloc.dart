import 'dart:async';
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRequestImp chatRequestImp;
  final ChatRepositoryImp chatRepositoryImp;
  List<AiRequestModel> chatHistory = [];
  StreamSubscription<String>? _stream;
  ChatBloc(this.chatRequestImp, this.chatRepositoryImp) : super(ChatLoading()) {
    on<StartTheChat>((event, emit) async {
      emit(ChatLoading());
      try {
        chatHistory.add(event.model);
        emit(ChatDataChanges(myDataStream: List.from(chatHistory)));

        _stream = chatRequestImp.postAiResponse(event.model).listen((data) {
          add(StreamChatEvent(data: data));
        });
      } catch (e) {
        emit(ChatError());
      }
    });

    on<StreamChatEvent>((event, emit) async {
      chatHistory.last = chatHistory.last.copyFrom(reponse: event.data);
      emit(ChatDataChanges(myDataStream: List.from(chatHistory)));
      await Future.delayed(const Duration(milliseconds: 400));
      emit(ChatEnded());
    });

    on<LoadPreviousChatEvent>((event, emit) {
      emit(ChatDataChanges(myDataStream: List.from(chatHistory)));
    });
  }
  set updateChatHistory(List<AiRequestModel> newHistory) {
    chatHistory = newHistory;
    add(LoadPreviousChatEvent());
  }

  @override
  Future<void> close() async {
    _stream?.cancel();
    return super.close();
  }
}
