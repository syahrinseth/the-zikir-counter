// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/month_bar_graph_card.dart';

class DayBarGraphCard extends StatefulWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final String title;
  final String desc;

  DayBarGraphCard(this.seriesList,
      {this.animate = true, required this.title, required this.desc});

  /// Creates a [BarChart] with sample data and no transition.
  factory DayBarGraphCard.withSampleData() {
    return DayBarGraphCard(_createSampleData(),
        // Disable animations for image tests.
        animate: true,
        title: 'Title',
        desc: 'Description');
  }

  @override
  _DayBarGraphCardState createState() => _DayBarGraphCardState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<CounterDayBarChartData, DateTime>>
      _createSampleData() {
    List<CounterDayBarChartData> data = [
      // new CounterDayBarChartData(
      //     'Sun', 5, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Mon', 25, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Tue', 110, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Wed', 75, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Thu', 35, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Fri', 45, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      // new CounterDayBarChartData(
      //     'Sat', 15, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
    ];

    return [
      new charts.Series<CounterDayBarChartData, DateTime>(
        id: 'Sales',
        domainFn: (CounterDayBarChartData data, _) => data.dateTime,
        measureFn: (CounterDayBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterDayBarChartData data, _) => data.color,
        radiusPxFn: (CounterDayBarChartData data, _) => 40.0,
      ),
    ];
  }
}

class _DayBarGraphCardState extends State<DayBarGraphCard> {
  int graphLabel = 0;
  @override
  Widget build(BuildContext context) {
    ProfileState parentState = BlocProvider.of<ProfileBloc>(context).state;
    charts.ChartBehavior<DateTime> labelDraw = new charts.LinePointHighlighter(
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
        color: LightColors.getThemeColor(
            state: parentState,
            colorName: 'white',
            contrast: 'dark',
            isBackgroundColor: true),
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
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: LightColors.getThemeColor(
                            state: parentState,
                            colorName: 'green',
                            contrast: 'dark',
                            isBackgroundColor: true)),
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
                    style: TextStyle(
                        fontSize: 16.0,
                        color: LightColors.getThemeColor(
                            state: parentState,
                            colorName: 'green',
                            contrast: 'dark',
                            isBackgroundColor: true)),
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
              customSeriesRenderers: [],
              defaultRenderer: new charts.BarRendererConfig<DateTime>(
                  // barRendererDecorator: new charts.BarLabelDecorator<DateTime>(
                  //   labelPosition: charts.BarLabelPosition.auto,
                  //   insideLabelStyleSpec: new charts.TextStyleSpec(
                  //       color: charts.Color.white, fontSize: 10),
                  //   outsideLabelStyleSpec: new charts.TextStyleSpec(
                  //       color: charts.Color.fromHex(code: '#3d7068'),
                  //       fontSize: 10),
                  // ),
                  ),
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              domainAxis: charts.DateTimeAxisSpec(
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                    format: 'dd',
                    transitionFormat: 'dd',
                  ),
                ),
              ),
              behaviors: [
                new charts.SelectNearest(),
                new charts.DomainHighlighter(),
                // new charts.DomainA11yExploreBehavior(),
                labelDraw,
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
}

class CounterDayBarChartData {
  final DateTime dateTime;
  final int count;
  final charts.Color color;
  CounterDayBarChartData(this.dateTime, this.count, this.color);
}
