// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/models/message_chat.dart';



class ChatProvider extends ChangeNotifier{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider({required this.firebaseFirestore, required this.firebaseStorage});
  bool chatIsActive=false;


  List<QueryDocumentSnapshot> adminChatListMessage = [];

  int allUsersInAppOld=0;
  int supportTeamCountOld=0;
  int chatActiveCountOld=0;
  int userBlockedCountOld=0;
  int clientsCountOld=0;


  String adminGroupChatId='';
  String peerId='';
  String commonPerId='';
  String currentId='';
  String peerAvatar='';
  String peerUserName='';
  String peerEmail='';



  resetAdminChatScreenData() {
    adminChatListMessage.clear();
    notifyListeners();
    adminGroupChatId='';
    peerId='';
    commonPerId='';
    currentId='';
    peerAvatar='';
    peerUserName='';
    peerEmail='';
    notifyListeners();
  }




  setNewAdminChat({
    required String newPeerId,
    required String newCommonPerId,
    required String newCurrentId,
    required String newPeerAvatar,
    required String newPeerUserName,
    required String newPeerEmail,
  }) {

     peerId=newPeerId;
     commonPerId=newCommonPerId;
     currentId=newCurrentId;
     peerAvatar=newPeerAvatar;
     peerUserName=newPeerUserName;
     peerEmail=newPeerEmail;
     notifyListeners();

    if (commonPerId.compareTo(currentId) > 0) {
      adminGroupChatId = '$commonPerId-$peerId';
      print('issssss 1 = $commonPerId-$peerId');
    }
    else {
      adminGroupChatId = '$peerId-$commonPerId';
      print('issssss 2 =$peerId-$commonPerId');
    }
    updateDataFirestore(collectionPath:FirestoreConstants.pathUserCollection , docPath:currentId, dataNeedUpdate:{FirestoreConstants.chattingWith: peerId} ,);
    notifyListeners();
  }


  Future<void> getClientsCount() async {
    var count =await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.accountType, isEqualTo: 'client').get();
    clientsCountOld=count.docs.length;
    notifyListeners();
    print('clientsCount =${count.docs.length}');
  }

  Future<void> getAllUsersCount() async {
    var count =await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).get();
    allUsersInAppOld=count.docs.length;
    notifyListeners();
    print('allUsersInApp =${count.docs.length}');
  }


  Future<bool> checkSupportChatOpening({required String userId,}) async {
    final QuerySnapshot result = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.userId, isEqualTo: userId).get();
    final List<DocumentSnapshot> documents = result.docs;

    if(documents.isNotEmpty){
      print(documents.last.get(FirestoreConstants.chatStatue));
      if (documents.last.get(FirestoreConstants.chatStatue) != 'active') {
        chatIsActive = false;
        notifyListeners();
        return false;
      }
      else {
        chatIsActive = true;
        notifyListeners();
        return true;
      }
    }
    chatIsActive = false;
    notifyListeners();
    print('chat selected $chatIsActive');
    return false;


  }

  Future<void> closeChatHandle({required String currentId,}) async {
    chatIsActive=false;
    notifyListeners();
    await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(currentId).update({FirestoreConstants.chatStatue: 'disActive'});
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore({required String collectionPath,required String docPath,required Map<String, dynamic> dataNeedUpdate}) {
    return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  }

  Future<void> updateMessageDataFirestore({required String groupChatId,required String docPath,required Map<String, dynamic> dataNeedUpdate}) {
    DocumentReference documentReference = firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).doc(groupChatId).collection(groupChatId).doc(docPath);
    return documentReference.update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream({required String groupChatId,required int limit}) {
    return firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).doc(groupChatId).collection(groupChatId).orderBy(FirestoreConstants.timestamp, descending: true).limit(limit).snapshots();
  }

  void sendMessage({required String content,required int msgType,required String groupChatId,required String currentUserId,required String peerId}) {
    DocumentReference documentReference = firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).doc(groupChatId).collection(groupChatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
    notifyListeners();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        MessageChat(
          idFrom: currentUserId,
          idTo: peerId,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          msgType: msgType,
        ).toJson(),
      );
    });
    notifyListeners();

  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
