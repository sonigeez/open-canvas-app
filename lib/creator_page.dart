import 'package:creator_flow/widgets/action_button.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/center_line_overlay.dart';
import 'package:creator_flow/widgets/overlay_image.dart';
import 'package:creator_flow/widgets/overlay_text.dart';
import 'package:creator_flow/widgets/pixel_picker.dart';
import 'package:creator_flow/widgets/top_right_button.dart';
import 'package:creator_flow/widgets/transcript_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<CreatorPageState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AnimatedContainer(
            duration: duration,
            curve: Curves.easeInOut,
            height: pageState.state == CreatorPageStateEnum.ideal
                ? 0
                : height * 0.13,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Hero(
            tag: "sending bottom sheet",
            child: ColorPicker(
              showMarker: pageState.showingColorPicker,
              onChanged: (response) {
                pageState.updatePrimaryTextColor(response.selectionColor);
              },
              child: AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                height: pageState.state == CreatorPageStateEnum.ideal
                    ? height * 0.87
                    : height * 0.6,
                width: width,
                decoration: BoxDecoration(
                  color: pageState.selectedColor.withOpacity(0.95),
                  image: pageState.backgroundImage != null
                      ? DecorationImage(
                          image: AssetImage(pageState.backgroundImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal:
                        pageState.state == CreatorPageStateEnum.transcript
                            ? 8
                            : 1),
                child: CenterLineOverlay(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(height: height, width: width),
                      ...List.generate(pageState.canvasWidgets.length, (index) {
                        var widgetData = pageState.canvasWidgets[index];
                        if (widgetData.type == WidgetType.image) {
                          return OverlayedImage(
                            index: index,
                            imageUrl: widgetData.data,
                          );
                        } else {
                          return OverlayedText(
                            index: index,
                            text: widgetData.data,
                            textStyle: widgetData.textStyle!,
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: duration,
            curve: Curves.easeInOut,
            height: pageState.state == CreatorPageStateEnum.ideal
                ? height * 0.123
                : height * 0.27,
            child: AnimatedSwitcher(
              duration: duration,
              child: pageState.state == CreatorPageStateEnum.transcript
                  ? const TranscriptEditingPanel()
                  : const ActionButtonsPanel(),
            ),
          ),
        ],
      ),
    );
  }
}
