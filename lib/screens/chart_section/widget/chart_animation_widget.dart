import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tshtri_support/constants/color_constants.dart';

class ChartAnimationWidget extends StatelessWidget {
 final List<PieChartSectionData> chatList;
 final double allCount;

  const ChartAnimationWidget({
    Key? key,
    required this.chatList,
    required this.allCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: chatList,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                    allCount>0?allCount.toStringAsFixed(0):'',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

