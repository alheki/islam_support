import 'package:flutter/material.dart';

bool validateEmailRegExp({ required String value, required BuildContext context}) {
  // This is just a regular expression for email addresses
  var p = "[a-zA-Z0-9+._%-+]{1,256}" """
\\@""" """
[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}""" "(" "\\." "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" ")+";
  RegExp regExp = RegExp(p);
  if (regExp.hasMatch(value)) {
    // ignore: avoid_print
    print('emile is valid');
    // So, the email is valid
    return true;
  }
  else{
    // ignore: avoid_print
    print('Email is not valid');
    return false;
  }

}



String? validateEmail({ required String value, required BuildContext context}) {
  if(value.toString().isEmpty){
    return "Email address is required";
  }
  else if(!validateEmailRegExp(context: context,value:value.toString(),)){
    return 'Email address not valid';
  }
  return null;
}

String? validatePassword({ required String value, required BuildContext context}) {
  if(value.toString().isEmpty){
    return "Password is required";
  }
  else if(value.toString().length<6){
    return 'Short password';
  }
  return null;
}



