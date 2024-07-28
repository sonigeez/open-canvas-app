import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/color_tab.dart';
import 'package:creator_flow/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranscriptEditingPanel extends StatefulWidget {
  const TranscriptEditingPanel({
    super.key,
  });

  @override
  State<TranscriptEditingPanel> createState() => _TranscriptEditingPanelState();
}

class _TranscriptEditingPanelState extends State<TranscriptEditingPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                .copyWith(bottom: 36),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pageState.isTextTabSelected = true;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: pageState.isTextTabSelected
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: pageState.isTextTabSelected
                              ? const Row(
                                  children: [
                                    Icon(Icons.text_fields,
                                        color: Colors.black),
                                    SizedBox(width: 8),
                                    Text(
                                      "Font",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : const Icon(Icons.text_fields,
                                  color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          pageState.isTextTabSelected = false;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: !pageState.isTextTabSelected
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: !pageState.isTextTabSelected
                              ? Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: pageState.primaryTextColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Color",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    // color: pageState
                                    //     .colors[pageState.activeColorTab],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ),
                      const Spacer(),
                      // alignment button
                      GestureDetector(
                        onTap: () {
                          // change alignment
                          pageState.cycleTextAlignment(
                            // get index which have text
                            pageState.canvasWidgets.indexWhere(
                              (element) => element.type == WidgetType.text,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.align_horizontal_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // change text's background color
                          pageState.cycleTextBgStyle();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "A",
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            //
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // linea break button
                      const Text(
                        "Line Break: 3",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom * 0.5),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: pageState.isTextTabSelected
                        ? const TextTab(
                            key: ValueKey("text tab"),
                          )
                        : const ColorTab(
                            key: ValueKey("color tab"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

//  transform: () {
//               if (!pageState.isSendingState) {
//                 return Matrix4.identity();
//               }
//               return Matrix4.identity()
//                 ..translate(100.0, -20.0, 0.0)
//                 ..scale(0.5);
//             }(),
