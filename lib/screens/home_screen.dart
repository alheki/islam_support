import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/components/header.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/providers/admin_login_provider.dart';
import 'package:tshtri_support/providers/chat_provider.dart';
import 'package:tshtri_support/providers/home_provider.dart';
import 'package:tshtri_support/providers/menu_provider.dart';
import 'package:tshtri_support/providers/side_menu_provider.dart';
import 'package:tshtri_support/screens/all_chats_section/all_chats_section.dart';
import 'package:tshtri_support/screens/side_menu.dart';
import 'package:tshtri_support/screens/support_team_section/support_team_section.dart';
import 'package:tshtri_support/utils/debouncer.dart';
import 'dashboard_screen.dart';
import 'login_screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchBarTec = TextEditingController();
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();

  Future<void> handleSignOut(BuildContext context) async {
    AdminLoginProvider adminLoginProvider = Provider.of<AdminLoginProvider>(context,listen: false);

    await adminLoginProvider.handleSignOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      if(mounted){
        await context.read<HomeProvider>().checkAdminAccountStatus();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (SizeConfig.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),

            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding,top: defaultPadding,bottom: defaultPadding/8),
                    child: Header(
                      showBackButton: false,
                      showSearch:true ,
                      showTitle: true,
                      controller: searchBarTec,
                      adminStatusActive:homeProvider.adminStatusActive ,
                      statusOnChanged: (val){
                        homeProvider.updateAdminStatus(newStatus: val);
                      },
                      onChanged: (value) {
                        setState(() {
                          searchDebouncer.run(() {
                            if (value.isNotEmpty) {
                              btnClearController.add(true);
                            }
                            else {
                              btnClearController.add(false);
                            }
                          });
                        });
                      },
                      onSubmit:(val){},
                      userCardInTap: (){
                        handleSignOut(context);
                      },
                      iconOnTap: (){},
                    ),
                  ),

                  const SizedBox(height: defaultPadding),

                  Expanded(
                    child: buildCurrentScreen(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentScreen(BuildContext context){
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    SideMenuProvider sideMenuProvider = Provider.of<SideMenuProvider>(context);

    switch(sideMenuProvider.selectedTapIndex){
      case 0:// dashboard
        return DashboardScreen(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
        );
      case 1:// all chat
        return AllChatSection(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
          isAllChat: true,
          isActiveChat: false,
          isClosedChat: false,
        );
      case 2://active chat
        return AllChatSection(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
          isAllChat: false,
          isActiveChat: true,
          isClosedChat: false,
        );
      case 3:// closed chat
        return AllChatSection(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
          isAllChat: false,
          isActiveChat: false,
          isClosedChat: true,
        );
      case 4:// support team
        return SupportTeamSection(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
        );
      case 5:// blocked
        return DashboardScreen(
          btnClearController:btnClearController ,
          searchBarTec:searchBarTec ,
          searchDebouncer:searchDebouncer ,
        );

      default :return Container();
    }

  }


}
