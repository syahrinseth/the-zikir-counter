import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/avatar_picker.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/dhikr_snack_bar.dart';
import 'package:the_zikir_app/widgets/my_text_field.dart';
import 'package:the_zikir_app/widgets/top_container.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEdit createState() => _ProfileEdit();
}

class _ProfileEdit extends State<ProfileEdit> {
  ProfileBloc _profileBloc = ProfileBloc();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _avatarController = TextEditingController(text: 'male');
  TextEditingController _counterGoalController =
      TextEditingController(text: '100');
  TextEditingController _themeModeController =
      TextEditingController(text: 'light');
  bool initMark = true;
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: GlobalVar.profileEditBannerAdId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    _profileBloc.add(ProfileGet());
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.close();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ProfileBloc parentProfileBloc = BlocProvider.of<ProfileBloc>(context);
    return Scaffold(
      // backgroundColor: LightColors.getThemeColor(
      //     state: parentProfileBloc.state,
      //     colorName: 'yellow',
      //     contrast: 'light',
      //     isBackgroundColor: true),
      // bottomNavigationBar: Container(
      //   child: AdWidget(ad: myBanner),
      //   width: myBanner.size.width.toDouble(),
      //   height: myBanner.size.height.toDouble(),
      // ),
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is ProfileError) {
              print('Counter Error...');
              SnackBar snackBar = DhikrSnackBar.setSnackBar(context,
                  message: state.message ?? 'Error', colorName: 'red');
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            if (state is ProfileSaved) {
              print('Saved...');
              SnackBar snackBar =
                  DhikrSnackBar.setSnackBar(context, message: "Saved");
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoaded && initMark == true) {
              initMark = false;
              _nameController.value =
                  TextEditingValue(text: state.name ?? 'Counter');
              _avatarController.value =
                  TextEditingValue(text: state.avatar ?? 'male');
              _counterGoalController.value =
                  TextEditingValue(text: state.counterGoal ?? '100');
              _themeModeController.value =
                  TextEditingValue(text: state.themeMode ?? 'light');
            }
            return Column(
              children: [
                TopContainer(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  color: LightColors.getThemeColor(
                      state: parentProfileBloc.state,
                      colorName: 'green',
                      contrast: 'light',
                      isBackgroundColor: true),
                  width: width,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyBackButton(
                        color: LightColors.getThemeColor(
                            state: parentProfileBloc.state,
                            colorName: 'green',
                            contrast: 'dark'),
                      ),
                      Text('Profile'),
                      CupertinoButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.apps,
                          color: LightColors.getThemeColor(
                              state: parentProfileBloc.state,
                              colorName: 'green',
                              contrast: 'light',
                              isBackgroundColor: true),
                        ),
                      )
                      // SizedBox()
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10.0),
                              AvatarPicker(
                                  controller: _avatarController,
                                  profileState: parentProfileBloc.state),
                              SizedBox(height: 10.0),
                              MyTextField(
                                  label: 'Name', controller: _nameController),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Theme Mode',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: LightColors.getThemeColor(
                                          state: parentProfileBloc.state,
                                          colorName: 'black',
                                          contrast: 'dark',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              DropdownButton<String>(
                                style: TextStyle(
                                  color: LightColors.getThemeColor(
                                    state: parentProfileBloc.state,
                                    colorName: 'black',
                                    contrast: 'dark',
                                  ),
                                ),
                                hint: Text('Theme Mode'),
                                isExpanded: true,
                                value:
                                    _themeModeController.text[0].toUpperCase() +
                                        _themeModeController.text
                                            .substring(1)
                                            .toLowerCase(),
                                items: <String>['Light', 'Dark']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (_) {
                                  setState(() {
                                    _themeModeController.value =
                                        TextEditingValue(
                                            text:
                                                (_?.toLowerCase()) ?? 'light');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _profileBloc.add(ProfileUpdate(
                                  name: _nameController.text,
                                  avatar: _avatarController.text,
                                  counterGoal: _counterGoalController.text,
                                  themeMode: _themeModeController.text));
                              parentProfileBloc.add(ProfileGet());
                            });
                          },
                          child: Container(
                            height: 80,
                            // width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: LightColors.getThemeColor(
                                            state: parentProfileBloc.state,
                                            colorName: 'white',
                                            contrast: 'dark',
                                          ),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                    decoration: BoxDecoration(
                                      color: LightColors.getThemeColor(
                                          state: parentProfileBloc.state,
                                          colorName: 'green',
                                          contrast: 'dark',
                                          isBackgroundColor: true),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
