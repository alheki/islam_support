
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/providers/providers.dart';
import 'package:provider/provider.dart';


class ClientChatProvider extends ChangeNotifier {

  ClientChatProvider({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;

  Future<bool> startChatHandle({
    required String userId,
    required String userName,
    required String photoUrl,
    required String userEmail,
    required String userPhone,
    required String userCountryId,
    required String userProveIdNumber,
    required String userType,
    required String chatStatue,
    required BuildContext context,

  }) async {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context,listen: false);

    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(userId).set({
      FirestoreConstants.accountType: 'client',
      FirestoreConstants.userId: userId,
      FirestoreConstants.userName: userName,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.userEmail: userEmail,
      FirestoreConstants.userPhone: userPhone,
      FirestoreConstants.userCountryId: userCountryId,
      FirestoreConstants.userProveIdNumber: userProveIdNumber,
      FirestoreConstants.userType: userType,
      FirestoreConstants.chatStatue: chatStatue,
      FirestoreConstants.userStatusBlock: 'allowed',
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      FirestoreConstants.chattingWith: null
    });
    chatProvider.chatIsActive=true;
    return true;
  }


}
