part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

final class ChatLoading extends ChatState {}
final class ChatError extends ChatState {}
final class ChatStarted extends ChatState {}
final class ChatEnded extends ChatState {}
final class ChatDataChanges extends ChatState {
  final List<AiRequestModel> myDataStream;

  const ChatDataChanges({required this.myDataStream});
  @override
  List<Object> get props => [myDataStream];
}
