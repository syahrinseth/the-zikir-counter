import 'package:flutter/material.dart';
import 'package:the_zikir_app/state/profile_state.dart';

class GlobalVar {
  final String avatarFemaleAttr =
      '<div>Icons made by <a href="https://www.flaticon.com/authors/ddara" title="dDara">dDara</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>';
  final String avatarMaleAttr =
      '<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>';
  static final List<Map> dhikrNames = [
    {'name': 'Dhikr Counter', 'translate': ''},
    {'name': 'Allahu Akbar', 'translate': 'Allah is The Greatest'},
    {'name': 'Alhamdulillah', 'translate': 'Praise be to Allah'},
    {'name': 'Subhan Allah', 'translate': 'Glory be to Allah'},
    {
      'name': 'La ilaha illa Allah',
      'translate': 'There is no god except Allah'
    },
  ];

  // static String homeBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test
  // static String menuBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test
  // static String counterBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test
  // static String counterEditBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test
  // static String profileEditBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test
  // static String historyBannerAdId =
  //     "ca-app-pub-3940256099942544/6300978111"; // test

  // static String homeBannerAdId =
  //     "ca-app-pub-7782324487799920/5930999559"; // prod
  // static String menuBannerAdId =
  //     "ca-app-pub-7782324487799920/6465215978"; // prod
  // static String counterBannerAdId =
  //     "ca-app-pub-7782324487799920/3647480942"; // prod
  // static String counterEditBannerAdId =
  //     "ca-app-pub-7782324487799920/3072765873"; // prod
  // static String profileEditBannerAdId =
  //     "ca-app-pub-7782324487799920/6820439195"; // prod
  // static String historyBannerAdId =
  //     "ca-app-pub-7782324487799920/1568112517"; // prod
}
