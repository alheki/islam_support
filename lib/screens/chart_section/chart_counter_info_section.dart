import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/account_mangemant.dart';
import 'package:tshtri_support/screens/chart_section/widget/loading_chart_card_item.dart';
import 'widget/chart_animation_widget.dart';
import 'widget/chart_card_item.dart';
import 'package:tshtri_support/constants/firestore_constants.dart';
import 'package:tshtri_support/providers/chat_provider.dart';
import 'package:tshtri_support/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChartCounterInfoSection extends StatefulWidget {
  const ChartCounterInfoSection({
    Key? key,
  }) : super(key: key);

  @override
  State<ChartCounterInfoSection> createState() => _ChartCounterInfoSectionState();
}

class _ChartCounterInfoSectionState extends State<ChartCounterInfoSection> {


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
        context.read<HomeProvider>().getAllAccountsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _textSearch);
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
    return StreamBuilder<QuerySnapshot>(
      stream: homeProvider.getAllAccountsStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _textSearch),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data?.docs.length ?? 0) > 0) {
            int supportTeamCount=snapshot.data!.docs.where((element) => element.get(FirestoreConstants.accountType)=='admin').toList().length;
            int clientsCount=snapshot.data!.docs.where((element) => element.get(FirestoreConstants.accountType)=='client').toList().length;
            int allChatInAppCount=snapshot.data!.docs.toList().length;
            int clientsChatActiveCount=snapshot.data!.docs.where((element) =>element.get(FirestoreConstants.accountType)=='client'&& element.get(FirestoreConstants.chatStatue)=='active').toList().length;
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration:const BoxDecoration(
                color: secondaryColor,
                borderRadius:  BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  ChartAnimationWidget(
                    allCount: allChatInAppCount.toDouble(),
                    chatList: [
                      // support team
                      PieChartSectionData(
                        color: primaryColor,
                        value: supportTeamCount.toDouble(),
                        showTitle: false,
                        radius: 25,
                      ),
                      // clients Count
                      PieChartSectionData(
                        color: const Color(0xFF26E5FF),
                        value: clientsCount.toDouble(),
                        showTitle: false,
                        radius: 22,
                      ),
                      // active
                      PieChartSectionData(
                        color: Colors.green,
                        value: clientsCount.toDouble(),
                        showTitle: false,
                        radius: 19,
                      ),
                      // clients Chat Active Count
                      PieChartSectionData(
                        color:const Color(0xFFFFCF26),
                        value: clientsChatActiveCount.toDouble(),
                        showTitle: false,
                        radius: 16,
                      ),


                    ],
                  ),



                  ChartCardItemWidget(
                    svgSrc: "assets/icons/support_team_icon.svg",
                    title: "Support team",
                    iconColor: primaryColor,
                    amountOfFiles: "${supportTeamCount.toString()} User",
                  ),
                  ChartCardItemWidget(
                    svgSrc: "assets/icons/clients.svg",
                    title: "Clients",
                    iconColor: const Color(0xFF26E5FF),
                    amountOfFiles: "${clientsCount.toString()} Client",
                  ),
                  ChartCardItemWidget(
                    svgSrc: "assets/icons/active_chat.svg",
                    title: "Active Chat",
                    iconColor:Colors.green ,
                    amountOfFiles: "${clientsChatActiveCount.toString()} Chat",
                  ),
                  ChartCardItemWidget(
                    svgSrc: "assets/icons/all_chats.svg",
                    title: "All Chat",
                    iconColor: const Color(0xFFFFCF26),
                    amountOfFiles: "${allChatInAppCount.toString()} Chat",
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return buildChartSectionLoading(context);
        }
      },
    );

  }

  Widget buildChartSectionLoading(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration:const BoxDecoration(
        color: secondaryColor,
        borderRadius:  BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          ChartAnimationWidget(
            allCount: 0,
            chatList: [
              // support team
              PieChartSectionData(
                color: primaryColor.withOpacity(0.1),
                value: 100,
                showTitle: false,
                radius: 10,
              ),
            ],
          ),

          const LoadingChartCardItemWidget(),
          const LoadingChartCardItemWidget(),
          const LoadingChartCardItemWidget(),
          const LoadingChartCardItemWidget(),
        ],
      ),
    );
  }
}
