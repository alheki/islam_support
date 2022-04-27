// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/models/user_chat.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AdminStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AdminLoginProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AdminStatus _status = AdminStatus.uninitialized;
  AdminStatus get status => _status;

  AdminLoginProvider({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });


  final signInValidateKey = GlobalKey<FormState>();
  final signUpValidateKey = GlobalKey<FormState>();


  ///get emails from api
  List listAdminsFromApi = [
    {
      'adminSupportName': "islam",
      'adminSupportEmail': "asd@asd.asd",
      'adminSupportPhone':"+201155687867",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':1,
    },
    {
      'adminSupportName': "ahmed",
      'adminSupportEmail': "asd2@asd.asd",
      'adminSupportPhone':"01228289975",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':2,
    },
    {
      'adminSupportName': "mohamed",
      'adminSupportEmail': "asd3@asd.asd",
      'adminSupportPhone':"01228289975",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':2,
    },
    {
      'adminSupportName': "Same Mood",
      'adminSupportEmail': "asd4@asd.asd",
      'adminSupportPhone':"01228289975",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':2,
    },
    {
      'adminSupportName': "mark",
      'adminSupportEmail': "asd5@asd.asd",
      'adminSupportPhone':"01228289975",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':2,
    },
    {
      'adminSupportName': "tony",
      'adminSupportEmail': "asd6@asd.asd",
      'adminSupportPhone':"01228289975",
      'adminSupportImage':"https://web.tshtri.com/Images/Posts/avatar_admin.jpg",
      'adminSupportCountryId':2,
    },
  ];


  ///  this function will do validate required data and sign in
  Future<bool> validationSignInFunction({required TextEditingController email,required TextEditingController password})async{
    if( signInValidateKey.currentState!.validate()){
     bool signIn= await handleSignIn(email:email.text ,password:password.text);
     return signIn?true:false;
    }
    return false;
  }

  ///  this function will do validate required data and sign up
  Future<bool> validationSignUpFunction({required TextEditingController email,required TextEditingController password})async{
    if( signUpValidateKey.currentState!.validate()){
      bool signUp= await handleSignUp(email:email.text ,password:password.text);
      return signUp?true:false;
    }
    return false;
  }


  Future<bool> handleSignIn({required String email,required String password,}) async {
    _status = AdminStatus.authenticating;
    notifyListeners();

    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final QuerySnapshot result = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.userId, isEqualTo: firebaseAuth.currentUser!.uid).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Writing data to server because here is a new user
        firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseAuth.currentUser!.uid).set({
          FirestoreConstants.accountType: 'admin',
          FirestoreConstants.userId: firebaseAuth.currentUser!.uid,
          FirestoreConstants.userName: firebaseAuth.currentUser!.displayName!,
          FirestoreConstants.photoUrl: firebaseAuth.currentUser!.photoURL!,
          FirestoreConstants.userEmail: firebaseAuth.currentUser!.email!,
          FirestoreConstants.userPhone: listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportPhone'],
          FirestoreConstants.userCountryId: 2,
          FirestoreConstants.chatStatue: 'active',
          FirestoreConstants.userStatusBlock: 'allowed',
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });
      }
      else {
        DocumentSnapshot documentSnapshot = documents[0];
        UserChat userChat = UserChat.fromDocument(documentSnapshot);
        print(userChat);
      }

      UserDataFromStorage.setSupportAdminIsLogin(true);
      UserDataFromStorage.setSupportAdminId(firebaseAuth.currentUser!.uid);
      UserDataFromStorage.setSupportAdminEmail(firebaseAuth.currentUser!.email!);
      UserDataFromStorage.setSupportAdminPhone(listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportPhone']);
      UserDataFromStorage.setSupportAdminName(firebaseAuth.currentUser!.displayName!);
      UserDataFromStorage.setSupportAdminImage(firebaseAuth.currentUser!.photoURL!);
      _status = AdminStatus.authenticated;

      return true;
    } on FirebaseAuthException catch(e) {
      UserDataFromStorage.setSupportAdminIsLogin(false);
      UserDataFromStorage.setSupportAdminId('');
      UserDataFromStorage.setSupportAdminEmail('');
      UserDataFromStorage.setSupportAdminPhone('');
      UserDataFromStorage.setSupportAdminName('');
      UserDataFromStorage.setSupportAdminImage('');
      _status = AdminStatus.uninitialized;
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: ColorConstants.greyColor);

      notifyListeners();

      print(e.message);
      return false;
    }

  }

  Future<bool> handleSignUp({required String email,required String password,}) async {
    _status = AdminStatus.authenticating;
    notifyListeners();


    ///account have permission to create account
    if(listAdminsFromApi.any((element) => element['adminSupportEmail']==email)){

      try {
        await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        await firebaseAuth.currentUser!.updateProfile(
          displayName: listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportName'],
          photoURL: listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportImage'],
        );

        firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseAuth.currentUser!.uid).set({
          FirestoreConstants.accountType: 'admin',
          FirestoreConstants.userId: firebaseAuth.currentUser!.uid,
          FirestoreConstants.userName: firebaseAuth.currentUser!.displayName!,
          FirestoreConstants.photoUrl: firebaseAuth.currentUser!.photoURL!,
          FirestoreConstants.userEmail: firebaseAuth.currentUser!.email!,
          FirestoreConstants.userPhone: listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportPhone'],
          FirestoreConstants.userCountryId: 2,
          FirestoreConstants.chatStatue: 'active',
          FirestoreConstants.userStatusBlock: 'allowed',
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });
        UserDataFromStorage.setSupportAdminIsLogin(true);
        UserDataFromStorage.setSupportAdminId(firebaseAuth.currentUser!.uid);
        UserDataFromStorage.setSupportAdminEmail(firebaseAuth.currentUser!.email!);
        UserDataFromStorage.setSupportAdminPhone(listAdminsFromApi.firstWhere((element) => element['adminSupportEmail']==email)['adminSupportPhone']);
        UserDataFromStorage.setSupportAdminName(firebaseAuth.currentUser!.displayName!);
        UserDataFromStorage.setSupportAdminImage(firebaseAuth.currentUser!.photoURL!);

        _status = AdminStatus.authenticated;
        notifyListeners();
        return true;
      } on FirebaseAuthException catch(e) {
        UserDataFromStorage.setSupportAdminIsLogin(false);
        UserDataFromStorage.setSupportAdminId('');
        UserDataFromStorage.setSupportAdminEmail('');
        UserDataFromStorage.setSupportAdminPhone('');
        UserDataFromStorage.setSupportAdminName('');
        UserDataFromStorage.setSupportAdminImage('');
        Fluttertoast.showToast(msg: e.code.toString(), backgroundColor: ColorConstants.greyColor,timeInSecForIosWeb: 5,webPosition:'center');
        _status = AdminStatus.uninitialized;
        notifyListeners();
        print(e.message);
        return false;
      }

    }

    /// account NOT HAVE permission to create account
    else{
      _status = AdminStatus.uninitialized;
      notifyListeners();

      print('account NOT HAVE permission to create account');
      Fluttertoast.showToast(msg: 'account NOT HAVE permission to create account', backgroundColor: ColorConstants.greyColor);
      return false;

    }

  }

  Future<void> handleSignOut() async {
    _status = AdminStatus.uninitialized;
    await firebaseAuth.signOut();
    UserDataFromStorage.setSupportAdminIsLogin(false);
    UserDataFromStorage.setSupportAdminId('');
    UserDataFromStorage.setSupportAdminEmail('');
    UserDataFromStorage.setSupportAdminPhone('');
    UserDataFromStorage.setSupportAdminName('');
    UserDataFromStorage.setSupportAdminImage('');
    notifyListeners();
    await firebaseAuth.signOut();
  }



}
