import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

class CenterLineOverlay extends StatefulWidget {
  final Widget child;

  const CenterLineOverlay({super.key, required this.child});

  @override
  State<CenterLineOverlay> createState() => _CenterLineOverlayState();
}

class _CenterLineOverlayState extends State<CenterLineOverlay> {
  bool _previousShowHorizontal = false;
  bool _previousShowVertical = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(
      builder: (context, pageState, _) {
        final size = MediaQuery.of(context).size;
        final canvasCenterX = size.width / 2;
        final canvasCenterY = size.height / 2;

        bool showHorizontalLine = false;
        bool showVerticalLine = false;

        if (pageState.movingWidgetRect != null) {
          final rect = pageState.movingWidgetRect!;
          final widgetCenterX = rect.left + rect.width / 2;
          final widgetCenterY = rect.top + rect.height / 2;

          showHorizontalLine = (widgetCenterY - canvasCenterY).abs() < 10;
          showVerticalLine = (widgetCenterX - canvasCenterX).abs() < 10;

          if (showHorizontalLine && !_previousShowHorizontal) {
            Haptics.vibrate(HapticsType.soft);
          }
          if (showVerticalLine && !_previousShowVertical) {
            Haptics.vibrate(HapticsType.soft);
          }

          _previousShowHorizontal = showHorizontalLine;
          _previousShowVertical = showVerticalLine;
        }

        return Stack(
          children: [
            widget.child,
            if (showHorizontalLine)
              Positioned(
                left: 0,
                right: 0,
                top: canvasCenterY,
                child: Container(
                  height: 2,
                  color: Colors.white70,
                ),
              ),
            if (showVerticalLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: canvasCenterX,
                child: Container(
                  width: 2,
                  color: Colors.white70,
                ),
              ),
          ],
        );
      },
    );
  }
}
