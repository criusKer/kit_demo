import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:kit_demo/pages/main_page/page.dart';
import 'package:kit_demo/pages/splash_page/page.dart';

import 'config/router_conf.dart';

/// create by crius on 2020/7/17
/// email:criusker@163.com
class AppRoute{
  static AbstractRoutes _global;
  static AbstractRoutes get global{
    if (_global == null) {
      _global = PageRoutes(
          pages:<String, Page<Object, dynamic>>{
            Routers.splash: SplashPage(),
            Routers.main: MainPage()
          },

          visitor: (String path, Page<Object, dynamic>page){
            ///Aop
            /// 页面可以有一些私有的 AOP 的增强， 但往往会有一些 AOP 是整个应用下，所有页面都会有的。
            /// 这些公共的通用 AOP ，通过遍历路由页面的形式统一加入。
            page.enhancer.append(

              ///[viewMiddleware] 视图中间件 View Aop
              viewMiddleware: <ViewMiddleware<dynamic>>[
                safetyView<dynamic>(),
              ],

              /// Adapter AOP 适配器切面
              adapterMiddleware: <AdapterMiddleware<dynamic>>[
                safetyAdapter<dynamic>()
              ],

              effectMiddleware: <EffectMiddleware<dynamic>>[
                _pageAnalyticsMiddleware<dynamic>(),
              ],

              /// Store AOP
              middleware: <Middleware<dynamic>>[
                logMiddleware<dynamic>(tag: page.runtimeType.toString()),
              ],

            );
          }
      );
    }
    return _global;
  }
}

Widget createApp(){
  final AbstractRoutes routes = AppRoute.global;
  return MaterialApp(
    title: "KitDemo",
    debugShowCheckedModeBanner: false,
    home: routes.buildPage(Routers.splash, null),
    onGenerateRoute: (RouteSettings settings){
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: routes.buildPage(settings.name, settings.arguments));
      });
    },
  );
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          print('${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}