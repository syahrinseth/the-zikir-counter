import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/my_text_field.dart';
import 'package:the_zikir_app/widgets/top_container.dart';

class ViewZikirCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Color(0xff3d7068),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(),
                      Icon(Icons.edit, color: Color(0xff3d7068), size: 25.0),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
                          animation: true,
                          radius: 90.0,
                          percent: 0.35,
                          lineWidth: 5.0,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Color(0xff3d7068),
                          progressColor: Color(0xffffffff),
                          center: Text(
                            '${(0.35 * 100).round()}%',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Selawat',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Color(0xff3d7068),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '1 hour progress',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff3d7068),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.all(15.0),
                      height: 320,
                      decoration: BoxDecoration(
                        color: Color(0xff3d7068),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Color(0xffffffff), fontSize: 50.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 70,
              width: width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        LineIcons.volumeUp,
                        size: 40.0,
                        color: Color(0xff3d7068),
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.vibration ?? LineIcons.mobilePhone,
                        size: 40.0,
                        color: Color(0xff3d7068),
                      ),
                    ),
                    Container(
                      child: Icon(
                        LineIcons.minus,
                        size: 40.0,
                        color: Color(0xff3d7068),
                      ),
                    ),
                    Container(
                      child: Icon(
                        LineIcons.undo,
                        size: 40.0,
                        color: Color(0xff3d7068),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
