import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tshtri_support/components/custom_fields_widget.dart';
import 'package:tshtri_support/components/loading_widget.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/navigation_functions.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/helper/validatetors.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:tshtri_support/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key,}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    AdminLoginProvider adminLoginProvider = Provider.of<AdminLoginProvider>(context);
    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall:adminLoginProvider.status==AdminStatus.authenticating,
          // progressIndicator:const Center(child: LoadingAnimationWidget()) ,
          progressIndicator:Container() ,
          color: Colors.transparent,

          child: SafeArea(
            child: Form(
              key: adminLoginProvider.signUpValidateKey,
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
                                'Join our team',
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
                              isPassword: false,
                              hintText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
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
                                    child: const Center(child: LoadingAnimationWidget(),),
                                    replacement:Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          /// final sign up
                                          bool isSuccess = await adminLoginProvider.validationSignUpFunction(
                                            email: adminEmailController,
                                            password: adminPasswordController,
                                          );

                                          if(isSuccess){
                                            customPushAndRemoveUntil(context, const HomeScreen());
                                          }

                                        },
                                        child: const Text(
                                          'Resister',
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
