import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/providers/menu_provider.dart';

class ChatHeader extends StatelessWidget {
  final bool isAdminChat;
  final bool showBackButton;
  final bool showCloseChatButton;
  final String name;
  final String email;
  final String image;
  final String accountType;
  final VoidCallback closeOnTap;

  const ChatHeader({
    Key? key,
    required this.isAdminChat,
    required this.showCloseChatButton,
    required this.showBackButton,
    required this.name,
    required this.email,
    required this.image,
    required this.accountType,
    required this.closeOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding/3,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible:showBackButton,
                child:ElevatedButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(defaultPadding/5),
                      backgroundColor: secondaryColor,
                      elevation: 0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      )

                  ),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  child:const Icon(
                      Icons.arrow_back_ios
                  ),

                ),
              ),

              Visibility(
                visible: isAdminChat,
                child: Row(
                  children: [
                    SizedBox(
                      height:SizeConfig.isMobile(context)? SizeConfig.height*0.035:SizeConfig.height*0.045,
                      width:SizeConfig.isMobile(context)? SizeConfig.height*0.035:SizeConfig.height*0.045,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:Container(
                          color: Colors.transparent,
                          child: CustomImageNetwork(
                            image:image.isNotEmpty&&image.toString()!='null'?
                            image.toString():'https://web.tshtri.com/Images/Posts/avatar_admin.jpg',
                            // image:image.toString(),
                            fit: BoxFit.cover,
                            loadingColor: Colors.white,
                            errorBackground: bgColor,
                            errorImage: 'error_avatar.png',
                            errorFit: BoxFit.cover,
                            errorImageSize: 035,
                            errorPadding: const EdgeInsets.only(bottom: 0),

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.isMobile(context)? SizeConfig.height*0.0:SizeConfig.height*0.01,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: Text(name.toString(),
                            style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.015:SizeConfig.height*0.017,fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                          child: Text(email.toString(),
                            style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.011:SizeConfig.height*0.015,),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

            ],
          ),

          Visibility(
            visible: showCloseChatButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 0.5,
                      vertical: defaultPadding / (SizeConfig.isMobile(context) ? 3 : 1),
                    ),
                  ),
                  onPressed: closeOnTap,
                  child: Text("End Chat",style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.013:SizeConfig.height*0.016,fontWeight: FontWeight.bold),),
                ),
                const SizedBox(width: defaultPadding/2),

              ],
            ),
          ),

        ],
      ),
    );
  }
}

