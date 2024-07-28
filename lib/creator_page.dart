import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/top_right_button.dart';
import 'package:creator_flow/widgets/canvas_widget.dart';
import 'package:creator_flow/widgets/bottom_panel_widget.dart';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Stack(
          clipBehavior: Clip.none,
          children: [
            CreatorPageContent(),
            TopRightButton(),
          ],
        ),
      ),
    );
  }
}

class CreatorPageContent extends StatefulWidget {
  const CreatorPageContent({super.key});

  @override
  State<CreatorPageContent> createState() => _CreatorPageContentState();
}

class _CreatorPageContentState extends State<CreatorPageContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<CreatorPageState>();
    var height = MediaQuery.of(context).size.height;

    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: pageState.state == CreatorPageStateEnum.transcript
                ? height * 0.13
                : 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const CanvasWidget(),
          const BottomPanelWidget(),
        ],
      ),
    );
  }
}
