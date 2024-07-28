import 'package:creator_flow/creator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class ImageBottomSheet extends StatefulWidget {
  final void Function(AssetEntity) onImageSelected;

  const ImageBottomSheet({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<ImageBottomSheet> createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<ImageBottomSheet> {
  final List<AssetEntity> _galleryImages = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages({int page = 0, int size = 50}) async {
    if (page == 0) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      if (albums.isNotEmpty) {
        final List<AssetEntity> images =
            await albums[0].getAssetListPaged(page: page, size: size);
        setState(() {
          _galleryImages.addAll(images);
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } else {
      print('Permission to access gallery was denied');
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _loadMoreImages() {
    _currentPage++;
    _loadGalleryImages(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    var pageState = context.watch<CreatorPageState>();
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
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification &&
                  scrollInfo.metrics.extentAfter == 0 &&
                  !_isLoadingMore) {
                _loadMoreImages();
              }
              return false;
            },
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
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
