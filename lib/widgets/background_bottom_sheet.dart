import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class BackgroundBottomSheet extends StatefulWidget {
  final void Function(Color) onColorSelected;
  final void Function(AssetEntity) onImageSelected;

  const BackgroundBottomSheet({
    super.key,
    required this.onColorSelected,
    required this.onImageSelected,
  });

  @override
  State<BackgroundBottomSheet> createState() => _BackgroundBottomSheetState();
}

class _BackgroundBottomSheetState extends State<BackgroundBottomSheet> {
  List<AssetEntity> _galleryImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    setState(() {
      _isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      if (albums.isNotEmpty) {
        final List<AssetEntity> images =
            await albums[0].getAssetListPaged(page: 0, size: 1000);
        setState(() {
          _galleryImages = images;
          _isLoading = false;
        });
      }
    } else {
      print('Permission to access gallery was denied');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCircularBackground(Color color, BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onColorSelected(color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3E2723),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Backgrounds',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCircularBackground(Colors.yellow, context),
                      _buildCircularBackground(Colors.lightBlue, context),
                      _buildCircularBackground(Colors.pink, context),
                      _buildCircularBackground(
                          Colors.pinkAccent[100]!, context),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                                widget.onImageSelected(_galleryImages[index]),
                            child: AssetEntityImage(
                              _galleryImages[index],
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(200),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: _galleryImages.length,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
