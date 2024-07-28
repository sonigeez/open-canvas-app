import 'package:creator_flow/widgets/pixel_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/center_line_overlay.dart';
import 'package:creator_flow/widgets/overlay_image.dart';
import 'package:creator_flow/widgets/overlay_text.dart';

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<CreatorPageState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Hero(
      tag: "sending bottom sheet",
      child: ColorPicker(
        showMarker: pageState.showingColorPicker,
        onChanged: (response) {
          pageState.updatePrimaryTextColor(response.selectionColor);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: pageState.state == CreatorPageStateEnum.transcript
              ? height * 0.6
              : height * 0.87,
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
                  pageState.state == CreatorPageStateEnum.transcript ? 8 : 1),
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
                      textStyle: pageState.textStyles[widgetData.textStyleIdx!],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
