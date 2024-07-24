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

// import 'package:creator_flow/widgets/picker_response.dart';
// import 'package:creator_flow/widgets/pixel_picker.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const ImagePickerScreen(),
//     );
//   }
// }

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   State<ImagePickerScreen> createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   Image image = Image.network(
//     "https://pbs.twimg.com/profile_images/1675938226568065037/KqPt2DPg_400x400.jpg",
//     height: 300,
//   );
//   Color? color;
//   PickerResponse? userResponse;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Column(
//         children: [
//           ColorPicker(
//               showMarker: true,
//               onChanged: (response) {
//                 setState(() {
//                   userResponse = response;
//                   color = response.selectionColor;
//                 });
//               },
//               child: image),
//         ],
//       )),
//     );
//   }
// }
