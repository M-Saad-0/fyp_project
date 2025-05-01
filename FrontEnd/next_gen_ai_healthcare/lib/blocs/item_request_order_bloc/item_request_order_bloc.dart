import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'item_request_order_event.dart';
part 'item_request_order_state.dart';

class ItemRequestOrderBloc
    extends Bloc<ItemRequestOrderEvent, ItemRequestOrderState> {
  final OrderAndPaymentImp orderAndPaymentImp;
  ItemRequestOrderBloc({required this.orderAndPaymentImp})
      : super(ItemRequestOrderInitial()) {
    on<ItemOrderRequired>((event, emit) async {
      Result<String, String> items =
          await orderAndPaymentImp.getItemsUserOrdered(event.user);
      if (items.isFailure) {
        emit(ItemRequestOrderError(errorMessage: items.error!));
      } else {
        final objects = jsonDecode(items.value!) as Map<String, dynamic>;
        final orderItems = (objects['itemObjects'] as List)
                .map((item) => Item.fromEntity(ItemEntity.fromJson(item as Map<String, dynamic>)))
                .toList();
        final itemObjects = (objects['borrowedItems'] as List).map((i){ return i as Map<String, dynamic>;}).toList();
        debugPrint(orderItems.length.toString());
        if(orderItems.isEmpty){
          emit(const ItemRequestOrderError(errorMessage: "No Orders Found"));
          return;
        }
        emit(ItemRequestOrderSuccess(
            items: orderItems,
            itemDocs: itemObjects));
      }
    });

    on<ItemRequestRequired>((event, emit) async {
      Result<String, String> items =
          await orderAndPaymentImp.getOrderRequest(event.user);
      if (items.isFailure) {
        emit(ItemRequestOrderError(errorMessage: items.error!));
      } else {
        final objects = jsonDecode(items.value!) as Map<String, dynamic>;
        final requestedItems = (objects['itemObjects'] as List)
                .map((item) => Item.fromEntity(ItemEntity.fromJson(item as Map<String, dynamic>)))
                .toList();
        final itemObjects = (objects['lentedItems'] as List).map((i){ return i as Map<String, dynamic>;}).toList();
        debugPrint(requestedItems.length.toString());
        if(requestedItems.isEmpty){
          emit(const ItemRequestOrderError(errorMessage: "No Requests Found"));
          return;
        }
        emit(ItemRequestOrderSuccess(
            items: requestedItems,
            itemDocs: itemObjects));
      }
    });
  }
}
