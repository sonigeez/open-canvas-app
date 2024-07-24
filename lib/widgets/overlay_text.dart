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

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      final backgroundColor = _getBgColor(
        primaryColor: pageState.primaryTextColor,
        secondaryColor: pageState.secondaryTextColor,
        textBgStyle: pageState.textBgStyle,
      );

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
                              color: _getTextColor(
                            primaryColor: pageState.primaryTextColor,
                            secondaryColor: pageState.secondaryTextColor,
                            textBgStyle: pageState.textBgStyle,
                          )),
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

  _getBgColor({
    required Color primaryColor,
    required Color secondaryColor,
    required TextBgStyle textBgStyle,
  }) {
    switch (textBgStyle) {
      case TextBgStyle.solid:
        return primaryColor;
      case TextBgStyle.blur:
        return secondaryColor;
      case TextBgStyle.none:
        return Colors.transparent;
    }
  }

  _getTextColor({
    required Color primaryColor,
    required Color secondaryColor,
    required TextBgStyle textBgStyle,
  }) {
    switch (textBgStyle) {
      case TextBgStyle.solid:
        return secondaryColor;
      case TextBgStyle.blur:
        return primaryColor;
      case TextBgStyle.none:
        return primaryColor;
    }
  }
}
