import 'dart:ui' as ui;

import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/matrix_gesture_detector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverlayedImage extends StatelessWidget {
  final int index;
  final String imageUrl;
  final double scale;

  const OverlayedImage({
    required this.index,
    required this.imageUrl,
    this.scale = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<CreatorPageState>();
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
            final shouldBlur = pageState.movingItemIndex != null &&
                pageState.movingItemIndex! < index;
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
                      decoration: BoxDecoration(
                        border: pageState.isMoving &&
                                pageState.movingItemIndex == index
                            ? Border.all(color: Colors.white70, width: 1)
                            : null,
                      ),
                      child: SmoothBlur(
                        blur: shouldBlur,
                        child: Image.network(
                          imageUrl,
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

class SmoothBlur extends StatelessWidget {
  final Widget child;
  final bool blur;

  const SmoothBlur({
    super.key,
    required this.child,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    if (!blur) {
      return child;
    }

    return Stack(
      children: [
        Opacity(opacity: blur ? 0.6 : 0, child: child),
        Positioned.fill(
          child: Opacity(
            opacity: blur ? 1 : 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: Colors.black
                      .withOpacity(0), // Adjust the opacity as needed
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
