import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/components/loading_view.dart';
import 'package:tshtri_support/constants/app_constants.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/models/popup_choices.dart';
import 'package:tshtri_support/models/user_chat.dart';
import 'package:tshtri_support/screens/chat_screens/admin_chat_screen.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:tshtri_support/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/utils/debouncer.dart';

import '../screens/login_screens/login_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key,}) : super(key: key);


  @override
  State createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  AdminHomePageState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late AdminLoginProvider adminLoginProvider;
  late ClientChatProvider authProvider;
  late HomeProvider homeProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Settings', icon: Icons.settings),
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    authProvider = context.read<ClientChatProvider>();
    homeProvider = context.read<HomeProvider>();
    adminLoginProvider = context.read<AdminLoginProvider>();

    // registerNotification();
    // configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void scrollListener() {

    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  Future<bool> onBackPress() {
    // openDialog();
    Navigator.pop(context,);
    return Future.value(false);
  }

  Future<void> handleSignOut(BuildContext context) async {
    adminLoginProvider.handleSignOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    print('chatClosed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: ColorConstants.primaryColor),
        ),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              handleSignOut(context);
            },
            child: Container(
              child: const Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(bottom: 10),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Column(
              children: [
                buildSearchBar(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeProvider.getAllAccountsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _textSearch),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            // ignore: prefer_const_constructors
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) => buildItem(context, snapshot.data?.docs[index]),
                            itemCount: snapshot.data?.docs.length,
                            controller: listScrollController,
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
                ),
              ],
            ),

            // Loading
            Positioned(
              child: isLoading ? const LoadingView() : SizedBox.shrink(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: ColorConstants.greyColor, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search nickname (you have to type exactly string)',
                hintStyle: TextStyle(fontSize: 13, color: ColorConstants.greyColor),
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          setState(() {
                            _textSearch = "";
                          });
                        },
                        child: Icon(Icons.clear_rounded, color: ColorConstants.greyColor, size: 20))
                    : SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.greyColor2,
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  // Widget buildPopupMenu() {
  //   return PopupMenuButton<PopupChoices>(
  //     onSelected: onItemMenuPress,
  //     itemBuilder: (BuildContext context) {
  //       return choices.map((PopupChoices choice) {
  //         return PopupMenuItem<PopupChoices>(
  //             value: choice,
  //             child: Row(
  //               children: <Widget>[
  //                 Icon(
  //                   choice.icon,
  //                   color: ColorConstants.primaryColor,
  //                 ),
  //                 Container(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   choice.title,
  //                   style: TextStyle(color: ColorConstants.primaryColor),
  //                 ),
  //               ],
  //             ));
  //       }).toList();
  //     },
  //   );
  // }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      print(userChat.id);
      print(UserDataFromStorage.supportAdminId);

      // if (userChat.id != UserDataFromStorage.supportAdminId.toString()) {
      if (userChat.accountType=='admin') {
        return SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                          userChat.photoUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress.expectedTotalBytes != null &&
                                          loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: ColorConstants.greyColor,
                            );
                          },
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: ColorConstants.greyColor,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'userName: ${userChat.userName}',
                            maxLines: 1,
                            style: TextStyle(color: ColorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                        ),
                        Container(
                          child: Text(
                            'phone : ${userChat.userPhone}',
                            maxLines: 1,
                            style: TextStyle(color: ColorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20),
                  ),
                ),
              ],
            ),
            onPressed: () async{
             await chatProvider.checkSupportChatOpening(userId: userChat.id.toString());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminChatScreen(),
                ),
              );
             chatProvider.resetAdminChatScreenData();

             await chatProvider.setNewAdminChat(
               newCommonPerId: '100',
               newCurrentId: UserDataFromStorage.supportAdminId.toString(),
               newPeerAvatar:userChat.photoUrl ,
               newPeerEmail:userChat.userEmail ,
               newPeerId: userChat.id,
               newPeerUserName:userChat.userName ,
             );
             chatProvider.getChatStream(groupChatId: chatProvider.adminGroupChatId,limit:  _limit,);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        );
      }
    }
    else {
      return SizedBox.shrink();
    }
  }
}
