import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/sending_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtonsPanel extends StatelessWidget {
  const ActionButtonsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorPageState>(builder: (context, pageState, _) {
      return AnimatedContainer(
        key: const ValueKey("panel editor"),
        duration: const Duration(milliseconds: 300),
        padding:
            const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                ButtonComponent(
                  onTap: () {
                    pageState.toggleMediaEditing();
                  },
                  text: "Media",
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                ButtonComponent(
                  onTap: () {
                    pageState.toggleTextEditing();
                  },
                  text: "Text",
                  icon: const Icon(
                    Icons.text_fields,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          transitionDuration: const Duration(milliseconds: 300),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 300),
                          barrierDismissible: true,
                          pageBuilder: (BuildContext contexts, _, __) {
                            return const SendingBottomSheet();
                          }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(42),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      child: const Row(
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String text;
  const ButtonComponent({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        height: 50,
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
