import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/borrowing_process_bloc/borrowing_process_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';

class ReviewItemPage extends StatefulWidget {
  final Map<String, dynamic> itemBorrowed;
  const ReviewItemPage({super.key, required this.itemBorrowed});

  @override
  State<ReviewItemPage> createState() => _ReviewItemPageState();
}

class _ReviewItemPageState extends State<ReviewItemPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Success"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text(state.error)
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"))
                      ],
                    ));
          }
          if (state is ReviewUploadSuccess) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Success"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text("Successfully posted the review."),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"))
                      ],
                    ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _reviewController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter a review";
                      }
                      return null;
                    },
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: index <= selectedIndex
                            ? const Icon(Icons.star)
                            : const Icon(Icons.star_border),
                        color: Colors.amber,
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          context.read<ReviewBloc>().add(AddReviewEvent(
                              review: _reviewController.text,
                              itemBorrowed: widget.itemBorrowed,
                              rating: selectedIndex.toDouble()));
                          context
                              .read<BorrowingProcessBloc>()
                              .add(BorrowingProcessReviewdEvent(
                                itemBorrowed: widget.itemBorrowed,
                              ));
                          _reviewController.clear();
                          // Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Submit Review',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
