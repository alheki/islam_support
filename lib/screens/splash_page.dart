import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/screens/login_screens/login_screen.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/screens/home_screen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    UserDataFromStorage.getData();
    Future.delayed(const Duration(seconds: 1), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AdminLoginProvider adminLoginProvider = context.read<AdminLoginProvider>();


    if (UserDataFromStorage.supportAdminIsLogin) {
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
          'adminSupportName': "same",
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


      /// check if account still have permission
      if(listAdminsFromApi.any((element) => element['adminSupportEmail']==UserDataFromStorage.supportAdminEmail)){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
      else{
        adminLoginProvider.handleSignOut();
      }
      return;
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/app_icon.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: ColorConstants.themeColor),
            ),
          ],
        ),
      ),
    );
  }
}
