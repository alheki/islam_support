import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class LoadingAllChatsItem extends StatelessWidget {

  const LoadingAllChatsItem({

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SkeletonTheme(
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ElevatedButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: SizeConfig.height*0.02,right: SizeConfig.height*0.02,bottom: SizeConfig.height*0.025,top: SizeConfig.height*0.025),
            backgroundColor: secondaryColor,
            elevation: 0,
            textStyle:Theme.of(context).textTheme.headline4!.copyWith(color:Colors.white,fontWeight: FontWeight.bold),
          ),
          onPressed: (){},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:Container(
                        color: Colors.transparent,
                        child: const SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width:SizeConfig.isMobile(context)?SizeConfig.height*0.11: SizeConfig.height*0.2,
                    height: SizeConfig.height*0.015,

                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(
                width:SizeConfig.isMobile(context)?SizeConfig.height*0.13: SizeConfig.height*0.2,
                height: SizeConfig.height*0.015,
                child: const SkeletonAvatar(
                  style: SkeletonAvatarStyle(),
                ),
              ),

              SizedBox(
                width: SizeConfig.height*0.13,
                height: SizeConfig.height*0.015,
                child: const SkeletonAvatar(
                  style: SkeletonAvatarStyle(),
                ),
              ),


              Container(
                width: SizeConfig.height*0.01,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.isMobile(context)?5:20,
                    width: SizeConfig.isMobile(context)?5:40,
                    alignment: Alignment.center,
                    child: const SkeletonAvatar(
                     style: SkeletonAvatarStyle(),
                   ),
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }
}
