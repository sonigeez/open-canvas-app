import 'dart:convert';
import 'dart:math';
import 'package:creator_flow/bottom_sheet_route.dart';
import 'package:creator_flow/widgets/background_bottom_sheet.dart';
import 'package:creator_flow/widgets/image_bottom_sheet.dart';
import 'package:creator_flow/widgets/layers_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:photo_manager/photo_manager.dart';

enum CreatorPageStateEnum { media, transcript, ideal }

enum TextBgStyle { solid, blur, none }

enum TextAlignment { left, center, right }

enum WidgetType { text, image }

class CreatorPageState with ChangeNotifier {
  Color selectedColor = Colors.amber;

  bool _isSendingState = false;
  String? _backgroundImage;

  int _activeTextTab = 0;

  bool _isTextTabSelected = true;
  CreatorPageStateEnum _state = CreatorPageStateEnum.ideal;
  List<WidgetData> canvasWidgets = [];
  TextBgStyle _textBgStyle = TextBgStyle.solid;
  Color _primaryTextColor = Colors.black;
  Color _secondaryTextColor = Colors.white;
  bool _showingColorPicker = false;

  List<TextStyle> textStyles = [
    GoogleFonts.inter(fontSize: 24),
    GoogleFonts.montserrat(fontSize: 24),
    GoogleFonts.newsreader(fontSize: 24),
    GoogleFonts.gelasio(fontSize: 24),
    GoogleFonts.chivo(fontSize: 24),
    GoogleFonts.recursive(fontSize: 24),
    GoogleFonts.commissioner(fontSize: 24),
    GoogleFonts.fredoka(fontSize: 24),
    GoogleFonts.palanquin(fontSize: 24),
    GoogleFonts.playfairDisplay(fontSize: 24),
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

  void toggleColorPicker() {
    _showingColorPicker = !_showingColorPicker;
    notifyListeners();
  }

  CreatorPageStateData toCreatorPageStateData() => CreatorPageStateData(
        activeTextTab: _activeTextTab,
        state: _state,
        canvasWidgets: canvasWidgets,
        textBgStyle: _textBgStyle,
        primaryTextColor: _primaryTextColor,
        secondaryTextColor: _secondaryTextColor,
        selectedColor: selectedColor,
        backgroundImage: _backgroundImage,
      );

  void loadFromCreatorPageStateData(CreatorPageStateData data) {
    _activeTextTab = data.activeTextTab;
    _state = data.state;
    canvasWidgets = data.canvasWidgets;
    _textBgStyle = data.textBgStyle;
    _primaryTextColor = data.primaryTextColor;
    _secondaryTextColor = data.secondaryTextColor;
    selectedColor = data.selectedColor;
    _backgroundImage = data.backgroundImage;
    notifyListeners();
  }

  String toJson() => jsonEncode(toCreatorPageStateData().toJson());

  static CreatorPageState fromJson(String jsonString) {
    final state = CreatorPageState();
    state.loadFromCreatorPageStateData(
        CreatorPageStateData.fromJson(jsonDecode(jsonString)));
    return state;
  }

  Future<void> setMovingState(bool moving, int? index) async {
    isMoving = moving;
    movingItemIndex = index;
    if (isMoving && !_hasTriggedHapticFeedback) {
      await Haptics.vibrate(HapticsType.soft);

      _hasTriggedHapticFeedback = true;
    } else if (!isMoving) {
      _hasTriggedHapticFeedback = false;
    }
    notifyListeners();
  }

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  void updatePrimaryTextColor(Color color) {
    _primaryTextColor = color;
    _secondaryTextColor = _isLightColor(color) ? Colors.black : Colors.white;
    notifyListeners();
  }

  void updateSecondaryTextColor(Color color) {
    _secondaryTextColor = color;
    notifyListeners();
  }

  void changeTextStyle(int index) {
    for (var i = 0; i < canvasWidgets.length; i++) {
      if (canvasWidgets[i].type == WidgetType.text) {
        canvasWidgets[i] = WidgetData(
          type: WidgetType.text,
          data: canvasWidgets[i].data,
          matrix: canvasWidgets[i].matrix,
          textStyleIdx: index,
        );
      }
    }
    _activeTextTab = index;
    notifyListeners();
  }

  final List<Color> colors = List.generate(
    22,
    (index) => Color.fromRGBO(
      Random().nextInt(255),
      Random().nextInt(255),
      Random().nextInt(255),
      1,
    ),
  );

  bool get isSendingState => _isSendingState;
  bool get showingColorPicker => _showingColorPicker;
  int get activeTextTab => _activeTextTab;
  bool get isTextTabSelected => _isTextTabSelected;
  CreatorPageStateEnum get state => _state;
  String? get backgroundImage => _backgroundImage;
  TextBgStyle get textBgStyle => _textBgStyle;
  Color get primaryTextColor => _primaryTextColor;
  Color get secondaryTextColor => _secondaryTextColor;

  void _addSampleWidgets() {
    canvasWidgets.add(WidgetData(
      type: WidgetType.text,
      data:
          "building systems that are too complex for them to understand and eventually ruining the economy",
      textStyleIdx: 0,
      matrix: Matrix4.identity(),
    ));
  }

  void changeMatrix(int index, Matrix4 matrix) {
    canvasWidgets[index] = WidgetData(
      type: canvasWidgets[index].type,
      data: canvasWidgets[index].data,
      textStyleIdx: canvasWidgets[index].textStyleIdx,
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
        textStyleIdx: canvasWidgets[index].textStyleIdx,
        textAlignment: newAlignment,
      );
      notifyListeners();
    }
  }

  void cycleTextBgStyle() {
    if (_textBgStyle == TextBgStyle.solid) {
      _textBgStyle = TextBgStyle.blur;
    } else if (_textBgStyle == TextBgStyle.blur) {
      _textBgStyle = TextBgStyle.none;
    } else {
      _textBgStyle = TextBgStyle.solid;
    }
    notifyListeners();
  }

  void navigateToLayersPage(BuildContext context) {
    Navigator.of(context).push(BottomSheetRoute(
      page: const LayersPage(),
    ));
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

  void openImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImageBottomSheet(
          onImageSelected: (AssetEntity image) async {
            final file = await image.file;
            if (file != null) {
              canvasWidgets.add(WidgetData(
                type: WidgetType.image,
                data: file.path,
                matrix: Matrix4.identity(),
              ));
            }
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

  void toggleMediaEditing() {
    _state = (_state == CreatorPageStateEnum.media)
        ? CreatorPageStateEnum.ideal
        : CreatorPageStateEnum.media;
    notifyListeners();
  }

  void changeState(CreatorPageStateEnum state) {
    _state = state;
    notifyListeners();
  }

  void sendCallback(context) {
    _isSendingState = !_isSendingState;
    openBackgroundBottomSheet(context);
    notifyListeners();
  }
}

class WidgetData {
  final WidgetType type;
  final dynamic data;
  final Matrix4 matrix;
  final int? textStyleIdx;
  final TextAlignment? textAlignment;

  WidgetData({
    required this.type,
    this.textStyleIdx,
    this.textAlignment = TextAlignment.left,
    required this.data,
    required this.matrix,
  });

  Map<String, dynamic> toJson() => {
        'type': type.toJson(),
        'data': data,
        'matrix': matrix.storage.toList(),
        'textStyleIdx': textStyleIdx,
        'textAlignment': textAlignment?.toJson(),
      };

  static WidgetData fromJson(Map<String, dynamic> json) => WidgetData(
        type: WidgetTypeExtension.fromJson(json['type']),
        data: json['data'],
        matrix: Matrix4.fromList(List<double>.from(json['matrix'])),
        textStyleIdx: json['textStyleIdx'],
        textAlignment: json['textAlignment'] != null
            ? TextAlignmentExtension.fromJson(json['textAlignment'])
            : null,
      );
}

extension CreatorPageStateEnumExtension on CreatorPageStateEnum {
  String toJson() => toString().split('.').last;
  static CreatorPageStateEnum fromJson(String json) =>
      CreatorPageStateEnum.values
          .firstWhere((e) => e.toString().split('.').last == json);
}

extension TextBgStyleExtension on TextBgStyle {
  String toJson() => toString().split('.').last;
  static TextBgStyle fromJson(String json) => TextBgStyle.values
      .firstWhere((e) => e.toString().split('.').last == json);
}

extension TextAlignmentExtension on TextAlignment {
  String toJson() => toString().split('.').last;
  static TextAlignment fromJson(String json) => TextAlignment.values
      .firstWhere((e) => e.toString().split('.').last == json);
}

extension WidgetTypeExtension on WidgetType {
  String toJson() => toString().split('.').last;
  static WidgetType fromJson(String json) =>
      WidgetType.values.firstWhere((e) => e.toString().split('.').last == json);
}

class CreatorPageStateData {
  final int activeTextTab;
  final CreatorPageStateEnum state;
  final List<WidgetData> canvasWidgets;
  final TextBgStyle textBgStyle;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color selectedColor;
  final String? backgroundImage;

  CreatorPageStateData({
    required this.activeTextTab,
    required this.state,
    required this.canvasWidgets,
    required this.textBgStyle,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.selectedColor,
    this.backgroundImage,
  });

  Map<String, dynamic> toJson() => {
        'activeTextTab': activeTextTab,
        'state': state.toJson(),
        'canvasWidgets': canvasWidgets.map((w) => w.toJson()).toList(),
        'textBgStyle': textBgStyle.toJson(),
        'primaryTextColor': primaryTextColor.value,
        'secondaryTextColor': secondaryTextColor.value,
        'selectedColor': selectedColor.value,
        'backgroundImage': backgroundImage,
      };

  static CreatorPageStateData fromJson(Map<String, dynamic> json) =>
      CreatorPageStateData(
        activeTextTab: json['activeTextTab'],
        state: CreatorPageStateEnumExtension.fromJson(json['state']),
        canvasWidgets: (json['canvasWidgets'] as List)
            .map((w) => WidgetData.fromJson(w))
            .toList(),
        textBgStyle: TextBgStyleExtension.fromJson(json['textBgStyle']),
        primaryTextColor: Color(json['primaryTextColor']),
        secondaryTextColor: Color(json['secondaryTextColor']),
        selectedColor: Color(json['selectedColor']),
        backgroundImage: json['backgroundImage'],
      );
}
