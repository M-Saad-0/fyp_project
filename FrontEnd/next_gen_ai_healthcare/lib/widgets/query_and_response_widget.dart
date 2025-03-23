
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/widgets/markdown_widget.dart';

class QueryAndResponseWidget extends StatelessWidget {
  final bool isLoading;
  final AiRequestModel model;

  const QueryAndResponseWidget({
    super.key,
    required this.isLoading,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .4,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(model.query)],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .85,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: .3),
            ),
            child:
                model.reponse == null || isLoading
                    ? CircularProgressIndicator()
                    : MarkdownWidgetCustom(markdownData: model.reponse!),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
