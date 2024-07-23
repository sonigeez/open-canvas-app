import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/matrix_gesture_detector.dart';
import 'package:creator_flow/widgets/rounded_background_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverlayedText extends StatelessWidget {
  final int index;
  final String text;
  final TextStyle? textStyle;
  final double scale;

  const OverlayedText({
    required this.index,
    required this.text,
    super.key,
    this.textStyle,
    this.scale = 1,
  });

  bool isLightColor(Color color) {
    print(color.computeLuminance());
    return color.computeLuminance() > 0.5;
  }

  // Function to get contrasting background color
  Color getContrastingBackgroundColor(Color textColor) {
    return isLightColor(textColor)
        ? Colors.black.withOpacity(0.38)
        : Colors.white.withOpacity(0.38);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      final textColor = pageState.selectedColor;
      final backgroundColor = getContrastingBackgroundColor(textColor);

      return MatrixGestureDetector(
        onScaleEnd: () {
          pageState.setMovingState(false, null);
          pageState.updateMovingWidgetRect(null);
        },
        onScaleStart: () {
          pageState.setMovingState(true, index);
        },
        onMatrixUpdate: (m, tm, sm, rm) {
          pageState.changeMatrix(index, m);
          final translation = m.getTranslation();
          final size = context.size;
          if (size != null) {
            final rect = Rect.fromLTWH(
              translation.x,
              translation.y,
              size.width,
              size.height,
            );
            pageState.updateMovingWidgetRect(rect);
          }
        },
        child: AnimatedBuilder(
          animation: pageState,
          builder: (ctx, childWidget) {
            return Transform.scale(
              scale: scale,
              child: Transform(
                transform: pageState.canvasWidgets[index].matrix,
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: 300,
                        child: RoundedBackgroundText(
                          text,
                          textAlign: _getTextAlign(
                              pageState.canvasWidgets[index].textAlignment ??
                                  TextAlignment.left), // Add this line
                          style: textStyle!.copyWith(
                            color: pageState.colors[pageState.activeColorTab],
                          ),
                          backgroundColor: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  TextAlign _getTextAlign(TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.left:
        return TextAlign.left;
      case TextAlignment.center:
        return TextAlign.center;
      case TextAlignment.right:
        return TextAlign.right;
    }
  }
}
