import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CustomImageNetwork extends StatelessWidget {
  final String image;
  final String errorImage;
  final BoxFit fit;
  final BoxFit errorFit;
  final Color errorBackground;
  final Color loadingColor;
  final double errorImageSize;
  final EdgeInsets errorPadding;

  const CustomImageNetwork({
    Key? key,
    required this.image,
    required this.fit,
    required this.errorBackground,
    required this.errorFit,
    required this.errorImage,
    required this.errorImageSize,
    required this.loadingColor,
    required this.errorPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Image.network(
    //   image.toString(),
    //   fit: fit,
    //   alignment: Alignment.center,
    //   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
    //     if (loadingProgress == null) return child;
    //     // return Center(
    //     //   child: CircularProgressIndicator(
    //     //     value: loadingProgress.expectedTotalBytes != null ?
    //     //     loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
    //     //     color: loadingColor,
    //     //     backgroundColor: loadingColor.withOpacity(0.2),
    //     //   ),
    //     // );
    //     return const SkeletonAvatar(
    //       style: SkeletonAvatarStyle(
    //       ),
    //     );
    //   },
    //
    //   errorBuilder: (context, error, stackTrace) {
    //     return Container(
    //       color: errorBackground,
    //       margin: errorPadding,
    //       child: Center(
    //         child: Image.asset(
    //           'assets/images/$errorImage',
    //           width: errorImageSize,
    //           height: errorImageSize,
    //           fit: errorFit,
    //         ),
    //       ),
    //     );
    //   },
    // );
    return CachedNetworkImage(
      fit: fit,
      alignment: Alignment.center,
      imageUrl: image.toString(),
      placeholder:(context, error,) {
        return const SkeletonAvatar(
          style: SkeletonAvatarStyle(
          ),
        );
      },

      errorWidget: (context, error, stackTrace) {
        return Container(
          color: errorBackground,
          margin: errorPadding,
          child: Center(
            child: Image.asset(
              'assets/images/user.png',
              width: errorImageSize,
              height: errorImageSize,
              fit: errorFit,
            ),
          ),
        );
      },
    );

  }
}
