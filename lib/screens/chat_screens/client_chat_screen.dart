// ignore_for_file: no_logic_in_create_state

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/components/chat_header.dart';
import 'package:tshtri_support/screens/chat_screens/widgets/chat_mesaage_item_widget.dart';
import 'package:tshtri_support/components/custom_fields_widget.dart';
import 'package:tshtri_support/components/loading_view.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/models/message_chat.dart';
import 'package:tshtri_support/components/full_photo_page.dart';
import 'package:tshtri_support/providers/providers.dart';
import 'package:tshtri_support/screens/support_start_chat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientChatScreen extends StatefulWidget {
  final String commonPerId;
  final String peerId;
  final String peerAvatar;
  final String peerUserName;
  final String currentId;

  const ClientChatScreen({Key? key,required this.currentId,required this.peerId,required this.commonPerId, required this.peerAvatar, required this.peerUserName}) : super(key: key);

  @override
  State createState() => ClientChatScreenState(
    peerId: peerId,
    peerAvatar: peerAvatar,
    peerUserName: peerUserName,
    commonPerId: commonPerId,
    currentId: currentId,

  );
}

class ClientChatScreenState extends State<ClientChatScreen> {
  ClientChatScreenState({
    Key? key,
    required this.commonPerId,
    required this.currentId,
    required this.peerId,
    required this.peerAvatar,
    required this.peerUserName,
  });

  String peerId;
  String peerAvatar;
  String peerUserName;
  String commonPerId;
  String currentId;


  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  TextEditingController searchBarTec = TextEditingController();
  List<QueryDocumentSnapshot> clientChatListMessage = [];

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = "";

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  void readLocal() {
    if (commonPerId.compareTo(currentId) > 0) {
      groupChatId = '$commonPerId-$currentId';
      print('issssss 1 = $commonPerId-$currentId');
    }
    else {
      groupChatId = '$currentId-$commonPerId';
      print('issssss 2 =$currentId-$commonPerId');
    }
  }

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange && _limit <=clientChatListMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Future getImage(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery,);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile(context);
      }
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile(BuildContext context) async {
    ChatProvider chatController = Provider.of<ChatProvider>(context,listen: false);

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatController.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(context,imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(BuildContext context,String content, int type,) {
    ChatProvider chatController = Provider.of<ChatProvider>(context,listen: false);
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatController.sendMessage(content: content,msgType: type,groupChatId: groupChatId,currentUserId: currentId,peerId:peerId);
      listScrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {

    }
  }


  bool isLastMessageLeft(BuildContext context,int index) {

    if ((index > 0 && clientChatListMessage[index - 1].get(FirestoreConstants.idFrom) == currentId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(BuildContext context,int index) {
    if ((index > 0 && clientChatListMessage[index - 1].get(FirestoreConstants.idFrom) != currentId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      context.read<ChatProvider>().updateDataFirestore(
        collectionPath:FirestoreConstants.pathUserCollection ,
        docPath:currentId,
        dataNeedUpdate:{FirestoreConstants.chattingWith: peerId} ,
      );
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatController = Provider.of<ChatProvider>(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding,top: defaultPadding,bottom: defaultPadding/8),
                    child: ChatHeader(
                      isAdminChat: false,
                      showBackButton:!SizeConfig.isDesktop(context)?true:false,
                      accountType: '',
                      email: '',
                      image: '',
                      name: '',
                      showCloseChatButton: chatController.chatIsActive,
                      closeOnTap: ()async{
                        if(chatController.chatIsActive){
                          await chatController.closeChatHandle(currentId:currentId);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        if (focusNode.hasFocus) {
                          // Hide sticker when keyboard appear
                          setState(() {
                            isShowSticker = false;
                          });
                          focusNode.unfocus();

                        }
                      },
                      child: Column(
                        children: [
                          // List of messages
                          buildClientChatListMessage(context),
                          // Sticker
                          isShowSticker ? buildSticker(context) : const SizedBox.shrink(),

                          // Input content
                          Visibility(
                            visible: chatController.chatIsActive,
                            child:CustomChatTextField(
                              controller: textEditingController,
                              enabled:chatController.chatIsActive ,
                              focusNode: focusNode,
                              onChanged:(val){} ,
                              onSubmit:(val){
                                onSendMessage(context,textEditingController.text, TypeMessage.text);
                              },
                              sendImageButton:(){
                                getImage(context);
                              },
                              sendMsgOnTap:() => onSendMessage(context,textEditingController.text, TypeMessage.text),
                              sendStickerOnTap: getSticker,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }

  /// chat list
  Widget buildClientChatListMessage(BuildContext context) {
    ChatProvider chatController = Provider.of<ChatProvider>(context);

    if(groupChatId.isNotEmpty){
      return Flexible(
        child:StreamBuilder<QuerySnapshot>(
          stream: chatController.getChatStream(groupChatId: groupChatId,limit:  _limit,),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              clientChatListMessage = snapshot.data!.docs;
              if (clientChatListMessage.isNotEmpty) {
                return ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  reverse: true,
                  controller: listScrollController,
                  padding: EdgeInsets.only(top: SizeConfig.height*0.02,left:SizeConfig.height*0.01,right: SizeConfig.height*0.01,bottom: SizeConfig.height*0.01 ),
                  children: [
                    Visibility(
                      visible: isLoading,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10,),
                            child: TextButton(
                              child: Material(
                                child:Container(
                                  decoration: const BoxDecoration(
                                    color: ColorConstants.greyColor2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.themeColor,
                                    ),
                                  ),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullPhotoPage(url: imageUrl),
                                  ),
                                );
                              },
                              style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0))),
                            ),
                            margin: const EdgeInsets.only(left: 10),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(defaultPadding),

                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildClientChatListItems(context,index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                    ),

                  ],
                );
              } else {
                return const Center(child: Text("No message here yet..."));
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
    return const Center(
      child: CircularProgressIndicator(
        color: ColorConstants.themeColor,
      ),
    );

  }

  ///
  Widget buildClientChatListItems(BuildContext context,int index, DocumentSnapshot? document) {
    ChatProvider chatController = Provider.of<ChatProvider>(context,);

    if (document != null&&groupChatId.isNotEmpty) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idTo == peerId) {
        // Right (my message)
        return  OtherMessageChatItemWidget(
          isLastMessageLeft:isLastMessageLeft(context,index) ,
          isLastMessageRight: isLastMessageRight(context,index),
          content: messageChat.content,
          msgType: messageChat.msgType,
        );
      }
      else {
        // Left (peer message)
        return  MyMessageChatItemWidget(
          isLastMessageLeft: isLastMessageRight(context,index),
          isLastMessageRight:isLastMessageLeft(context,index) ,
          content:messageChat.content ,
          image:chatController.peerAvatar ,
          msgType:messageChat.msgType ,
          timestamp:messageChat.timestamp ,
        );

      }
    }
    else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSticker(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi1', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi2', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi3', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi4', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi5', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi6', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi7', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi8', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(context,'mimi9', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/sticker_images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor, width: 0.1,
            ), color: bgColor),
        padding: const EdgeInsets.all(5),
        height: 180,
      ),
    );
  }


}
