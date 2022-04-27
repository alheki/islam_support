// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/providers/chat_provider.dart';
import 'package:tshtri_support/providers/home_provider.dart';
import 'package:tshtri_support/screens/top_cards_counter/widgets/loading_top_counter_info_card.dart';
import 'widgets/top_counter_info_card.dart';

class TopCounterCardsSection extends StatefulWidget {
  const TopCounterCardsSection({
    Key? key,
  }) : super(key: key);

  @override
  State<TopCounterCardsSection> createState() => _TopCounterCardsSectionState();
}

class _TopCounterCardsSectionState extends State<TopCounterCardsSection> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final ScrollController listScrollController = ScrollController();

  late int _limit = 20;
  final int _limitIncrement = 20;
  final String _textSearch = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_)async{
      if(mounted){
        await context.read<ChatProvider>().getAllUsersCount();
        context.read<HomeProvider>().getClientsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _textSearch);
      }
    });

    listScrollController.addListener(scrollListener);
  }


  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "My Files",
        //       style: Theme.of(context).textTheme.subtitle1,
        //     ),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         padding: EdgeInsets.symmetric(
        //           horizontal: defaultPadding * 1.5,
        //           vertical:
        //               defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //         ),
        //       ),
        //       onPressed: () {},
        //       icon: const Icon(Icons.add),
        //       label: const Text("Add New"),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: defaultPadding),

        StreamBuilder<QuerySnapshot>(
          stream: homeProvider.getAllAccountsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _textSearch),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data?.docs.length ?? 0) > 0) {
                return SizeConfig(
                  mobile: FileInfoCardGridView(
                    crossAxisCount: SizeConfig.width < 650 ? 2 : 4,
                    childAspectRatio: SizeConfig.width < 650 && SizeConfig.width > 350 ? 1.3 : 1,
                    document: snapshot.data,
                  ),
                  tablet: FileInfoCardGridView(
                    document:snapshot.data ,
                  ),
                  desktop: FileInfoCardGridView(
                    childAspectRatio: SizeConfig.width < 1400 ? 1.1 : 1.4,
                    document: snapshot.data,
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return SizeConfig(
                mobile: LoadingFileInfoCardGridView(
                  crossAxisCount: SizeConfig.width < 650 ? 2 : 4,
                  childAspectRatio: SizeConfig.width < 650 && SizeConfig.width > 350 ? 1.3 : 1,
                ),
                tablet: const LoadingFileInfoCardGridView(),
                desktop: LoadingFileInfoCardGridView(
                  childAspectRatio: SizeConfig.width < 1400 ? 1.1 : 1.4,
                ),
              );
            }
          },
        ),

      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.document,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final QuerySnapshot? document;

  @override
  Widget build(BuildContext context) {
    // ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    if (document != null) {

      int allUsersInApp=document!.docs.toList().length;
      int supportTeamCount=document!.docs.where((element) => element.get(FirestoreConstants.accountType)=='admin').toList().length;
      int clientsCount=document!.docs.where((element) => element.get(FirestoreConstants.accountType)=='client').toList().length;
      int allClientsChatCount=document!.docs.where((element) => element.get(FirestoreConstants.accountType)=='client').toList().length;
      int clientsChatActiveCount=document!.docs.where((element) =>element.get(FirestoreConstants.accountType)=='client'&& element.get(FirestoreConstants.chatStatue)=='active').toList().length;
      return GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        children:[
          // support team
          TopCounterCardInfoWidget(
            color: primaryColor,
            icon: 'assets/icons/support_team_icon.svg',
            iconColor: primaryColor,
            title: 'Support Team',
            progressCount:double.parse((supportTeamCount/allUsersInApp*100).toString()).toInt()>0?double.parse((supportTeamCount/allUsersInApp*100).toString()).toInt():0,
            progressColor:primaryColor ,
            unitText: '',
            total: supportTeamCount,
            currentCount: '$allUsersInApp Users',
          ),
          // Clients
          TopCounterCardInfoWidget(
            color: Color(0xFF26E5FF),
            icon: 'assets/icons/clients.svg',
            iconColor: const Color(0xFF26E5FF),
            title: 'Clients',
            progressCount:double.parse((clientsCount/allUsersInApp*100).toString()).toInt()>0?double.parse((clientsCount/allUsersInApp*100).toString()).toInt():0,
            progressColor:Color(0xFF26E5FF) ,
            unitText: '',
            total: clientsCount,
            currentCount: '$allUsersInApp Users',
          ),

          // active chat
          TopCounterCardInfoWidget(
            color: Colors.green,
            icon: 'assets/icons/active_chat.svg',
            iconColor: Colors.green,
            title: 'Active Chat',
            progressCount:double.parse((clientsChatActiveCount/allClientsChatCount*100).toString()).toInt()>0?double.parse((clientsChatActiveCount/allClientsChatCount*100).toString()).toInt():0,
            progressColor:Colors.green ,
            unitText: '',
            total: clientsChatActiveCount,
            currentCount: '$allClientsChatCount Chat',
          ),
          // all chats to now
          TopCounterCardInfoWidget(
            color: Color(0xFFFFCF26),
            icon: 'assets/icons/all_chats.svg',
            iconColor: Color(0xFFFFCF26),
            title: 'All Chat',
            progressCount:100 ,
            progressColor:Color(0xFFFFCF26) ,
            unitText: 'Chat',
            total: allClientsChatCount,
            currentCount: '',
          ),

        ],

      );
    }
    else {
      return const SizedBox.shrink();
    }

  }
}


class LoadingFileInfoCardGridView extends StatelessWidget {
  const LoadingFileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      children:const [
        // support team
        LoadingTopCounterCardInfoWidget(),
        // Clients
        LoadingTopCounterCardInfoWidget(),

        // active chat
        LoadingTopCounterCardInfoWidget(),
        // all chats to now
        LoadingTopCounterCardInfoWidget(),

      ],

    );
  }
}
