import 'package:creator_flow/widgets/background_bottom.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/done_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRightButton extends StatelessWidget {
  const TopRightButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return Positioned(
        top: MediaQuery.of(context).viewPadding.top,
        right: 0,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pageState.state != CreatorPageStateEnum.ideal
              ? DoneButton(onTap: () {
                  pageState.state = CreatorPageStateEnum.ideal;
                })
              : Column(
                  children: [
                    BackgroundButton(
                      onTap: () {
                        pageState.openBackgroundBottomSheet(context);
                      },
                      color: pageState.selectedColor,
                      image: pageState.backgroundImage,
                    ),
                    const SizedBox(height: 16),
                    // layers
                    IconButton(
                      onPressed: () {
                        pageState.navigateToLayersPage(context);
                      },
                      icon: const Icon(
                        Icons.layers,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
