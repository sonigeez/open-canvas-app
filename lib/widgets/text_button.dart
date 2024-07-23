import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextTab extends StatelessWidget {
  const TextTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return Wrap(
        runSpacing: 8,
        spacing: 12,
        children: List.generate(
          pageState.textStyles.length,
          (index) => GestureDetector(
            onTap: () {
              pageState.changeTextStyle(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: pageState.activeTextTab == index
                    ? Colors.white
                    : const Color(0xff2C2C2E),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(
                "Aa",
                style: pageState.textStyles[index].copyWith(
                  color: pageState.activeTextTab == index
                      ? Colors.black
                      : Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
