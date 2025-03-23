part of 'chat_history_bloc.dart';

sealed class ChatHistoryState extends Equatable {
  const ChatHistoryState();

  @override
  List<Object> get props => [];
}

final class ChatHistoryInitial extends ChatHistoryState {}

final class ChatHistoryLoading extends ChatHistoryState {}

final class ChatHistoryError extends ChatHistoryState {
  final String message;

  const ChatHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatHistoryLoaded extends ChatHistoryState {
  final List<String> keys;

  const ChatHistoryLoaded(this.keys);

  @override
  List<Object> get props => [keys];
}
