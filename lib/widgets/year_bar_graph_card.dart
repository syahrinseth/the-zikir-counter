import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class YearBarGraphCard extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final String title;
  final String desc;

  YearBarGraphCard(this.seriesList,
      {this.animate = true, required this.title, required this.desc});

  /// Creates a [BarChart] with sample data and no transition.
  factory YearBarGraphCard.withSampleData() {
    return YearBarGraphCard(_createSampleData(),
        // Disable animations for image tests.
        animate: true,
        title: 'Title',
        desc: 'Description');
  }

  @override
  Widget build(BuildContext context) {
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
                    title,
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
                    desc,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Expanded(
                child: charts.BarChart(
              seriesList,
              animate: animate,
              defaultInteractions: false,
              domainAxis: charts.DateTimeAxisSpec(),
              behaviors: [
                new charts.SelectNearest(),
                new charts.DomainHighlighter(),
                new charts.DomainA11yExploreBehavior(),
                // charts.LinePointHighlighter(
                //     symbolRenderer: charts.SymbolRenderer())
              ],
              selectionModels: [
                charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model) {
                  // if (model.hasDatumSelection)
                  //   print(model.selectedSeries[0]
                  //       .measureFn(model.selectedDatum[0].index));
                })
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

  /// Create one series with sample hard coded data.
  static List<charts.Series<CounterYearBarChartData, String>>
      _createSampleData() {
    List<CounterYearBarChartData> data = [
      // new CounterYearBarChartData(
      //     'Sun', 5, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Mon', 25, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Tue', 110, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Wed', 75, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Thu', 35, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Fri', 45, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterYearBarChartData(
      //     'Sat', 15, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
    ];

    return [
      new charts.Series<CounterYearBarChartData, String>(
        id: 'Year Bar Chart',
        domainFn: (CounterYearBarChartData data, _) => data.yearName,
        measureFn: (CounterYearBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterYearBarChartData data, _) => data.color,
        radiusPxFn: (CounterYearBarChartData data, _) => 40.0,
      ),
    ];
  }
}

class CounterYearBarChartData {
  final String yearName;
  final int count;
  final charts.Color color;
  CounterYearBarChartData(this.yearName, this.count, this.color);
}
