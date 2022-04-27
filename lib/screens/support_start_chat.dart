import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/app_constants.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/screens/chat_screens/admin_chat_screen.dart';
import 'package:tshtri_support/screens/chat_screens/client_chat_screen.dart';
import 'package:tshtri_support/providers/client_chat_provider.dart';
import 'package:provider/provider.dart';

class StartSupportChatScreen extends StatefulWidget {
  const StartSupportChatScreen({Key? key}) : super(key: key);

  @override
  _StartSupportChatScreenState createState() => _StartSupportChatScreenState();
}

class _StartSupportChatScreenState extends State<StartSupportChatScreen> {
  final TextEditingController clientAskController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ClientChatProvider clientLoginStatus = Provider.of<ClientChatProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppConstants.loginTitle,
            style: TextStyle(color: ColorConstants.primaryColor),
          ),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // clientAskController address
                TextField(
                  textAlign: TextAlign.center,
                  controller: clientAskController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    enabled: true,
                    hintText:"enter your ask",
                    disabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1,
                      ),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                /// start chat button
                Center(
                  child: TextButton(
                      onPressed: () async {
                        /// sara
                        // bool isSuccess = await clientLoginStatus.startChatHandle(
                        //   userPhone:'01228289975' ,
                        //   userEmail: 'islam1@as.com',
                        //   userCountryId: '1',
                        //   photoUrl: 'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg',
                        //   userName: 'sara',
                        //   userType:'1' ,
                        //   userId: '1',
                        //   userProveIdNumber:'00000000',
                        // );
                        // if (isSuccess||!isSuccess) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ChatPage(
                        //         peerUserName: 'sara',
                        //         peerId: '100',
                        //         peerAvatar:'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg' ,
                        //         currentId: '1',
                        //       ),
                        //     ),
                        //   );
                        // }



                        ///mona

                        bool isSuccess = await clientLoginStatus.startChatHandle(
                          userPhone:'01228089975' ,
                          userEmail: 'islam13@as.com',
                          userCountryId: '1',
                          photoUrl: 'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg',
                          userName: 'rrrrr',
                          userType:'1' ,
                          userId: '16',
                          userProveIdNumber:'00000000',
                          chatStatue: 'active',
                          context: context,
                        );
                        if (isSuccess||!isSuccess) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientChatScreen(
                                peerUserName: 'rrrrr',
                                peerId: 'null',
                                commonPerId: '100',
                                peerAvatar:'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg' ,
                                currentId: '16',
                              ),
                            ),
                          );
                        }


                      },
                    child: Text(
                      'start chat',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return Color(0xffdd4b39).withOpacity(0.8);
                          return Color(0xffdd4b39);
                        },
                      ),
                      splashFactory: NoSplash.splashFactory,
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(30, 15, 30, 15),
                      ),
                    ),
                  ),
                ),


              ],
            ),
            // Loading
            Positioned(
              child:SizedBox.shrink(),
            ),
          ],
        ));
  }
}
