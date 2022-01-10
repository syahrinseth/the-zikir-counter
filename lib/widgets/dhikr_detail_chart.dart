/// Horizontal bar chart with bar label renderer example and hidden domain axis.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class DhikrDetailChart extends StatelessWidget {
  final List<charts.Series<CounterDetailChartData, String>> seriesList;
  final String title;
  final bool animate;

  DhikrDetailChart(this.seriesList,
      {required this.animate, required this.title});

  /// Creates a [BarChart] with sample data and no transition.
  factory DhikrDetailChart.withSampleData() {
    return new DhikrDetailChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
      title: 'Dhikr by Name',
    );
  }

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit and the
  // area outside of the bar is larger than the bar, it will draw outside of the
  // bar. Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    // return new charts.BarChart(
    //   seriesList,
    //   animate: animate,
    //   vertical: false,
    //   // Set a bar label decorator.
    //   // Example configuring different styles for inside/outside:
    //   //       barRendererDecorator: new charts.BarLabelDecorator(
    //   //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
    //   //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
    //   barRendererDecorator: new charts.BarLabelDecorator<String>(),
    //   // Hide domain axis.
    //   domainAxis:
    //       new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    // );
    ProfileState parentState = BlocProvider.of<ProfileBloc>(context).state;
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
        padding: const EdgeInsets.only(right: 20.0, top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      title,
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
                ),
              ],
            ),
            Row(
              children: [
                // Expanded(
                //   child: Text(
                //     widget.desc,
                //     style: TextStyle(
                //       fontSize: 16.0,
                //       color: LightColors.getThemeColor(
                //           state: parentState,
                //           colorName: 'green',
                //           contrast: 'dark',
                //           isBackgroundColor: true),
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
            Expanded(
                child: new charts.BarChart(
              seriesList,
              animate: animate,
              vertical: false,
              // Set a bar label decorator.
              // Example configuring different styles for inside/outside:
              //       barRendererDecorator: new charts.BarLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              // Hide domain axis.
              domainAxis: new charts.OrdinalAxisSpec(
                  renderSpec: new charts.NoneRenderSpec()),
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
  static List<charts.Series<CounterDetailChartData, String>>
      _createSampleData() {
    final data = [
      new CounterDetailChartData(
          'Dhikr', 5, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterDetailChartData('Alhamdulillah', 25,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterDetailChartData(
          'La ila', 100, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
      new CounterDetailChartData(
          'Allah', 75, charts.ColorUtil.fromDartColor(Color(0xff43c59e))),
    ];

    return [
      new charts.Series<CounterDetailChartData, String>(
          id: 'Dhikr Detail',
          domainFn: (CounterDetailChartData dhikr, _) => dhikr.name,
          measureFn: (CounterDetailChartData dhikr, _) => dhikr.total,
          data: data,
          colorFn: (CounterDetailChartData data, _) => data.color,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (CounterDetailChartData dhikr, _) =>
              '${dhikr.name}: ${dhikr.total.toString()}'),
    ];
  }
}

/// Sample ordinal data type.
class CounterDetailChartData {
  final String name;
  final int total;
  final charts.Color color;

  CounterDetailChartData(this.name, this.total, this.color);
}
