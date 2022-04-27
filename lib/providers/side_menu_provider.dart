import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SideMenuProvider extends ChangeNotifier {

  SideMenuProvider({
    required this.firebaseFirestore,
  });

  final FirebaseFirestore firebaseFirestore;
  int selectedTapIndex=0; // 0=> dashboard  1=> All Chats  2=> Active Chat  3=> Finished Chats  4=> Support Team  5=> blocked Users

  setTabIndex({required int index}){
    selectedTapIndex=index;
    notifyListeners();
  }

}


