import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/global_var.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/my_text_field.dart';
import 'package:the_zikir_app/widgets/top_container.dart';

class EditZikirCounter extends StatefulWidget {
  final Counter counter;
  EditZikirCounter({required this.counter});

  @override
  _EditZikirCounter createState() => _EditZikirCounter();
}

class _EditZikirCounter extends State<EditZikirCounter> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _counterLimitController = TextEditingController();
  TextEditingController _zikirCountController = TextEditingController();
  TextEditingController _themeController = TextEditingController();
  CounterBloc _counterBloc = CounterBloc();
  final BannerAd myBanner = BannerAd(
    adUnitId: GlobalVar.counterEditBannerAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
    myBanner.load();
    _counterBloc.add(CounterGetById(widget.counter.id));
    _titleController.value =
        TextEditingValue(text: widget.counter.name ?? 'Counter');
    _descriptionController.value =
        TextEditingValue(text: widget.counter.description ?? '');
    _counterLimitController.value =
        TextEditingValue(text: widget.counter.limiter.toString());
    _themeController.value =
        TextEditingValue(text: widget.counter.counterTheme ?? 'green');
    _zikirCountController.value =
        TextEditingValue(text: widget.counter.counter.toString());
  }

  @override
  dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _counterLimitController.dispose();
    _themeController.dispose();
    _zikirCountController.dispose();
    super.dispose();
  }

  static CircleAvatar plusIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Color(0xff43c59e),
      child: Icon(
        Icons.add,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      bottomNavigationBar: Container(
        child: AdWidget(ad: myBanner),
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      ),
      body: SafeArea(
        child: BlocConsumer<CounterBloc, CounterState>(
          bloc: _counterBloc,
          listener: (context, state) {
            // TODO: implement listener
            if (state is CounterError) {
              print('Counter Error...');
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message ?? 'Counter Error.'),
                // action: SnackBarAction(
                //   label: 'Undo',
                //   onPressed: () {
                //     // Some code to undo the change.
                //   },
                // ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            if (state is CounterSaved) {
              print('Counter Saved...');
              final snackBar = SnackBar(
                backgroundColor: LightColors.kGreen,
                content: Text('Counter Saved.'),
                // action: SnackBarAction(
                //   label: 'Undo',
                //   onPressed: () {
                //     // Some code to undo the change.
                //   },
                // ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is CounterSaved) {
              _titleController.value =
                  TextEditingValue(text: state.counter?.name ?? 'Counter');
              _descriptionController.value =
                  TextEditingValue(text: state.counter?.description ?? '');
              _counterLimitController.value = TextEditingValue(
                  text: state.counter?.limiter.toString() ?? '');
              _themeController.value = TextEditingValue(
                  text: state.counter?.counterTheme ?? 'green');
              _zikirCountController.value = TextEditingValue(
                  text: state.counter?.counter.toString() ?? '');
            }
            return Column(
              children: <Widget>[
                TopContainer(
                  color: LightColors.getThemeColor(
                      colorName: widget.counter.counterTheme,
                      contrast: 'light'),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyBackButton(
                            color: LightColors.getThemeColor(
                                colorName: widget.counter.counterTheme,
                                contrast: 'dark'),
                          ),
                          GestureDetector(
                            onTap: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Alert'),
                                content: const Text(
                                    'Are you sure to delete this counter?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _counterBloc.add(
                                          CounterDelete(widget.counter.id));
                                      // Navigator.pop(context, 'OK');
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                          (route) => false);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                            child: Icon(CupertinoIcons.trash_fill,
                                color: LightColors.kRed, size: 25.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _titleController.text,
                            style: TextStyle(
                                color: LightColors.getThemeColor(
                                    colorName: state is CounterLoaded
                                        ? state.counter?.counterTheme
                                        : null,
                                    contrast: 'dark'),
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Expanded(
                      //         child: MyTextField(
                      //       label: 'Start Time',
                      //       icon: downwardIcon,
                      //     )),
                      //     SizedBox(width: 40),
                      //     Expanded(
                      //       child: MyTextField(
                      //         label: 'End Time',
                      //         icon: downwardIcon,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      MyTextField(
                          label: 'Title - e.g: Salawat etc.',
                          controller: _titleController),
                      MyTextField(
                          label: 'Note',
                          minLines: 3,
                          maxLines: 3,
                          controller: _descriptionController),
                      SizedBox(height: 20),
                      MyTextField(
                          keyboardType: TextInputType.number,
                          label: 'Zikir Count',
                          controller: _zikirCountController),
                      SizedBox(height: 20),
                      MyTextField(
                          keyboardType: TextInputType.number,
                          label: 'Target Zikir Count',
                          controller: _counterLimitController),
                      SizedBox(height: 20),
                      // MyTextField(
                      //     label: 'Theme',
                      //     icon: downwardIcon,
                      //     controller: _themeController),
                      // SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Theme',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        style: TextStyle(color: Colors.black),
                        hint: Text('Theme'),
                        isExpanded: true,
                        value: _themeController.text,
                        items: <String>['green', 'red', 'blue']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            _themeController.value =
                                TextEditingValue(text: _ ?? 'green');
                          });
                        },
                      ),
                      // Container(
                      //   alignment: Alignment.topLeft,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Text(
                      //         'Category',
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           color: Colors.black54,
                      //         ),
                      //       ),
                      //       Wrap(
                      //         crossAxisAlignment: WrapCrossAlignment.start,
                      //         //direction: Axis.vertical,
                      //         alignment: WrapAlignment.start,
                      //         verticalDirection: VerticalDirection.down,
                      //         runSpacing: 0,
                      //         //textDirection: TextDirection.rtl,
                      //         spacing: 10.0,
                      //         children: <Widget>[
                      //           Chip(
                      //             label: Text("SPORT APP"),
                      //             backgroundColor: LightColors.kRed,
                      //             labelStyle: TextStyle(color: Colors.white),
                      //           ),
                      //           Chip(
                      //             label: Text("MEDICAL APP"),
                      //           ),
                      //           Chip(
                      //             label: Text("RENT APP"),
                      //           ),
                      //           Chip(
                      //             label: Text("NOTES"),
                      //           ),
                      //           Chip(
                      //             label: Text("GAMING PLATFORM APP"),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                )),
                InkWell(
                  onTap: () {
                    setState(() {
                      _counterBloc.add(CounterUpdate(widget.counter.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          limiter: int.parse(_counterLimitController.text),
                          counterTheme: _themeController.text,
                          counter: int.parse(_zikirCountController.text)));
                    });
                  },
                  child: Container(
                    height: 80,
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          width: width - 40,
                          decoration: BoxDecoration(
                            color: LightColors.getThemeColor(
                                colorName: widget.counter.counterTheme,
                                contrast: 'dark'),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
