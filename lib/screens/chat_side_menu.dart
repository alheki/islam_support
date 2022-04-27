import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/components/custom_fields_widget.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/models/user_chat.dart';
import 'package:tshtri_support/providers/chat_provider.dart';
import 'package:tshtri_support/providers/home_provider.dart';
import 'package:tshtri_support/utils/debouncer.dart';

class ChatSideMenu extends StatefulWidget {

  final TextEditingController controller ;
  final Function(String val) onChanged;
  final Function(String val) onSubmit;
  final VoidCallback iconOnTap;

  const ChatSideMenu({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.iconOnTap,
  }) : super(key: key);

  @override
  State<ChatSideMenu> createState() => _ChatSideMenuState();
}

class _ChatSideMenuState extends State<ChatSideMenu> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  final String _textSearch = "";
  bool isLoading = false;
  String groupChatId = "";

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      if(mounted){
        await context.read<ChatProvider>().getClientsCount();
      }
    });
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);


    return Drawer(
      child:StreamBuilder<QuerySnapshot>(
        stream: homeProvider.getChatListActiveAndAllowedOnly(FirestoreConstants.pathUserCollection, _limit, _textSearch),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data?.docs.length ?? 0) > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(defaultPadding/3),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Image.asset("assets/images/logo.png"),
                            ),
                            const Text("Other Chats",style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(defaultPadding/3),),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: SearchField(
                                controller: widget.controller,
                                onSubmit: widget.onSubmit,
                                onChanged:widget. onChanged,
                                iconOnTap:widget.iconOnTap ,

                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        // SizedBox(
                        //   height: SizeConfig.height*0.07,
                        //   width: SizeConfig.height*0.07,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(5),
                        //     child:Container(
                        //       color: Colors.transparent,
                        //       child: CustomImageNetwork(
                        //         image:widget.image,
                        //         // image:image.toString(),
                        //         fit: BoxFit.cover,
                        //         loadingColor: Colors.white,
                        //         errorBackground: bgColor,
                        //         errorImage: 'error_avatar.png',
                        //         errorFit: BoxFit.cover,
                        //         errorImageSize: 30,
                        //         errorPadding: const EdgeInsets.only(bottom: 0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: SizeConfig.height*0.02,
                        // ),
                        // Text(
                        //   widget.name,
                        // ),
                        // SizedBox(
                        //   height: SizeConfig.height*0.005,
                        // ),
                        // Text(
                        //   widget.email,
                        // ),
                      ],
                    ),
                  ),
                  // DrawerHeader(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: SearchField(
                  //           controller: widget.controller,
                  //           onSubmit: widget.onSubmit,
                  //           onChanged:widget. onChanged,
                  //
                  //         ),
                  //       ),
                  //       // SizedBox(
                  //       //   height: SizeConfig.height*0.07,
                  //       //   width: SizeConfig.height*0.07,
                  //       //   child: ClipRRect(
                  //       //     borderRadius: BorderRadius.circular(5),
                  //       //     child:Container(
                  //       //       color: Colors.transparent,
                  //       //       child: CustomImageNetwork(
                  //       //         image:widget.image,
                  //       //         // image:image.toString(),
                  //       //         fit: BoxFit.cover,
                  //       //         loadingColor: Colors.white,
                  //       //         errorBackground: bgColor,
                  //       //         errorImage: 'error_avatar.png',
                  //       //         errorFit: BoxFit.cover,
                  //       //         errorImageSize: 30,
                  //       //         errorPadding: const EdgeInsets.only(bottom: 0),
                  //       //       ),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       // SizedBox(
                  //       //   height: SizeConfig.height*0.02,
                  //       // ),
                  //       // Text(
                  //       //   widget.name,
                  //       // ),
                  //       // SizedBox(
                  //       //   height: SizeConfig.height*0.005,
                  //       // ),
                  //       // Text(
                  //       //   widget.email,
                  //       // ),
                  //     ],
                  //   ),
                  // ),

                  ListView.separated(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    // ignore: prefer_const_constructors
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(defaultPadding/3),

                    itemBuilder: (context, index) => buildChatSideItem(context, snapshot.data?.docs[index],_limit,groupChatId),
                    itemCount: snapshot.data!.docs.length,
                    controller: listScrollController,
                    separatorBuilder: (context, index) => Divider(indent: 12,),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No users"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            );
          }
        },
      ),
    );
  }
  Widget buildChatSideItem(BuildContext context, DocumentSnapshot? document,int _limit,String groupChatId) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);


    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);

      return ElevatedButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(SizeConfig.height*0.01),
          backgroundColor: secondaryColor,
          elevation: 0,
          textStyle:Theme.of(context).textTheme.headline4!.copyWith(color:Colors.white,fontWeight: FontWeight.bold),

        ),
        onPressed:userChat.chatStatue.isNotEmpty&&userChat.chatStatue!='null'&&userChat.chatStatue=='active'? () async{
          chatProvider.resetAdminChatScreenData();

          chatProvider.setNewAdminChat(
            newPeerUserName: userChat.userName,
            newPeerId:userChat.id ,
            newPeerEmail: userChat.userEmail,
            newPeerAvatar: userChat.photoUrl,
            newCurrentId: UserDataFromStorage.supportAdminId.toString(),
            newCommonPerId: '100',
          );

        }:null,
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
                        image:userChat.photoUrl,
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
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userChat.userName,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.height*0.015,),),
                      Text(userChat.userEmail,textAlign: TextAlign.start,style: TextStyle(fontSize:SizeConfig.height*0.015,),),
                    ],
                  ),
                ),
              ],
            ),



            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color:userChat.chatStatue.isNotEmpty&&userChat.chatStatue!='null'&&userChat.chatStatue=='active'?Colors.green: Colors.red
                  ),
                ),
              ],
            ),
          ],
        ),

      );
    }
    else {
      return const Center(
        child: Text('No Chat'),
      );
    }
  }

}

