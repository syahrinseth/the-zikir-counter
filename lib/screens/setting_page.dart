import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/profile_edit.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/dhikr_list_tile.dart';
import 'package:the_zikir_app/widgets/my_text_field.dart';
import 'package:the_zikir_app/widgets/task_column.dart';
import 'package:the_zikir_app/widgets/top_container.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _ProfileEdit createState() => _ProfileEdit();
}

class _ProfileEdit extends State<SettingPage> {
  ProfileBloc _profileBloc = ProfileBloc();
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;
  bool isInit = true;
  TextEditingController _counterNameController = TextEditingController();
  TextEditingController _counterAvatarController = TextEditingController();
  TextEditingController _counterGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
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
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is ProfileError) {
              print('Counter Error...');
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message ?? 'Counter Error.'),
              );
            }

            if (state is ProfileSaved) {
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
            // if (state is ProfileLoaded) {
            //   _nameController.value =
            //       TextEditingValue(text: state.name ?? 'Counter');
            //   _avatarController.value =
            //       TextEditingValue(text: state.avatar ?? 'male');
            // }
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
                        Text(
                          'Settings',
                          style: TextStyle(color: Color(0xff3d7068)),
                        ),
                        GestureDetector(
                            onTap: () {
                              if (Theme.of(context).platform ==
                                  TargetPlatform.iOS) {
                                Share.share(
                                    'Download Smart Dhikr to count, record and monitor your dhikrs on the App Store. #smartdhikrapp https://itunes.apple.com/appid12345567');
                              } else if (Theme.of(context).platform ==
                                  TargetPlatform.android) {
                                Share.share(
                                    'Download Smart Dhikr to count, record and monitor your dhikrs on the Google Play Store. #smartdhikrapp https://play.google.com/store/apps/details?id=com.syahrinseth.thedhikrapp');
                              }
                            },
                            child: Icon(CupertinoIcons.share,
                                color: Color(0xff3d7068)))
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'General',
                                    style: TextStyle(
                                        color: Color(0xff3d7068),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  DhikrListTile(
                                    title: 'Edit Profile',
                                    subtitle:
                                        'Manage your profile informations.',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEdit()),
                                      );
                                    },
                                  ),
                                  BlocBuilder<ProfileBloc, ProfileState>(
                                    bloc: _profileBloc,
                                    builder: (context, state) {
                                      if (state is ProfileLoaded &&
                                          isInit == true) {
                                        _counterGoalController.value =
                                            TextEditingValue(
                                                text: state.counterGoal
                                                        ?.toString() ??
                                                    '100');
                                        _counterNameController.value =
                                            TextEditingValue(
                                                text: state.name ?? '');
                                        _counterAvatarController.value =
                                            TextEditingValue(
                                                text: state.avatar ?? 'male');
                                        isInit = false;
                                      }
                                      return DhikrListTile(
                                        title: 'Dhikr Goal',
                                        subtitle:
                                            'Manage your counter default dhikr goal.',
                                        icon: CupertinoIcons
                                            .gamecontroller_alt_fill,
                                        onTap: () {
                                          showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: Text('Dhikr Goal'),
                                                content: Card(
                                                  color: Colors.transparent,
                                                  elevation: 0.0,
                                                  child: Column(
                                                    children: <Widget>[
                                                      TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _counterGoalController,
                                                        decoration:
                                                            InputDecoration(
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .grey
                                                                    .shade50),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                  ),
                                                  TextButton(
                                                    child: Text('Done'),
                                                    onPressed: () {
                                                      _profileBloc.add(ProfileUpdate(
                                                          name:
                                                              _counterNameController
                                                                  .text,
                                                          avatar:
                                                              _counterAvatarController
                                                                  .text,
                                                          counterGoal:
                                                              _counterGoalController
                                                                  .text));
                                                      return Navigator.of(
                                                              context)
                                                          .pop(true);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Reach Us',
                                    style: TextStyle(
                                        color: Color(0xff3d7068),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  DhikrListTile(
                                    icon: CupertinoIcons.mail,
                                    title: 'Contact Developer',
                                    subtitle:
                                        'Request a feature or ask us anything.',
                                    onTap: () =>
                                        launch('https://syahrinseth.com'),
                                  ),
                                  DhikrListTile(
                                    icon: CupertinoIcons.paintbrush,
                                    subtitle: 'Attribution to the artist.',
                                    title: 'App Avatar Attribution',
                                    onTap: () => launch(
                                        'https://www.flaticon.com/authors/ddara'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Smart Dhikr - Version ${version ?? ''} (${buildNumber ?? ''})',
                  style: TextStyle(
                    color: LightColors.kGreen,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
