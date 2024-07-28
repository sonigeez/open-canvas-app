import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaBottomPanel extends StatefulWidget {
  const MediaBottomPanel({
    super.key,
  });

  @override
  State<MediaBottomPanel> createState() => _MediaBottomPanelState();
}

class _MediaBottomPanelState extends State<MediaBottomPanel>
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
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                // back button
                ButtonComponent(
                  onTap: () {
                    pageState.changeState(CreatorPageStateEnum.ideal);
                  },
                  text: "Back",
                  icon: const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                ButtonComponent(
                  onTap: () {
                    pageState.openImageBottomSheet(context);
                  },
                  text: "Image",
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                ButtonComponent(
                  onTap: () {},
                  text: "Camera",
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                ButtonComponent(
                  onTap: () {},
                  text: "Stickers",
                  icon: const Icon(
                    Icons.sticky_note_2_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
