import 'package:creator_flow/creator_page.dart';
import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CreatorTool());
}

class CreatorTool extends StatelessWidget {
  const CreatorTool({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreatorPageState()),
        ],
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CreatorPage(),
          );
        });
  }
}
