// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';

class UserChat {
  String id;
  String photoUrl;
  String userName;
  String userEmail;
  String userPhone;
  String accountType;
  String userType;
  String userCountryId;
  String typing;
  String timestamp;
  String chatStatue;
  String createdAt;
  String allowed;

  UserChat({
    required this.id,
    required this.photoUrl,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userType,
    required this.userCountryId,
    required this.typing,
    required this.accountType,
    required this.timestamp,
    required this.chatStatue,
    required this.createdAt,
    required this.allowed,
  });

  Map<String, String> toJson() {
    return {
      FirestoreConstants.userName: userName,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.userEmail: userEmail,
      FirestoreConstants.userPhone: userPhone,
      FirestoreConstants.userType: userType,
      FirestoreConstants.userCountryId: userCountryId,
      FirestoreConstants.typing: typing,
      FirestoreConstants.accountType: accountType,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.chatStatue: chatStatue,
      FirestoreConstants.createdAt: createdAt,
      FirestoreConstants.userStatusBlock: allowed,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String userName = "";
    String photoUrl = "";
    String userEmail = "";
    String userPhone = "";
    String userType = "";
    String userCountryId = "";
    String typing = "";
    String accountType = "";
    String timestamp = "";
    String chatStatue = "";
    String createdAt = "";
    String allowed = "";



    try {
      allowed = doc.get(FirestoreConstants.userStatusBlock);
    } catch (e) {}

    try {
      timestamp = doc.get(FirestoreConstants.timestamp);
    } catch (e) {}

    try {
      createdAt = doc.get(FirestoreConstants.createdAt);
    } catch (e) {}

    try {
      chatStatue = doc.get(FirestoreConstants.chatStatue);
    } catch (e) {}
    try {
      accountType = doc.get(FirestoreConstants.accountType);
    } catch (e) {}

    try {
      userName = doc.get(FirestoreConstants.userName);
    } catch (e) {}



    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}


    try {
      userEmail = doc.get(FirestoreConstants.userEmail);
    } catch (e) {}
    try {
      userPhone = doc.get(FirestoreConstants.userPhone);
    } catch (e) {}
    try {
      userType = doc.get(FirestoreConstants.userType);
    } catch (e) {}
    try {
      userCountryId = doc.get(FirestoreConstants.userCountryId);
    } catch (e) {}
    try {
      typing = doc.get(FirestoreConstants.typing);
    } catch (e) {}

    return UserChat(
      id: doc.id,
      userType: userType,
      userName: userName,
      photoUrl: photoUrl,
      typing:typing,
      userCountryId:userCountryId ,
      userEmail: userEmail,
      userPhone: userPhone,
      accountType: accountType,
      timestamp: timestamp,
      chatStatue: chatStatue,
      createdAt: createdAt,
      allowed: allowed,
    );
  }
}
