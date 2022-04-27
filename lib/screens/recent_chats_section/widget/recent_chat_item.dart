import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class RecentChatsItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool chatActive;
  final String photoUrl;
  final String userName;
  final String userEmail;
  final String createdAt;
  final bool userBlocked;

  const RecentChatsItem({
    required this.onTap,
    required this.chatActive,
    required this.photoUrl,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
    required this.userBlocked,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(left: SizeConfig.height*0.01,right: SizeConfig.height*0.01,bottom: SizeConfig.height*0.025,top: SizeConfig.height*0.025),
        backgroundColor: secondaryColor,
        elevation: 0,
        textStyle:Theme.of(context).textTheme.headline4!.copyWith(color:Colors.white,fontWeight: FontWeight.bold),
      ),
      onPressed:chatActive&&!userBlocked?onTap:null,
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
                width:SizeConfig.isMobile(context)?SizeConfig.height*0.11: SizeConfig.height*0.2,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(userName,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.013:SizeConfig.height*0.017,),),
              ),
            ],
          ),


          SizedBox(
            width:SizeConfig.isMobile(context)?SizeConfig.height*0.13: SizeConfig.height*0.2,
            child: Text(userEmail,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.012:SizeConfig.height*0.017,),),),

          Text( DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(createdAt))),textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.isMobile(context)?SizeConfig.height*0.012:SizeConfig.height*0.017,),),

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
                        style: const TextStyle(
                          fontSize: 9,
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
