import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



//  push to new screen under bottom bar
Future<void> customPushNavigator(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  if(Platform.isAndroid){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  if(Platform.isIOS){
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    );
  }
}


//  push to new screen and hide bottom bar
Future<void> customPushFullScreenNotBackNavigator(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  if(Platform.isAndroid){
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),
    );
  }
  if(Platform.isIOS){
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<bool>(
        maintainState: false,
        fullscreenDialog: true,
        builder: (BuildContext context) => page,
      ),
    );
  }
}


//  push to new screen and hide bottom bar
Future<void> customPushFullScreenNavigator(context ,Widget page) async {
  if (kIsWeb) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  if(Platform.isAndroid){
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),
    );
  }
  if(Platform.isIOS){
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<bool>(
        maintainState: false,
        fullscreenDialog: true,
        builder: (BuildContext context) => page,
      ),
    );
  }
}


//  push to new screen and remove all screens route before
Future<void>  customPushAndRemoveUntil(context ,Widget page)async {

  if (kIsWeb) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  if(Platform.isAndroid){
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),(Route<dynamic> route) => false,
    );
  }

  if(Platform.isIOS){
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),(Route<dynamic> route) => false,
    );
  }



}


// replace current screen by new screen under bottom bar
Future<void>  customPushReplacement(context ,Widget page,)async {

  if (kIsWeb) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  if(Platform.isAndroid){
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page),
    );

  }

  if(Platform.isIOS){
    Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (BuildContext context) => page),
    );

  }

}


// replace current screen by new screen and hide bottom bar
Future<void>  customPushReplacementFullScreen(context ,Widget page)async {
  if (kIsWeb) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeTransition(
              opacity: animation,
              child:page,
            ),
      ),
    );
  }
  if(Platform.isAndroid){
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),
    );
  }
  if(Platform.isIOS){
    Navigator.of(context, rootNavigator: true).pushReplacement(
      CupertinoPageRoute<bool>(
        maintainState: false,
        builder: (BuildContext context) => page,
      ),
    );
  }
}
