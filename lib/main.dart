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
            home: CreatorPage(),
          );
        });
  }
}

// class CounterAnimation extends StatefulWidget {
//   const CounterAnimation({super.key});
//   @override
//   State<CounterAnimation> createState() => _CounterAnimationState();
// }

// class _CounterAnimationState extends State<CounterAnimation>
//     with SingleTickerProviderStateMixin {
//   int _counter = 0;
//   late AnimationController _controller;
//   late Animation<Offset> _newSlideAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _sizeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _newSlideAnimation = Tween<Offset>(
//       begin: const Offset(0.0, -0.4),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     ));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));

//     _sizeAnimation = Tween<double>(
//       begin: 0.4,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//       _controller.forward(from: 0.0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//       body: Transform.scale(
//         scale: 4,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   FadeTransition(
//                     opacity: ReverseAnimation(_fadeAnimation),
//                     child: ScaleTransition(
//                       scale: ReverseAnimation(_sizeAnimation),
//                       child: Text(
//                         '${_counter - 1}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SlideTransition(
//                     position: _newSlideAnimation,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: ScaleTransition(
//                         scale: _sizeAnimation,
//                         child: Text(
//                           '$_counter',
//                           style: const TextStyle(
//                             fontSize: 70,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
