import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorTab extends StatelessWidget {
  const ColorTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              children: [
                const ColorPickerButton(),
                ...List.generate(
                  (pageState.colors.length / 2).ceil(),
                  (index) => ColorCircle(
                    index: index,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // pen icon
                IconButton(
                  onPressed: () {
                    pageState.toggleColorPicker();
                  },
                  icon: const Icon(
                    Icons.colorize,
                    color: Colors.white,
                  ),
                ),

                ...List.generate(
                  (pageState.colors.length / 2).ceil(),
                  (index) => ColorCircle(
                    index: index + (pageState.colors.length / 2).ceil(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(
      builder: (context, pageState, _) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pageState.selectedColor,
                      onColorChanged: (Color color) {
                        pageState.updatePrimaryTextColor(color);
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        // pageState.addCustomColor(pageState.selectedColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              gradient: const RadialGradient(
                colors: [Colors.white, Colors.black],
                stops: [0.2, 1.0],
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

class ColorCircle extends StatelessWidget {
  final int index;

  const ColorCircle({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      if (index >= pageState.colors.length) return const SizedBox.shrink();
      return GestureDetector(
        onTap: () {
          // pageState.updateTextBgColor(pageState.colors[index]);
          pageState.updatePrimaryTextColor(pageState.colors[index]);
        },
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: pageState.colors[index],
            shape: BoxShape.circle,
            border: pageState.primaryTextColor == pageState.colors[index]
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
        ),
      );
    });
  }
}
