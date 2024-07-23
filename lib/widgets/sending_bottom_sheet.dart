import 'dart:ui';

import 'package:creator_flow/creator_page_state.dart';
import 'package:creator_flow/widgets/overlay_image.dart';
import 'package:creator_flow/widgets/overlay_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendingBottomSheet extends StatefulWidget {
  const SendingBottomSheet({
    super.key,
  });

  @override
  State<SendingBottomSheet> createState() => _SendingBottomSheetState();
}

class _SendingBottomSheetState extends State<SendingBottomSheet> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      showModalBottomSheet(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return const BottomSheet();
        },
      ).then((value) => Navigator.of(context).pop());
    });
    super.initState();
  }

  double calculateScale(BuildContext context, CreatorPageState pageState) {
    var height = MediaQuery.of(context).size.height;
    var originalHeight =
        height * 0.87; // The original height in CreatorPageContent
    var previewHeight =
        height * 0.3; // The preview height in SendingBottomSheet
    return previewHeight / originalHeight;
  }

  @override
  Widget build(BuildContext context) {
    var pageState = context.watch<CreatorPageState>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var scale = calculateScale(context, pageState);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Container(
              height: height,
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
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.black.withOpacity(0.1),
                height: height,
                width: width,
              ),
            ),
            // black overlay
            Container(
              color: Colors.black.withOpacity(0.5),
              height: height,
              width: width,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // back button
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      // Add back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(flex: 2),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Post your Spilll",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),

                  Hero(
                    tag: "sending bottom sheet",
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: pageState.state == CreatorPageStateEnum.ideal
                          ? height * 0.3
                          : height * 0.3,
                      width: width * 0.47,
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
                              pageState.state == CreatorPageStateEnum.transcript
                                  ? 8
                                  : 1),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          SizedBox(height: height, width: width),
                          ...List.generate(pageState.canvasWidgets.length,
                              (index) {
                            var widgetData = pageState.canvasWidgets[index];
                            if (widgetData.type == WidgetType.image) {
                              return OverlayedImage(
                                index: index,
                                imageUrl: widgetData.data,
                                scale: scale,
                              );
                            } else {
                              return OverlayedText(
                                index: index,
                                text: widgetData.data,
                                scale: scale,
                                textStyle: widgetData.textStyle!,
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.56,
      minChildSize: 0.55,
      maxChildSize: 1,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black, // Dark brown background
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: 70,
                        height: 6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.network(
                            'https://pbs.twimg.com/profile_images/1667222212947107840/JS3nP0Mn_400x400.jpg',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 12),
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5 Invite Access Codes Unlocked!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Your friends get direct access to hear your spilll",
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ])
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                      child: const Text(
                        'From Your Contacts',
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disables grid scrolling
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return _buildContactItem(
                            'AS', 'Amit Kumar', '12 Friends on Spilll');
                      },
                      itemCount: 9, // Adjust based on your needs
                    )
                  ],
                ),
              ),
              //  a post button on bottom sticked
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    // color: Colors.black,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF000000), // #000000 at 0%
                          Color(0xEB000000), // rgba(0, 0, 0, 0.92) at 69%
                          Color(0x00000000), // rgba(0, 0, 0, 0) at 100%
                        ],
                        stops: [
                          0.0,
                          0.69,
                          1.0,
                        ],
                      ),
                    ),

                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Post Your Spilll',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactItem(String initials, String name, String details) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        child: Text(
          initials,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        details,
        style: TextStyle(color: Colors.grey[500]),
      ),
      trailing: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white12,
          side: const BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Invite',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
