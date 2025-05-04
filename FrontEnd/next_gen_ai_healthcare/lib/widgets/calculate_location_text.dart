import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/calculate_location_bloc/calculate_location_bloc.dart';

class CalculateLocationText extends StatefulWidget {
  final Map<String, dynamic> userLocation;
  final Map<String, dynamic> itemLocation;
  const CalculateLocationText({super.key, required this.userLocation, required this.itemLocation});
  
  @override
  State<CalculateLocationText> createState() => _CalculateLocationTextState();
}

class _CalculateLocationTextState extends State<CalculateLocationText> {
  @override
  void initState() {
    super.initState();
    context.read<CalculateLocationBloc>().add(CalculateLocationDistanceEvent(itemLocation: widget.itemLocation, userLocation: widget.userLocation));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculateLocationBloc, CalculateLocationState>(builder: (context, state){
      switch(state) {
        case CalculateLocationInitial():
          return const Text("Calc");
        case CalculateLocationLoading():
          return const Center(child: CircularProgressIndicator(),);
        case CalculateLocationSuccess():
          return Text(state.location);
      }
    });
  }

  }

