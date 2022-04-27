import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/providers/side_menu_provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SideMenuProvider sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Drawer(
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          DrawerHeader(
            child: GestureDetector(
              onTap: (){
                sideMenuProvider.setTabIndex(index: 0);
              },
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              sideMenuProvider.setTabIndex(index: 0);
            },
          ),
          DrawerListTile(
            title: "All Chat",
            svgSrc: "assets/icons/all_chats.svg",
            press: (){
              sideMenuProvider.setTabIndex(index: 1);
            },

          ),
          DrawerListTile(
            title: "Active Chat",
            svgSrc: "assets/icons/active_chat.svg",
            press: () {
              sideMenuProvider.setTabIndex(index: 2);
            },
          ),
          DrawerListTile(
            title: "Finished Chat",
            svgSrc: "assets/icons/end_chat.svg",
            press: () {
              sideMenuProvider.setTabIndex(index: 3);
            },
          ),
          DrawerListTile(
            title: "Support Team",
            svgSrc: "assets/icons/support_team_icon.svg",
            press: () {
              sideMenuProvider.setTabIndex(index: 4);
            },
          ),
          DrawerListTile(
            title: "Blocked",
            svgSrc: "assets/icons/blocked.svg",
            press: () {
              sideMenuProvider.setTabIndex(index: 5);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SizedBox(
        height: 20,
        width: 20,
        child: SvgPicture.asset(
          svgSrc,
          color: Colors.white54,
          height: 20,
          width: 20,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
