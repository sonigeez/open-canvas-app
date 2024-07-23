import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorTab extends StatelessWidget {
  const ColorTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              children: List.generate(
                (pageState.colors.length / 2).ceil(),
                (index) => ColorCircle(
                  index: index,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: List.generate(
                (pageState.colors.length / 2).ceil(),
                (index) => ColorCircle(
                  index: index + (pageState.colors.length / 2).ceil(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ColorCircle extends StatelessWidget {
  final int index;

  const ColorCircle({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      if (index >= pageState.colors.length) return const SizedBox.shrink();
      return GestureDetector(
        onTap: () {
          pageState.activeColorTab = index;
        },
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: pageState.colors[index],
            shape: BoxShape.circle,
            border: pageState.activeColorTab == index
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
        ),
      );
    });
  }
}
