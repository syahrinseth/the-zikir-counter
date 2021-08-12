import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:the_zikir_app/widgets/month_bar_graph_card.dart';

class YearBarGraphCard extends StatefulWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
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
  _YearBarGraphCardState createState() => _YearBarGraphCardState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<CounterYearBarChartData, DateTime>>
      _createSampleData() {
    List<CounterYearBarChartData> data = [
      new CounterYearBarChartData(DateTime.parse('2021-01-01'), 5,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-02-01'), 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-03-01'), 80,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-04-01'), 5,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-05-01'), 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-06-01'), 40,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-07-01'), 5,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-08-01'), 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-09-01'), 40,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-10-01'), 5,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-11-01'), 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterYearBarChartData(DateTime.parse('2021-12-01'), 40,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
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
      new charts.Series<CounterYearBarChartData, DateTime>(
        id: 'Year Bar Chart',
        domainFn: (CounterYearBarChartData data, _) => data.dateTime,
        measureFn: (CounterYearBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterYearBarChartData data, _) => data.color,
        radiusPxFn: (CounterYearBarChartData data, _) => 40.0,
      ),
    ];
  }
}

class _YearBarGraphCardState extends State<YearBarGraphCard> {
  int graphLabel = 0;
  @override
  Widget build(BuildContext context) {
    charts.ChartBehavior<DateTime> labelDraw = new charts.LinePointHighlighter(
        symbolRenderer: CustomCircleSymbolRenderer(amount: graphLabel));
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
                child: charts.TimeSeriesChart(
              widget.seriesList,
              animate: widget.animate,
              defaultInteractions: false,
              // domainAxis: charts.DateTimeAxisSpec(),
              defaultRenderer: new charts.BarRendererConfig<DateTime>(),
              behaviors: [
                new charts.SelectNearest(),
                new charts.DomainHighlighter(),
                labelDraw
                // new charts.DomainA11yExploreBehavior(),
                // charts.LinePointHighlighter(
                //     symbolRenderer: charts.SymbolRenderer())
              ],
              selectionModels: [
                // charts.SelectionModelConfig(
                //     changedListener: (charts.SelectionModel model) {
                //   // if (model.hasDatumSelection)
                //   //   print(model.selectedSeries[0]
                //   //       .measureFn(model.selectedDatum[0].index));
                // })
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

class CounterYearBarChartData {
  final DateTime dateTime;
  final int count;
  final charts.Color color;
  CounterYearBarChartData(this.dateTime, this.count, this.color);
}
