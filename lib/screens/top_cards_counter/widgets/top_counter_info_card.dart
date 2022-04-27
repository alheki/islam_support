import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tshtri_support/constants/color_constants.dart';

class TopCounterCardInfoWidget extends StatelessWidget {

  final Color color;
  final String icon;
  final Color iconColor;
  final String title;
  final int progressCount;
  final Color progressColor;
  final String unitText;
  final int total;
  final String currentCount;



  const TopCounterCardInfoWidget({
    Key? key,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.progressColor,
    required this.progressCount,
    required this.unitText,
    required this.total,
    required this.currentCount,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: iconColor,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: progressColor,
            percentage: progressCount,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$total $unitText",
                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
              ),
              Text(
                currentCount,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color:Colors.white70 ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
