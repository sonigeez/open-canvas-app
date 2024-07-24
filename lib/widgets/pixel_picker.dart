import 'dart:ui' as ui;
import 'package:creator_flow/widgets/find_pixer_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ColorPicker extends StatefulWidget {
  final Widget child;
  final bool showMarker;
  final Function(PickerResponse color) onChanged;

  const ColorPicker({
    super.key,
    required this.child,
    required this.onChanged,
    required this.showMarker,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  FindPixelColor? _colorPicker;
  Offset fingerPosition = const Offset(0, 0);
  Offset pointerPosition = const Offset(0, 0);
  Color? selectedColor;

  final _repaintBoundaryKey = GlobalKey();
  final _interactiveViewerKey = GlobalKey();

  Future<ui.Image> _loadSnapshot() async {
    final RenderRepaintBoundary repaintBoundary =
        _repaintBoundaryKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;

    final snapshot = await repaintBoundary.toImage();
    return snapshot;
  }

  @override
  initState() {
    super.initState();
    // run the code after the widget finishes building
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fingerPosition = Offset(MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2);
      pointerPosition = Offset(fingerPosition.dx, fingerPosition.dy - 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showMarker) return widget.child;
    return Stack(
      fit: StackFit.loose,
      children: [
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: InteractiveViewer(
            key: _interactiveViewerKey,
            maxScale: 10,
            onInteractionStart: ((details) {
              _updatePositions(details.localFocalPoint);
              _onInteract();
            }),
            onInteractionUpdate: (details) {
              _updatePositions(details.localFocalPoint);
              _onInteract();
            },
            child: widget.child,
          ),
        ),
        if (widget.showMarker) ...[
          Positioned(
            left: pointerPosition.dx - 25,
            top: pointerPosition.dy - 25,
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: selectedColor ?? Colors.transparent, width: 10),
              ),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          )
        ]
      ],
    );
  }

  void _updatePositions(Offset newFingerPosition) {
    setState(() {
      fingerPosition = newFingerPosition;
      pointerPosition = Offset(fingerPosition.dx, fingerPosition.dy - 50);
    });
  }

  void _onInteract() async {
    if (_colorPicker == null) {
      final snapshot = await _loadSnapshot();
      final imageByteData =
          await snapshot.toByteData(format: ui.ImageByteFormat.png);
      final imageBuffer = imageByteData!.buffer;
      final uint8List = imageBuffer.asUint8List();
      _colorPicker = FindPixelColor(bytes: uint8List);
      snapshot.dispose();
    }

    final localOffset = _findLocalOffset(pointerPosition);
    final color = await _colorPicker!.getColor(pixelPosition: localOffset);
    selectedColor = color;

    PickerResponse response = PickerResponse(
      selectedColor ?? Colors.black,
      selectedColor?.red ?? 0,
      selectedColor?.blue ?? 0,
      selectedColor?.green ?? 0,
      "#${selectedColor?.toHex().substring(3)}",
      pointerPosition.dx,
      pointerPosition.dy,
    );

    widget.onChanged(response);
  }

  Offset _findLocalOffset(Offset offset) {
    final RenderBox interactiveViewerBox =
        _interactiveViewerKey.currentContext!.findRenderObject() as RenderBox;
    return interactiveViewerBox.globalToLocal(offset);
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  String getHexCode() {
    return '#${value.toRadixString(16)}';
  }
}

class PickerResponse {
  final Color selectionColor;
  final int redScale;
  final int blueScale;
  final int greenScale;
  final String hexCode;
  final double xposition;
  final double yposition;

  PickerResponse(
    this.selectionColor,
    this.redScale,
    this.blueScale,
    this.greenScale,
    this.hexCode,
    this.xposition,
    this.yposition,
  );
}
