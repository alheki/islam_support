import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class SupportTeamItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool chatActive;
  final String photoUrl;
  final String userName;
  final String userEmail;
  final String createdAt;

  const SupportTeamItem({
    required this.onTap,
    required this.chatActive,
    required this.photoUrl,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(left: SizeConfig.height*0.02,right: SizeConfig.height*0.02,bottom: SizeConfig.height*0.025,top: SizeConfig.height*0.025),
        backgroundColor: secondaryColor,
        elevation: 0,
        textStyle:Theme.of(context).textTheme.headline4!.copyWith(color:Colors.white,fontWeight: FontWeight.bold),
      ),
      onPressed:chatActive?onTap:null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: 35,
                width: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:Container(
                    color: Colors.transparent,
                    child: CustomImageNetwork(
                      image:photoUrl,
                      // image:image.toString(),
                      fit: BoxFit.cover,
                      loadingColor: Colors.white,
                      errorBackground: bgColor,
                      errorImage: 'error_avatar.png',
                      errorFit: BoxFit.cover,
                      errorImageSize: 30,
                      errorPadding: const EdgeInsets.only(bottom: 0),
                    ),
                  ),
                ),
              ),

              Container(
                width:SizeConfig.isMobile(context)?SizeConfig.height*0.13: SizeConfig.height*0.25,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(userName,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.014:SizeConfig.height*0.018,),),
              ),
            ],
          ),


          SizedBox(
            width:SizeConfig.isMobile(context)?SizeConfig.height*0.15: SizeConfig.height*0.23,
            child: Text(userEmail,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.014:SizeConfig.height*0.018,),),),

          Text( DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt))),textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.014:SizeConfig.height*0.018,),),

          Container(
            width: SizeConfig.height*0.01,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: SizeConfig.isMobile(context)?7:25,
                width: SizeConfig.isMobile(context)?7:45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color:chatActive?Colors.green: Colors.red
                ),
                child: Visibility(
                  visible: !SizeConfig.isMobile(context),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        chatActive?'Active':'Closed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.isMobile(context)?SizeConfig.height*0.007:SizeConfig.height*0.013,
                          fontWeight: FontWeight.bold,
                        ),

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}
