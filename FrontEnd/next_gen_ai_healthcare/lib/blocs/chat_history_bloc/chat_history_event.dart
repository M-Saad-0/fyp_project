part of 'chat_history_bloc.dart';

sealed class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistoryByDay extends ChatHistoryEvent{}
class LoadChatHistoryOfADay extends ChatHistoryEvent{
  final String key;

  const LoadChatHistoryOfADay(this.key);

  @override
  List<Object> get props => [key];
}
