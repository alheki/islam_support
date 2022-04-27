import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tshtri_support/constants/color_constants.dart';

class ChartCardItemWidget extends StatefulWidget {
  const ChartCardItemWidget({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.iconColor,
  }) : super(key: key);

  final String title, svgSrc, amountOfFiles;
  final Color iconColor;

  @override
  State<ChartCardItemWidget> createState() => _ChartCardItemWidgetState();
}

class _ChartCardItemWidgetState extends State<ChartCardItemWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(widget.svgSrc,color: widget.iconColor,),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
          ),
          Text(widget.amountOfFiles)
        ],
      ),
    );
  }
}
