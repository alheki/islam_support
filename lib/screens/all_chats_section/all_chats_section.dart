import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/components/custom_image_network.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/helper/navigation_functions.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/models/user_chat.dart';
import 'package:tshtri_support/screens/all_chats_section/widget/all_chat_item.dart';
import 'package:tshtri_support/screens/all_chats_section/widget/loading_all_chat_item.dart';
import 'package:tshtri_support/screens/chat_screens/admin_chat_screen.dart';
import 'package:tshtri_support/providers/chat_provider.dart';
import 'package:tshtri_support/providers/home_provider.dart';
import 'package:tshtri_support/utils/debouncer.dart';

class AllChatSection extends StatefulWidget {
  final TextEditingController searchBarTec;
  final StreamController<bool> btnClearController;
  final Debouncer searchDebouncer;
  final bool isAllChat;
  final bool isActiveChat;
  final bool isClosedChat;
  const AllChatSection({
    Key? key,
    required this.searchBarTec,
    required this.btnClearController,
    required this.searchDebouncer,
    required this.isAllChat,
    required this.isActiveChat,
    required this.isClosedChat,
  }) : super(key: key);

  @override
  State<AllChatSection> createState() => _AllChatSectionState();
}

class _AllChatSectionState extends State<AllChatSection> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  bool isLoading = false;



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
    widget.btnClearController.close();
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
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return Container(
      padding:const EdgeInsets.all(defaultPadding),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !SizeConfig.isDesktop(context),
            child: Text(
              widget.isAllChat?"All Chats":widget.isActiveChat?"Active Chats":widget.isClosedChat?"Finished Chats":'',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.isActiveChat?homeProvider.getChatListActiveAndAllowedOnly(FirestoreConstants.pathUserCollection, _limit, widget.searchBarTec.text):
              widget.isClosedChat?homeProvider.getChatListClosedOnly(FirestoreConstants.pathUserCollection, _limit, widget.searchBarTec.text):
              homeProvider.getClientsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, widget.searchBarTec.text),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: !SizeConfig.isDesktop(context),
                          child: const Padding(
                            padding: EdgeInsets.all(defaultPadding/3),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            // ignore: prefer_const_constructors
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildChats(context, snapshot.data?.docs[index]),
                            itemCount: snapshot.data!.docs.length,
                            controller: listScrollController,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text("Nothing here.."),
                    );
                  }
                } else {
                  return ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    // ignore: prefer_const_constructors
                    shrinkWrap: true,
                    itemBuilder: (context, index) => const LoadingAllChatsItem(),
                    itemCount: 10,
                    padding: EdgeInsets.zero,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


Widget buildChats(BuildContext context, DocumentSnapshot? document) {
  ChatProvider chatProvider = Provider.of<ChatProvider>(context);

  if (document != null) {
    UserChat userChat = UserChat.fromDocument(document);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: AllChatsItem(
        onTap:() async{
          await chatProvider.checkSupportChatOpening(userId: userChat.id.toString());
          customPushNavigator(context, const AdminChatScreen());
          chatProvider.resetAdminChatScreenData();
          await chatProvider.setNewAdminChat(
            newCommonPerId: '100',
            newCurrentId: UserDataFromStorage.supportAdminId.toString(),
            newPeerAvatar:userChat.photoUrl ,
            newPeerEmail:userChat.userEmail ,
            newPeerId: userChat.id,
            newPeerUserName:userChat.userName ,

          );
        } ,
        userBlocked:userChat.allowed=='blocked' ,
        chatActive:userChat.chatStatue.isNotEmpty&&userChat.chatStatue!='null'&&userChat.chatStatue=='active',
        photoUrl:userChat.photoUrl ,
        userName: userChat.userName,
        createdAt: userChat.createdAt,
        userEmail:userChat.userEmail ,
      ),
    );
  }
  else {
    return const Center(
      child: Text('No Chat'),
    );
  }
}

DataRow recentFileDataRow(BuildContext context, DocumentSnapshot? document) {
  ChatProvider chatProvider = Provider.of<ChatProvider>(context);
  UserChat userChat = UserChat.fromDocument(document!);
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(userChat.userName,textAlign: TextAlign.left,),
              ),
            ],
          ),
        ),
        DataCell(Text(userChat.userEmail,textAlign: TextAlign.left,),),
        DataCell(Text(userChat.timestamp,textAlign: TextAlign.left,),),
      ],
    );





}
