part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}


class StartTheChat extends ChatEvent{
  final AiRequestModel model;

  const StartTheChat({required this.model});
  @override
  List<Object> get props => [model];

}


class StreamChatEvent extends ChatEvent{
    final String data;

  const StreamChatEvent({required this.data});
  @override
  List<Object> get props => [data];
}


class LoadPreviousChatEvent extends ChatEvent{}