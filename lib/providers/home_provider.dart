// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';

class HomeProvider extends ChangeNotifier{
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({required this.firebaseFirestore});

  bool adminStatusActive=true;

  Future<void> updateDataFirestore(String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataNeedUpdate);
  }

  Future<void> checkAdminAccountStatus() async {
    final QuerySnapshot result = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.userId, isEqualTo: UserDataFromStorage.supportAdminId).get();
    final List<DocumentSnapshot> documents = result.docs;

    if(documents.isNotEmpty){
      print(documents.last.get(FirestoreConstants.chatStatue));
      if (documents.last.get(FirestoreConstants.chatStatue) == 'active') {
        adminStatusActive = true;
        notifyListeners();
      }
      else {
        adminStatusActive = false;
        notifyListeners();
      }
    }
    notifyListeners();
    print('ny account status is = $adminStatusActive');


  }


  Future<void> updateAdminStatus({required bool newStatus})async {
    adminStatusActive=newStatus;
    notifyListeners();
    await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(UserDataFromStorage.supportAdminId).update({FirestoreConstants.chatStatue:adminStatusActive? 'active':'disActive'});
    notifyListeners();
   }


  Stream<QuerySnapshot> getAllAccountsStreamFireStore(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, isEqualTo:  textSearch).snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).snapshots();
    }
  }

  Stream<QuerySnapshot> getSupportTeamStreamFireStore(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return FirebaseFirestore.instance.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, arrayContains: textSearch.toString()).where(FirestoreConstants.accountType,isEqualTo: "admin").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "admin").snapshots();
    }
  }

  Stream<QuerySnapshot> getClientsStreamFireStore(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return FirebaseFirestore.instance.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, arrayContains: textSearch.toString()).where(FirestoreConstants.accountType,isEqualTo: "client").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "client").snapshots();
    }
  }

  Stream<QuerySnapshot> getRecentChatListAllowedOnly(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, isEqualTo: textSearch).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.userStatusBlock,isEqualTo: "allowed").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.userStatusBlock,isEqualTo: "allowed").snapshots();
    }
  }


  Stream<QuerySnapshot> getChatListActiveAndAllowedOnly(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, isEqualTo: textSearch).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.chatStatue,isEqualTo: "active").where(FirestoreConstants.userStatusBlock,isEqualTo: "allowed").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.chatStatue,isEqualTo: "active").where(FirestoreConstants.userStatusBlock,isEqualTo: "allowed").snapshots();
    }
  }

  Stream<QuerySnapshot> getChatListClosedOnly(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, isEqualTo: textSearch).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.chatStatue,isEqualTo: "disActive").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.chatStatue,isEqualTo: "disActive").snapshots();
    }
  }

  Stream<QuerySnapshot> getUsersListBlockedOnly(String pathCollection, int limit, String textSearch) {
    print('search $textSearch');
    if (textSearch.isNotEmpty == true) {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.userName, isEqualTo: textSearch).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.userStatusBlock,isEqualTo: "blocked").snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.accountType,isEqualTo: "client").where(FirestoreConstants.userStatusBlock,isEqualTo: "blocked").snapshots();
    }
  }


}
