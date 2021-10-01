import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/avatar_picker.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
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
    return Scaffold(
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
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message ?? 'Counter Error.'),
                // action: SnackBarAction(
                //   label: 'Undo',
                //   onPressed: () {
                //     // Some code to undo the change.
                //   },
                // ),
              );
            }

            if (state is ProfileSaved) {
              print('Saved...');
              final snackBar = SnackBar(
                backgroundColor: LightColors.kGreen,
                content: Text('Profile Saved.'),
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
            if (state is ProfileLoaded && initMark == true) {
              initMark = false;
              _nameController.value =
                  TextEditingValue(text: state.name ?? 'Counter');
              _avatarController.value =
                  TextEditingValue(text: state.avatar ?? 'male');
              _counterGoalController.value =
                  TextEditingValue(text: state.counterGoal ?? '100');
            }
            return Column(
              children: [
                TopContainer(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    color: Color(0xff43c59e),
                    width: width,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyBackButton(),
                        Text('Profile'),
                        Icon(Icons.apps, color: Color(0xff43c59e))
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10.0),
                              AvatarPicker(
                                controller: _avatarController,
                              ),
                              SizedBox(height: 10.0),
                              MyTextField(
                                  label: 'Name', controller: _nameController),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _profileBloc.add(ProfileUpdate(
                                  name: _nameController.text,
                                  avatar: _avatarController.text,
                                  counterGoal: _counterGoalController.text));
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                    decoration: BoxDecoration(
                                      color: LightColors.getThemeColor(
                                          colorName: 'green', contrast: 'dark'),
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
