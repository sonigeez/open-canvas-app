import 'dart:math';

import 'package:creator_flow/widgets/background_bottom_sheet.dart';
import 'package:creator_flow/widgets/layers_page.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:photo_manager/photo_manager.dart';

enum CreatorPageStateEnum { image, media, transcript, ideal }

enum TextAlignment { left, center, right }

enum WidgetType { text, image }

class CreatorPageState with ChangeNotifier {
  Color selectedColor = Colors.amber;
  String editText = "Edit this text";

  bool _isSendingState = false;
  String? _backgroundImage;

  int _activeTextTab = 0;
  int _activeColorTab = 0;
  bool _isTextTabSelected = true;
  CreatorPageStateEnum _state = CreatorPageStateEnum.ideal;
  List<WidgetData> canvasWidgets = [];

  List<TextStyle> textStyles = [
    const TextStyle(fontFamily: 'Arial', fontSize: 24),
    const TextStyle(fontFamily: 'Times New Roman', fontSize: 24),
    const TextStyle(fontFamily: 'Courier', fontSize: 24),
    const TextStyle(fontFamily: 'Verdana', fontSize: 24),
    const TextStyle(fontFamily: 'Georgia', fontSize: 24),
    const TextStyle(fontFamily: 'Palatino', fontSize: 24),
    const TextStyle(fontFamily: 'Garamond', fontSize: 24),
    const TextStyle(fontFamily: 'Bookman', fontSize: 24),
    const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 24),
    const TextStyle(fontFamily: 'Trebuchet MS', fontSize: 24),
  ];

  bool isMoving = false;
  int? movingItemIndex;
  bool _hasTriggedHapticFeedback = false;

  Offset? movingWidgetPosition;
  bool showHorizontalLine = false;
  bool showVerticalLine = false;
  Rect? movingWidgetRect;

  void updateMovingWidgetRect(Rect? rect) {
    movingWidgetRect = rect;
    notifyListeners();
  }

  Future<void> setMovingState(bool moving, int? index) async {
    isMoving = moving;
    movingItemIndex = index;
    if (isMoving && !_hasTriggedHapticFeedback) {
      // HapticFeedback.selectionClick();
      await Haptics.vibrate(HapticsType.soft);

      _hasTriggedHapticFeedback = true;
    } else if (!isMoving) {
      _hasTriggedHapticFeedback = false;
    }
    notifyListeners();
  }

  void changeTextStyle(int index) {
    for (var i = 0; i < canvasWidgets.length; i++) {
      if (canvasWidgets[i].type == WidgetType.text) {
        canvasWidgets[i] = WidgetData(
          type: WidgetType.text,
          data: canvasWidgets[i].data,
          matrix: canvasWidgets[i].matrix,
          textStyle: textStyles[index].copyWith(color: colors[_activeColorTab]),
        );
      }
    }
    _activeTextTab = index;
    notifyListeners();
  }

  final List<Color> colors = List.generate(
    20,
    (index) => Color.fromRGBO(
      Random().nextInt(255),
      Random().nextInt(255),
      Random().nextInt(255),
      1,
    ),
  );

  bool get isSendingState => _isSendingState;
  int get activeTextTab => _activeTextTab;
  int get activeColorTab => _activeColorTab;
  bool get isTextTabSelected => _isTextTabSelected;
  CreatorPageStateEnum get state => _state;
  String? get backgroundImage => _backgroundImage;

  void _addSampleWidgets() {
    canvasWidgets.add(WidgetData(
      type: WidgetType.image,
      data:
          "https://pbs.twimg.com/profile_images/1675938226568065037/KqPt2DPg_400x400.jpg",
      matrix: Matrix4.identity(),
    ));
    canvasWidgets.add(WidgetData(
      type: WidgetType.image,
      data:
          'https://pbs.twimg.com/profile_images/1667222212947107840/JS3nP0Mn_400x400.jpg',
      matrix: Matrix4.identity(),
    ));
    canvasWidgets.add(WidgetData(
      type: WidgetType.text,
      data: 'Hold on tight while magically convert your voice into text...',
      textStyle: TextStyle(
        color: colors[_activeColorTab],
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      matrix: Matrix4.identity(),
    ));
  }

  void changeMatrix(int index, Matrix4 matrix) {
    canvasWidgets[index] = WidgetData(
      type: canvasWidgets[index].type,
      data: canvasWidgets[index].data,
      textStyle: canvasWidgets[index].textStyle,
      matrix: matrix,
    );
    notifyListeners();
  }

  CreatorPageState() {
    _addSampleWidgets();
  }

  set isSendingState(bool value) {
    _isSendingState = value;
    notifyListeners();
  }

  set activeTextTab(int value) {
    _activeTextTab = value;
    notifyListeners();
  }

  set activeColorTab(int value) {
    _activeColorTab = value;
    notifyListeners();
  }

  set isTextTabSelected(bool value) {
    _isTextTabSelected = value;
    notifyListeners();
  }

  set state(CreatorPageStateEnum value) {
    _state = value;
    notifyListeners();
  }

  void removeTransformationState(int index) {
    canvasWidgets.removeAt(index);
    notifyListeners();
  }

  void cycleTextAlignment(int index) {
    if (canvasWidgets[index].type == WidgetType.text) {
      TextAlignment currentAlignment = canvasWidgets[index].textAlignment!;
      TextAlignment newAlignment;
      switch (currentAlignment) {
        case TextAlignment.left:
          newAlignment = TextAlignment.center;
          break;
        case TextAlignment.center:
          newAlignment = TextAlignment.right;
          break;
        case TextAlignment.right:
          newAlignment = TextAlignment.left;
          break;
      }
      canvasWidgets[index] = WidgetData(
        type: WidgetType.text,
        data: canvasWidgets[index].data,
        matrix: canvasWidgets[index].matrix,
        textStyle: canvasWidgets[index].textStyle,
        textAlignment: newAlignment,
      );
      notifyListeners();
    }
  }

  void navigateToLayersPage(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        pageBuilder: (BuildContext contexts, _, __) {
          return const LayersPage();
        }));
  }

  void changeLayerIndex(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final WidgetData item = canvasWidgets.removeAt(oldIndex);
    canvasWidgets.insert(newIndex, item);
    notifyListeners();
  }

  void openBackgroundBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackgroundBottomSheet(
          onImageSelected: (AssetEntity image) async {
            _backgroundImage = (await image.file)!.path;
            notifyListeners();
            Navigator.of(context).pop();
          },
          onColorSelected: (color) {
            selectedColor = color;
            _backgroundImage = null;

            notifyListeners();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void toggleTextEditing() {
    _state = (_state == CreatorPageStateEnum.transcript)
        ? CreatorPageStateEnum.ideal
        : CreatorPageStateEnum.transcript;
    notifyListeners();
  }

  void sendCallback(context) {
    _isSendingState = !_isSendingState;
    openBackgroundBottomSheet(context);
    notifyListeners();
  }

  void navigateToSendingPage(context) {}
}

class WidgetData {
  final WidgetType type;
  final dynamic data;
  final Matrix4 matrix;
  final TextStyle? textStyle;
  final TextAlignment? textAlignment;
  WidgetData({
    required this.type,
    this.textStyle,
    this.textAlignment = TextAlignment.left,
    required this.data,
    required this.matrix,
  });
}
