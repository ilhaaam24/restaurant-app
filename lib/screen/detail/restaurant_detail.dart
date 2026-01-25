import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_provider.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({super.key, required this.id});
  final String id;

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<RestaurantDetailProvider>();
    Future.microtask(() {
      provider.fetchRestaurantDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Detail")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<RestaurantDetailProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                RestaurantDetailLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                RestaurantDetailLoadedState(data: var restaurant) =>
                  BodyOfDetailScreen(restaurant: restaurant),
                RestaurantDetailErrorState() => const Center(
                  child: Text('Error loading restaurant details'),
                ),
                _ => const SizedBox(),
              };
            },
          ),
        ),
      ),
    );
  }
}
