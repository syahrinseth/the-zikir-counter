import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/home_page.dart';
import 'package:the_zikir_app/state/profile_state.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  ProfileBloc profileBloc = ProfileBloc();
  void _onIntroEnd(context) {
    profileBloc.add(ProfileDoneWelcomeScreen());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/images/screenshot.png',
      fit: BoxFit.cover,
      // height: 200,
      width: 150,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  void initState() {
    super.initState();
    profileBloc.add(ProfileGet());
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        return IntroductionScreen(
          key: introKey,
          nextColor: Color(0xff3d7068),
          skipColor: Color(0xff3d7068),
          doneColor: Color(0xff3d7068),
          globalBackgroundColor: Colors.white,
          globalHeader: Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 0),
                child: Text('Smart Dhikr',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          // globalFooter: SizedBox(
          //   width: double.infinity,
          //   height: 60,
          //   child: ElevatedButton(
          //     child: const Text(
          //       'Let\s go right away!',
          //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          //     ),
          //     onPressed: () => _onIntroEnd(context),
          //   ),
          // ),
          pages: [
            PageViewModel(
              title: "Assalamualaikum,",
              body:
                  "Welcome to Smart Dhikr App, where you can smartly count and monitor your dhikr progress here.",
              image: CircleAvatar(
                backgroundColor: Color(0xff3d7068),
                radius: 80.0,
                child: _buildImage('images/logo.png', 100),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Customizable Dhikr Counter",
              body:
                  "You can customize your counter name, target dhikr, and theme.",
              image: _buildFullscrenImage(),
              decoration: pageDecoration.copyWith(
                contentMargin: const EdgeInsets.symmetric(horizontal: 16),
                fullScreen: false,
                bodyFlex: 2,
                imageFlex: 3,
              ),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          //rtl: true, // Display as right-to-left
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: const EdgeInsets.all(12.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            activeColor: Color(0xff3d7068),
            color: Color(0xff43c59e),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          // dotsContainerDecorator: const ShapeDecoration(
          //   color: Colors.black87,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //   ),
          // ),
        );
      },
    );
  }
}
