import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tshtri_support/screens/top_cards_counter/top_counter_cards_section.dart';
import 'package:tshtri_support/screens/recent_chats_section/recent_chats_section.dart';
import 'package:tshtri_support/screens/chart_section/chart_counter_info_section.dart';
import 'package:tshtri_support/constants/color_constants.dart';
import 'package:tshtri_support/helper/responsive.dart';
import 'package:tshtri_support/utils/debouncer.dart';

class DashboardScreen extends StatefulWidget {
  final TextEditingController searchBarTec;
  final StreamController<bool> btnClearController;
  final Debouncer searchDebouncer;
  const DashboardScreen({
    Key? key,
    required this.searchBarTec,
    required this.btnClearController,
    required this.searchDebouncer,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        children: [

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(defaultPadding),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          primary: false,
                          child: Column(
                            children: [
                              const TopCounterCardsSection(),
                              const  SizedBox(height: defaultPadding),
                              RecentChatSection(
                                btnClearController:widget.btnClearController ,
                                searchDebouncer:widget.searchDebouncer,
                                searchBarTec: widget.searchBarTec,
                              ),
                              if (SizeConfig.isMobile(context))
                                const SizedBox(height: defaultPadding),
                              if (SizeConfig.isMobile(context)) const ChartCounterInfoSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!SizeConfig.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!SizeConfig.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: ChartCounterInfoSection(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
