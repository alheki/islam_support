import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tshtri_support/constants/app_constants.dart';
import 'package:tshtri_support/providers/client_chat_provider.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tshtri_support/providers/menu_provider.dart';
import 'package:tshtri_support/providers/side_menu_provider.dart';
import 'package:tshtri_support/screens/splash_page.dart';
import 'constants/color_constants.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(SupportApp(prefs: prefs));
}

class SupportApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  SupportApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<ClientChatProvider>(
          create: (_) => ClientChatProvider(
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        ChangeNotifierProvider<MenuController>(
          create: (_) => MenuController(),
        ),
        ChangeNotifierProvider<AdminLoginProvider>(
          create: (_) => AdminLoginProvider(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        ChangeNotifierProvider<SideMenuProvider>(
          create: (_) => SideMenuProvider(
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        Provider<SettingProvider>(
          create: (_) => SettingProvider(
            prefs: prefs,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: firebaseFirestore,
          ),
        ),

        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),

      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        initialRoute: '',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
