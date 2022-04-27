import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/components/custom_fields_widget.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/providers/menu_provider.dart';

class Header extends StatelessWidget {
  final bool adminStatusActive;
  final bool showSearch;
  final bool showBackButton;
  final bool showTitle;
  final VoidCallback userCardInTap;
  final VoidCallback iconOnTap;
  final TextEditingController controller ;
  final Function(String val) onChanged;
  final Function(String val) onSubmit;
  final Function(bool val) statusOnChanged;

  const Header({
    Key? key,
    required this.showSearch,
    required this.showBackButton,
    required this.showTitle,
    required this.userCardInTap,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.iconOnTap,
    required this.adminStatusActive,
    required this.statusOnChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        !showBackButton?Visibility(
          visible:!SizeConfig.isDesktop(context) ,
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        ):Container(),

        Visibility(
          visible: !SizeConfig.isMobile(context)&&showTitle,
          child:Text(
            "Support Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),

        Visibility(
          visible: !SizeConfig.isMobile(context)&&!showBackButton,
          child: Spacer(flex: SizeConfig.isDesktop(context) ? 2 : 1),
        ),


        Visibility(
          visible: showSearch,
          child: Expanded(
            child: SearchField(
              controller: controller,
              onSubmit: onSubmit,
              onChanged: onChanged,
              iconOnTap: iconOnTap,

            ),
          ),
        ),


        Visibility(
          visible:showBackButton,
          child:ElevatedButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(defaultPadding),
                backgroundColor: bgColor,
                elevation: 0,
                textStyle: const TextStyle(
                  color: Colors.white,
                )

            ),
            onPressed:(){
              Navigator.pop(context);
            },
            child:Icon(
                Icons.arrow_back_ios
            ),

          ),
        ),

        Visibility(
          visible: showBackButton,
          child: Spacer(flex:  2),
        ),
        StatusCard(
          adminStatusActive:adminStatusActive ,
          statusOnChanged:statusOnChanged ,
        ),

        ProfileCard(userCardInTap: userCardInTap,),

      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final VoidCallback userCardInTap;

  const ProfileCard({
    Key? key,
    required this.userCardInTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      child: InkWell(
        onTap: userCardInTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [

              SizedBox(
                height: 38,
                width: 38,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:Container(
                    color: Colors.transparent,
                    child: CustomImageNetwork(
                      image:UserDataFromStorage.supportAdminImage.isNotEmpty&&UserDataFromStorage.supportAdminImage.toString()!='null'?
                      UserDataFromStorage.supportAdminImage.toString():'https://web.tshtri.com/Images/Posts/avatar_admin.jpg',
                      // image:image.toString(),
                      fit: BoxFit.cover,
                      loadingColor: Colors.white,
                      errorBackground: bgColor,
                      errorImage: 'error_avatar.png',
                      errorFit: BoxFit.cover,
                      errorImageSize: 38,
                      errorPadding: const EdgeInsets.only(bottom: 0),

                    ),
                  ),
                ),
              ),


              if (!SizeConfig.isMobile(context))
                 Padding(
                  padding:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Text(UserDataFromStorage.supportAdminName.toString()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final bool adminStatusActive;
  final Function(bool val) statusOnChanged;

  const StatusCard({
    Key? key,
    required this.adminStatusActive,
    required this.statusOnChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding/7,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [

            Transform.scale(
              scale:!SizeConfig.isMobile(context)? 0.7:0.5,
              child:CupertinoSwitch(
                activeColor:primaryColor,
                value:adminStatusActive,
                onChanged: statusOnChanged,
              ),
            ),

            if (!SizeConfig.isMobile(context))
              Padding(
                padding:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(
                  adminStatusActive?"Active":'disActive',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
