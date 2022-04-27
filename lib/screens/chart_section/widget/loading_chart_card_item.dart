import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class LoadingChartCardItemWidget extends StatefulWidget {
  const LoadingChartCardItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingChartCardItemWidget> createState() => _LoadingChartCardItemWidgetState();
}

class _LoadingChartCardItemWidgetState extends State<LoadingChartCardItemWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: SkeletonTheme(
        themeMode: ThemeMode.light,
        shimmerGradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            secondaryColor.withOpacity(0.2),
            secondaryColor.withOpacity(0.5),
            secondaryColor.withOpacity(0.9),
            secondaryColor.withOpacity(0.9),
          ],
          stops: const [
            0.0,
            0.3,
            0.5,
            0.7,
            1,
          ],
          begin: const Alignment(-2.4, -0.2),
          end: const Alignment(2.4, 0.2),
          tileMode: TileMode.repeated,
        ),
        child: Row(
          children: [

            const SizedBox(
              height: 20,
              width: 20,
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(),
              ),
            ),

            const SizedBox(
              width: 20,
            ),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:SizeConfig.height*0.1,
                      height: SizeConfig.height*0.01,
                      child: const SkeletonAvatar(
                        style: SkeletonAvatarStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width:SizeConfig.height*0.04,
              height: SizeConfig.height*0.01,
              child: const SkeletonAvatar(
                style: SkeletonAvatarStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
