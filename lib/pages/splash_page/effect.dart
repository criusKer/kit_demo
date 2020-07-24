import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:kit_demo/config/router_conf.dart';
import 'action.dart';
import 'state.dart';

Effect<SplashState> buildEffect() {
  return combineEffects(<Object, Effect<SplashState>>{
    SplashAction.action: _onAction,
    Lifecycle.initState: _init
  });
}

void _init(Action action, Context<SplashState> ctx) async {
  await Future.delayed(const Duration(milliseconds: 1000), () {
    Navigator.of(ctx.context).pushReplacementNamed(Routers.main);
  });
}
void _onAction(Action action, Context<SplashState> ctx) {
}
