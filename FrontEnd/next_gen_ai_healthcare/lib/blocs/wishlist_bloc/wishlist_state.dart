part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();
  
  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}
final class WishlistLoadingState extends WishlistState {}
final class WishlistSuccessState extends WishlistState {
  final List<Item> wishlistItems;
  const WishlistSuccessState({required this.wishlistItems});
  @override 
  List<Object> get props => [wishlistItems];
}

final class WishlistErrorState extends WishlistState {
    final String error;
  const WishlistErrorState({required this.error});
  @override 
  List<Object> get props => [error];
}

final class WishlistDeleteErrorState extends WishlistState {
    final String error;
  const WishlistDeleteErrorState({required this.error});
  @override 
  List<Object> get props => [error];
}

final class WishlistDeleteSuccessState extends WishlistState {
   final String message;
  const WishlistDeleteSuccessState({required this.message});
  @override 
  List<Object> get props => [message];
}

final class WishlistCurrentState extends WishlistState{
  final bool currentState;

  const WishlistCurrentState({required this.currentState});
  @override 
  List<Object> get props => [currentState];
}