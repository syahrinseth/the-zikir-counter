// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:the_zikir_app/widgets/month_bar_graph_card.dart';

class WeekBarGraphCard extends StatefulWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final String title;
  final String desc;

  WeekBarGraphCard(this.seriesList,
      {this.animate = true, required this.title, required this.desc});

  /// Creates a [BarChart] with sample data and no transition.
  factory WeekBarGraphCard.withSampleData() {
    return WeekBarGraphCard(_createSampleData(),
        // Disable animations for image tests.
        animate: true,
        title: 'Title',
        desc: 'Description');
  }

  @override
  _WeekBarGraphCardState createState() => _WeekBarGraphCardState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<CounterWeekBarChartData, String>>
      _createSampleData() {
    List<CounterWeekBarChartData> data = [
      // new CounterWeekBarChartData(
      //     'Sun', 5, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Mon', 25, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Tue', 110, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Wed', 75, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Thu', 35, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Fri', 45, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterWeekBarChartData(
      //     'Sat', 15, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
    ];

    return [
      new charts.Series<CounterWeekBarChartData, String>(
        id: 'Week Bar Chart',
        domainFn: (CounterWeekBarChartData data, _) => data.dayName,
        measureFn: (CounterWeekBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterWeekBarChartData data, _) => data.color,
        radiusPxFn: (CounterWeekBarChartData data, _) => 40.0,
      ),
    ];
  }
}

class _WeekBarGraphCardState extends State<WeekBarGraphCard> {
  int graphLabel = 0;

  @override
  Widget build(BuildContext context) {
    charts.ChartBehavior<String> labelDraw = new charts.LinePointHighlighter(
        symbolRenderer: CustomCircleSymbolRenderer(labelAmount: graphLabel));
    // This is just a simple bar chart with optional property
    // [defaultInteractions] set to true to include the default
    // interactions/behaviors when building the chart.
    // This includes bar highlighting.
    //
    // Note: defaultInteractions defaults to true.
    //
    // [defaultInteractions] can be set to false to avoid the default
    // interactions.
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.desc,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Expanded(
                child: charts.BarChart(
              widget.seriesList,
              animate: widget.animate,
              defaultInteractions: true,
              // barRendererDecorator: new charts.BarLabelDecorator<String>(
              //   insideLabelStyleSpec: new charts.TextStyleSpec(
              //       color: charts.Color.white, fontSize: 10),
              //   outsideLabelStyleSpec: new charts.TextStyleSpec(
              //       color: charts.Color.fromHex(code: '#3d7068'), fontSize: 10),
              // ),
              behaviors: [
                new charts.SelectNearest(),
                new charts.DomainHighlighter(),
                labelDraw
              ],
            )
                // child: charts.BarChart(
                //   seriesList,
                //   animate: animate,
                //   defaultInteractions: true,
                //   // primaryMeasureAxis: new charts.NumericAxisSpec(
                //   //   tickProviderSpec: charts.NumericTickProviderSpec,
                //   // ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}

class CounterWeekBarChartData {
  final String dayName;
  final int count;
  final charts.Color color;
  CounterWeekBarChartData(this.dayName, this.count, this.color);
}
