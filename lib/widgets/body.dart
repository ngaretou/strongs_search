import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/nav_controller.dart';

// Main body view, mainly a pageview builder
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController pageController = PageController();
  int? currentIndex;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    


    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          // bottomLeft: Radius.circular(10),
        ),
        child: Container(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(.3),
          child: Column(
            children: [
              // In the column, first the pageview builder itself, taking up all the space it can
              const Center(child: Text('data')),
              // Then a fixed-height container containing the page view control row
              Container(
                height: 70,
                color: Theme.of(context).colorScheme.surfaceDim.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left arrow button
                      Consumer<PageTracker>(builder: (context, value, child) {
                        if (value.currentPage == 0) {
                          return const SizedBox(
                            width: 20,
                          );
                        } else {
                          return IconButton.filled(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_back));
                        }
                      }),
                      // page number indicator

                      // right arrow button
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
