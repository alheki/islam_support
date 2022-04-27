import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/components/full_photo_page.dart';
import 'package:tshtri_support/providers/chat_provider.dart';

class MyMessageChatItemWidget extends StatelessWidget {
  final bool isLastMessageLeft;
  final bool isLastMessageRight;
  final String image;
  final int msgType;
  final String content;
  final String timestamp;

  const MyMessageChatItemWidget({
    Key? key,
    required this.isLastMessageLeft,
    required this.isLastMessageRight,
    required this.image,
    required this.msgType,
    required this.content,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Visibility(
                visible:isLastMessageLeft ,
                child: Material(
                  child: Image.network(
                    image,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.themeColor,
                          value: loadingProgress.expectedTotalBytes != null &&
                              loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 35,
                        color: ColorConstants.greyColor,
                      );
                    },
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                replacement: Container(width: 35,),
              ),

              Visibility(
                visible:msgType == TypeMessage.text ,
                child: Flexible(
                child: Container(
                    child: Text(
                      content,
                      style: const TextStyle(color: Colors.black),
                    ),
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10,),
                    decoration:BoxDecoration(color: ColorConstants.greyColor2, borderRadius: BorderRadius.circular(8,),),
                    margin: EdgeInsets.only(left: 10,right: SizeConfig.width*0.2),
                  ),
                ),
                replacement:Visibility(
                  visible: msgType == TypeMessage.image,
                  child: Container(
                    child: TextButton(
                      child: Material(
                        child: Image.network(
                          content,
                          loadingBuilder:
                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: const BoxDecoration(
                                color: ColorConstants.greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              width: 200,
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress.expectedTotalBytes != null &&
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) => Material(
                            child: Image.asset(
                              'assets/sticker_images/img_not_available.jpeg',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullPhotoPage(url: content),
                          ),
                        );
                      },
                      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0))),
                    ),
                    margin: const EdgeInsets.only(left: 10),
                  ),
                  replacement:Container(
                    child: Image.asset(
                      'assets/sticker_images/$content.gif',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(bottom: isLastMessageRight ? 20 : 10, right: 10),
                  ),
                ),
              ),

            ],
          ),
          // Time
          Visibility(
            visible:isLastMessageLeft ,
            child: Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))),
                style: const TextStyle(color: ColorConstants.greyColor, fontSize: 12, fontStyle: FontStyle.italic),
              ),
              margin: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
            ),
            replacement: const SizedBox.shrink(),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 10),
    );
  }
}


class OtherMessageChatItemWidget extends StatelessWidget {
  final bool isLastMessageLeft;
  final bool isLastMessageRight;
  final int msgType;
  final String content;

  const OtherMessageChatItemWidget({
    Key? key,
    required this.isLastMessageLeft,
    required this.isLastMessageRight,
    required this.msgType,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Visibility(
          visible:msgType == TypeMessage.text ,
          child: Flexible(
            child: Container(
              child: Text(
                content,
                style: const TextStyle(color: ColorConstants.greyColor2),
              ),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10,),
              decoration: BoxDecoration(color: ColorConstants.primaryColor, borderRadius: BorderRadius.circular(8),),
              margin: EdgeInsets.only(bottom: isLastMessageRight? 20 : 10, right: 10,left:SizeConfig.width*0.2 ),
            ),
          ),
          replacement: Visibility(
            visible: msgType == TypeMessage.image,
            child:Container(
              child: OutlinedButton(
                child: Material(
                  child: Image.network(
                    content,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: const BoxDecoration(
                          color: ColorConstants.greyColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.themeColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Material(
                        child: Image.asset(
                          'assets/sticker_images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8),),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullPhotoPage(
                        url: content,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0),),),
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight? 20 : 10, right: 10),
            ),
            replacement:Container(
              child: Image.asset(
                'assets/sticker_images/$content.gif',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight? 20 : 10, right: 10,),
            ),
          ),
        ),
      ],
    );
  }
}
