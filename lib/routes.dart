import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/call/call_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/screens/call_screen.dart';
import 'package:gouantum/screens/calls/shared/constats.dart';

import 'screens/main_screen/main_screen.dart';
import 'screens/calls/data/models/call_model.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) {
            return const MainScreen();
          },
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) {
            return const MainScreen();
          },
        );

      case callScreen:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        final isReceiver = args[0] as bool;
        final callModel = args[1] as CallModel;
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
                create: (_) => CallCubit(),
                child:
                    CallScreen(isReceiver: isReceiver, callModel: callModel));
          },
        );
    }
    return null;
  }
}
