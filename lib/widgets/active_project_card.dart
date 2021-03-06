import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final String title;
  final String subtitle;
  final DateTime? dateTime;
  final Function()? onTap;

  ActiveProjectsCard(
      {required this.cardColor,
      required this.loadingPercent,
      required this.title,
      required this.subtitle,
      this.dateTime,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: this.onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(15.0),
          height: 250,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularPercentIndicator(
                  animation: true,
                  radius: 75.0,
                  percent: loadingPercent,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.white10,
                  progressColor: Colors.white,
                  center: Text(
                    '${(loadingPercent * 100).round()}%',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle == ""
                      ? SizedBox()
                      : Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                  Text(
                    timeago
                            .format(dateTime ?? DateTime.now())[0]
                            .toUpperCase() +
                        timeago.format(dateTime ?? DateTime.now()).substring(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
