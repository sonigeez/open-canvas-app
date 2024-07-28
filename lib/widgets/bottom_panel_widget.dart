import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/action_button.dart';
import 'package:creator_flow/widgets/media_bottom_sheet.dart';
import 'package:creator_flow/widgets/transcript_panel.dart';

class BottomPanelWidget extends StatelessWidget {
  const BottomPanelWidget({Key? key}) : super(key: key);

  Widget _buildBottomPanel(CreatorPageState pageState) {
    switch (pageState.state) {
      case CreatorPageStateEnum.media:
        return const MediaBottomPanel(
          key: ValueKey("media bottom panel"),
        );
      case CreatorPageStateEnum.transcript:
        return const TranscriptEditingPanel(
          key: ValueKey("transcript bottom panel"),
        );
      default:
        return const ActionButtonsPanel(
          key: ValueKey("action buttons panel"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<CreatorPageState>();
    var height = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: pageState.state == CreatorPageStateEnum.transcript
          ? height * 0.27
          : height * 0.123,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBottomPanel(pageState),
      ),
    );
  }
}
