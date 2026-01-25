import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_provider.dart';
import 'package:restaurant_app/provider/review/add_review_provider.dart';
import 'package:restaurant_app/static/add_review_state.dart';

class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key, required this.restaurantId});
  final String restaurantId;

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Review"),
      content: SizedBox(
        height: 200,
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Your Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: "Your Review"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Review cannot be empty";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        Consumer<AddReviewProvider>(
          builder: (context, provider, child) {
            final isLoading = provider.state is AddReviewLoadingState;
            return TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (_key.currentState!.validate()) {
                        await context.read<AddReviewProvider>().addreview(
                          widget.restaurantId,
                          _nameController.text,
                          _reviewController.text,
                        );

                        if (!context.mounted) return;

                        final state = context.read<AddReviewProvider>().state;

                        if (state is AddReviewSuccessState) {
                          context
                              .read<RestaurantDetailProvider>()
                              .updateCustomerReviews(
                                state.data.customerReviews,
                              );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Review added successfully"),
                            ),
                          );
                        } else if (state is AddReviewErrorState) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save"),
            );
          },
        ),
      ],
    );
  }
}
