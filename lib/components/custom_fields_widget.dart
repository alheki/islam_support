import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';

class CustomChatTextField extends StatelessWidget {
  final TextEditingController controller ;
  final Function(String val) onChanged;
  final Function(String val) onSubmit;
  final VoidCallback sendMsgOnTap;
  final VoidCallback sendStickerOnTap;
  final VoidCallback sendImageButton;
  final bool enabled;
  final FocusNode focusNode ;

  const CustomChatTextField({Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.sendMsgOnTap,
    required this.sendImageButton,
    required this.sendStickerOnTap,
    required this.enabled,
    required this.focusNode,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.height*0.01),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: secondaryColor, width: 0.5),),
        color: bgColor,
      ),
      child: Row(
        children: <Widget>[
          // Button send image
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              padding:const EdgeInsets.only(left: defaultPadding / 1,),
              icon: const Icon(Icons.image,color: Colors.white,),
              onPressed: sendImageButton,
              color: ColorConstants.primaryColor,
            ),
          ),

          IconButton(
            padding:const EdgeInsets.only(right: defaultPadding / 5,),
            icon: const Icon(Icons.face,color: Colors.white,),
            onPressed: sendStickerOnTap,
            color: ColorConstants.primaryColor,
          ),

          // Edit text
          Flexible(
            child:Container(
              margin:const EdgeInsets.only(bottom: defaultPadding ,top: defaultPadding * 0.5),
              height: SizeConfig.height*0.055,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: onSubmit,
                enabled: enabled,
                keyboardType:TextInputType.text,
                minLines: 1,
                maxLines: 4,
                textInputAction:TextInputAction.send,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10,top: 10),
                  hintText: "Type your message...",
                  hintStyle: TextStyle(
                    fontSize: 12
                  ),
                  fillColor: secondaryColor,
                  filled: true,
                  border:chatTextFieldBorder,
                  disabledBorder: chatTextFieldBorder,
                  enabledBorder: chatTextFieldBorder,
                  errorBorder: chatTextFieldBorder,
                  focusedBorder: chatTextFieldBorder,
                  focusedErrorBorder: chatTextFieldBorder,
                ),
              ),
            ),
          ),

          // Button send message
          InkWell(
            onTap: sendMsgOnTap,
            child: Container(
              padding:const EdgeInsets.all(defaultPadding * 0.5),
              margin:const EdgeInsets.only(right: defaultPadding / 1,left: defaultPadding / 3),
              decoration:const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
              child:const Icon(Icons.send),
            ),
          ),
        ],
      ),

    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController controller ;
  final Function(String val) onChanged;
  final Function(String val) onSubmit;
  final VoidCallback iconOnTap;

  const SearchField({Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.iconOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged:onChanged ,
      onSubmitted: onSubmit,
      enabled: true,
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        enabled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: iconOnTap,
          child: Container(
            padding:const EdgeInsets.all(defaultPadding * 0.75),
            margin:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration:const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}

class LoginTextFieldWidget extends StatelessWidget {
  final TextEditingController controller ;
  final VoidCallback onTap;
  final Function(String val) onChanged;
  final FormFieldValidator validator;
  final String hintText;
  final TextInputType keyboardType;
  final bool allowArabic;
  final bool enabled;
  final bool isPassword;
  final TextInputAction textInputAction ;

  const LoginTextFieldWidget({Key? key,
    required this.onTap,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    required this.keyboardType,
    required this.allowArabic,
    required this.enabled,
    required this.textInputAction,
    required this.validator,
    required this.isPassword,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: SizeConfig.height*0.012),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: TextFormField(
            onTap:onTap,
            onChanged: onChanged,
            autofocus: false,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            controller: controller,
            validator: validator,
            textAlign: TextAlign.center,
            enabled: enabled,
            obscureText:isPassword ,
            inputFormatters: [
              if(!allowArabic)FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9 _ + @ - .]")),
            ],
            decoration: InputDecoration(
              enabled: true,
              hintText:hintText.toString(),
              disabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 1,
                ),
              ),
              enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 1,
                ),
              ),
              focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 1,
                ),
              ),
              focusedErrorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
