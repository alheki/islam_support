import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class LoadingTopCounterCardInfoWidget extends StatelessWidget {
  const LoadingTopCounterCardInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: SizeConfig.height*0.07,
                  width: SizeConfig.height*0.07,
                  child: const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                    ),
                  ),
                ),
              ],
            ),
            // title
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                height: SizeConfig.height*0.015,
                width: SizeConfig.height*0.1,
              ),
            ),

            // progr
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                height: SizeConfig.height*0.007,
                width: double.infinity,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: SizeConfig.height*0.01,
                    width: SizeConfig.height*0.013,
                  ),
                ),
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: SizeConfig.height*0.01,
                    width: SizeConfig.height*0.02,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
