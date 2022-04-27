import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tshtri_support/constants/color_constants.dart';

class LoadingAnimationWidget extends StatelessWidget {
  const LoadingAnimationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: ColorConstants.themeColor,
    );
  }
}
