import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:kit_demo/config/res_conf.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(SplashState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    child: Image.asset(ResConf.splashBg,fit: BoxFit.fill),
  );
}
