part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistAddEvent extends WishlistEvent {
  final String itemId;
  final String userId;

  const WishlistAddEvent({required this.itemId, required this.userId});
  @override
  List<Object> get props => [itemId, userId];
}

class WishlistDeleteEvent extends WishlistEvent {
  final String itemId;
  final String userId;

  const WishlistDeleteEvent({required this.itemId, required this.userId});
  @override
  List<Object> get props => [itemId, userId];
}


class WishlistFetchEvent extends WishlistEvent {
  final String userId;

  const WishlistFetchEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}

class WishlistGetCurrentEvent extends WishlistEvent {
  final String itemId;
  final String userId;

  const WishlistGetCurrentEvent({required this.itemId, required this.userId});
  @override
  List<Object> get props => [itemId, userId];

}
class WishlistChangeCurrentEvent extends WishlistEvent {
  final bool currentState;

  const WishlistChangeCurrentEvent({required this.currentState});
  @override
  List<Object> get props => [currentState];
}