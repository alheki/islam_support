import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  const FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: Container(
        color: bgColor,
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: bgColor,
          ),
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
