import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tshtri_support/components/custom_fields_widget.dart';
import 'package:tshtri_support/components/loading_widget.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/navigation_functions.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/helper/validatetors.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:tshtri_support/providers/providers.dart';
import 'package:tshtri_support/screens/home_screen.dart';
import 'package:tshtri_support/screens/login_screens/sign_up_screen.dart';
import 'package:tshtri_support/screens/support_start_chat.dart';
import 'package:provider/provider.dart';
import '../chat_screens/client_chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key,}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    AdminLoginProvider adminLoginProvider = Provider.of<AdminLoginProvider>(context);
    ClientChatProvider clientChatProvider = Provider.of<ClientChatProvider>(context);
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall:adminLoginProvider.status==AdminStatus.authenticating,
          // progressIndicator:const Center(child: LoadingAnimationWidget()) ,
          progressIndicator:Container() ,
          color: Colors.transparent,
          child: SafeArea(
            child: Form(
              key: adminLoginProvider.signInValidateKey,
              child: Row(
                children: <Widget>[
                  // gif
                  Visibility(
                    visible:SizeConfig.isDesktop(context),
                    child: Expanded(
                      flex: 3,
                      child: SizedBox(
                        width: SizeConfig.height*1.7,
                        height: SizeConfig.height*1.7,
                        child:Lottie.asset(
                          "assets/gif/support_login.json",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:SizeConfig.isDesktop(context),

                    child: Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: SizeConfig.height*1.7,
                        height: SizeConfig.height*1.7,

                      ),
                    ),
                  ),
                  // login
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.height*0.03),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(defaultPadding),
                        primary: false,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // logo
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Image.asset("assets/images/logo.png"),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                            ),
                            // title
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Text(
                                'Welcome Back !',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline4!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                            ),
                            // email address
                            LoginTextFieldWidget(
                              controller:adminEmailController ,
                              enabled: true,
                              allowArabic:false,
                              hintText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              isPassword: false,
                              onChanged: (val){},
                              onTap: (){},
                              validator: (val){
                                return validateEmail(context: context,value: val);
                              },
                            ),

                            SizedBox(
                              height: SizeConfig.height*0.03,
                            ),
                            // password
                            LoginTextFieldWidget(
                              controller:adminPasswordController ,
                              enabled: true,
                              allowArabic:false,
                              isPassword: true,
                              hintText: 'Password',
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChanged: (val){},
                              onTap: (){},
                              validator: (val){
                                return validatePassword(context: context,value: val);

                              },
                            ),

                            const SizedBox(
                              height: 50,
                            ),
                            /// login button
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: adminLoginProvider.status==AdminStatus.authenticating,
                                    child: const Center(child: LoadingAnimationWidget()),
                                    replacement: Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          /// final login
                                          bool isSuccess = await adminLoginProvider.validationSignInFunction(
                                            email: adminEmailController,
                                            password: adminPasswordController,
                                          );

                                          if(isSuccess){
                                            customPushAndRemoveUntil(context, const HomeScreen());
                                          }
                                          ///,....
                                          // bool isSuccess = await adminLoginProvider.handleSignIn(
                                          //   userPhone:'01155687867' ,
                                          //   userEmail: 'islam1@as.com',
                                          //   userCountryId: '1',
                                          //   photoUrl: 'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg',
                                          //   userName: 'islam',
                                          //   userType:'1' ,
                                          //   userId: '1',
                                          //   userProveIdNumber:'00000000'
                                          // );



                                          // if (isSuccess||!isSuccess) {
                                          //   Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => ChatPage(
                                          //         peerUserName: 'islam',
                                          //         peerId: '100',
                                          //         peerAvatar:'https://web.tshtri.com/Images/Categories/1097_4871-1097.png' ,
                                          //         currentId: '1',
                                          //       ),
                                          //     ),
                                          //   );
                                          // }

                                        },
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                              if (states.contains(MaterialState.pressed)) {
                                                return primaryColor.withOpacity(0.8);
                                              }
                                              return primaryColor;
                                            },
                                          ),
                                          splashFactory: NoSplash.splashFactory,
                                          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(30, 20, 30, 20),),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: SizeConfig.height*0.03,
                            ),


                            /// sign up button
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'You don\'t have an account ? ',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      customPushNavigator(context, const SignUpScreen());
                                    },

                                    child:  const Text(
                                      ' Resister',
                                      style: TextStyle(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 50,
                            ),

                            /// User Test button
                            Center(
                              child: TextButton(
                                onPressed: () async {

                                  bool haveChatBefore = await chatProvider.checkSupportChatOpening(userId: '7');

                                  if(haveChatBefore){
                                    bool isSuccess = await clientChatProvider.startChatHandle(
                                      userPhone:'01228289970' ,
                                      userEmail: 'islam1@as.com',
                                      userCountryId: '1',
                                      photoUrl: 'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg',
                                      userName: 'Mona',
                                      userType:'1' ,
                                      userId: '2',
                                      userProveIdNumber:'00000000',
                                      chatStatue: 'active',
                                      context: context,
                                    );
                                    if (isSuccess||!isSuccess) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ClientChatScreen(
                                            peerUserName: 'Mona',
                                            peerId: 'null',
                                            commonPerId: '100',
                                            peerAvatar:'https://web.tshtri.com/cdn-cgi/image/h=165,fit=cover,gravity=0.5x0.5,format=auto/Images/Posts/image_picker_FC33683A-C361-4AE7-BE08-F656B267CF46-38173-000022FE6BD9AE51222754488.jpg' ,
                                            currentId: '2',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const StartSupportChatScreen(),
                                      ),
                                    );
                                  }

                                },
                                child: const Text(
                                  'User Test',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed)) return const Color(0xffdd4b39).withOpacity(0.8);
                                      return const Color(0xffdd4b39);
                                    },
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.fromLTRB(30, 15, 30, 15),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:SizeConfig.isDesktop(context),
                    child: Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: SizeConfig.height*1.7,
                        height: SizeConfig.height*1.7,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
