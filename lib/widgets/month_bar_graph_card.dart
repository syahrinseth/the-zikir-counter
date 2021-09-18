import 'dart:math';
import 'dart:ui';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class MonthBarGraphCard extends StatefulWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final String title;
  final int total;

  MonthBarGraphCard(this.seriesList,
      {this.animate = true, required this.title, this.total = 0});

  /// Creates a [BarChart] with sample data and no transition.
  factory MonthBarGraphCard.withSampleData() {
    return MonthBarGraphCard(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
      title: 'Title',
    );
  }

  @override
  _MonthBarGraphCardState createState() => _MonthBarGraphCardState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<CounterMonthBarChartData, DateTime>>
      _createSampleData() {
    List<CounterMonthBarChartData> data = [
      new CounterMonthBarChartData(
          DateTime.now(), 5, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterMonthBarChartData(DateTime.now().add(Duration(days: 2)), 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterMonthBarChartData(
      //     'Tue', 110, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterMonthBarChartData(
      //     'Wed', 75, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterMonthBarChartData(
      //     'Thu', 35, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterMonthBarChartData(
      //     'Fri', 45, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterMonthBarChartData(
      //     'Sat', 15, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
    ];

    return [
      new charts.Series<CounterMonthBarChartData, DateTime>(
        id: 'Month Bar Chart',
        domainFn: (CounterMonthBarChartData data, _) => data.dateTime,
        measureFn: (CounterMonthBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterMonthBarChartData data, _) => data.color,
        radiusPxFn: (CounterMonthBarChartData data, _) => 40.0,
      ),
    ];
  }
}

class _MonthBarGraphCardState extends State<MonthBarGraphCard> {
  int graphLabel = 0;
  charts.ChartBehavior<DateTime> labelDraw = new charts.LinePointHighlighter(
      symbolRenderer: CustomCircleSymbolRenderer(labelAmount: 0));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    labelDraw = new charts.LinePointHighlighter(
        symbolRenderer: CustomCircleSymbolRenderer(labelAmount: 22));
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
                    'Total dhikred ${widget.total}.',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Container(
              height: 240,
              child: Column(
                children: [
                  Expanded(
                    child: charts.TimeSeriesChart(widget.seriesList,
                        animate: widget.animate,
                        // Set the default renderer to a bar renderer.
                        // This can also be one of the custom renderers of the time series chart.
                        defaultRenderer: new charts.BarRendererConfig<DateTime>(
                            // barRendererDecorator:
                            //     new charts.BarLabelDecorator<DateTime>(
                            //   insideLabelStyleSpec: new charts.TextStyleSpec(
                            //       color: charts.Color.white, fontSize: 10),
                            //   outsideLabelStyleSpec: new charts.TextStyleSpec(
                            //       color: charts.Color.fromHex(code: '#3d7068'),
                            //       fontSize: 10),
                            // ),
                            ),
                        // It is recommended that default interactions be turned off if using bar
                        // renderer, because the line point highlighter is the default for time
                        // series chart.
                        defaultInteractions: true,
                        // If default interactions were removed, optionally add select nearest
                        // and the domain highlighter that are typical for bar charts.
                        behaviors: [
                          new charts.SelectNearest(),
                          new charts.DomainHighlighter(),
                          labelDraw,
                        ],
                        selectionModels: [
                          new charts.SelectionModelConfig(
                            type: charts.SelectionModelType.info,
                            changedListener: (model) {
                              if (model.hasDatumSelection) {
                                print(model.selectedSeries[0]
                                    .measureFn(model.selectedDatum[0].index));
                                setState(() {
                                  graphLabel = (model.selectedSeries[0]
                                          .measureFn(
                                              model.selectedDatum[0].index)
                                          ?.toInt() ??
                                      0);
                                });
                              }
                            },
                            updatedListener: (model) {
                              print('updatedListener in $model');
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            )
            // child: charts.BarChart(
            //   seriesList,
            //   animate: animate,
            //   defaultInteractions: true,
            //   // primaryMeasureAxis: new charts.NumericAxisSpec(
            //   //   tickProviderSpec: charts.NumericTickProviderSpec,
            //   // ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CounterMonthBarChartData {
  final DateTime dateTime;
  final int count;
  final charts.Color color;
  CounterMonthBarChartData(this.dateTime, this.count, this.color);
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  CustomCircleSymbolRenderer({required this.labelAmount}) : super();
  int labelAmount;
  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    charts.Color? fillColor,
    charts.FillPatternType? fillPattern,
    charts.Color? strokeColor,
    double? strokeWidthPx,
  }) {
    // super.paint(canvas, bounds,
    //     dashPattern: dashPattern,
    //     fillColor: fillColor,
    //     fillPattern: fillPattern,
    //     strokeColor: strokeColor,
    //     strokeWidthPx: strokeWidthPx);
    // canvas.drawRect(
    //     Rectangle(bounds.left - 5, bounds.top - 5, bounds.width, bounds.height),
    //     fill: charts.Color.fromHex(code: '#3d7068'));
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 15;
    // canvas.drawText(
    //     TextElement.TextElement(labelAmount.toString(), style: textStyle),
    //     (bounds.left).round(),
    //     (bounds.height).round());
  }
}
