import 'package:get/get.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/screens/transactions/transactions.dart';

import '../screens/main_screen/main_screen.dart';

// Routing Using Getx Route
class RoutesClass {
  static String home = "/home/main_screen.dart";
  static String splash = '/login/splash.dart';
  static String login = '/login/login.dart';
  static String forgetPassword = '/login/forget_password.dart';
  static String otp = '/login/otp.dart';
  static String setnewpassword = '/login/set_new_password.dart';

  static String signupone = '/signup/signup_one.dart';
  static String signupTow = '/signup/signup_tow.dart';
  static String signupThree = '/signup/signup_three.dart';

  static String myprofile = '/my_profile/my_profile.dart';
  static String minutepricing = '/my_profile/minute_pricing.dart';

  static String calllog = '/call_log/call_log.dart';
  static String contacts = '/Contacts/all_contacts.dart';
  static String chat = '/Interactive_chat/chat.dart';
  static String live = '/live/live.dart';
  static String search = '/screens/search/search.dart';
  static String transactions = '/screens/transactions/transactions.dart';

  static String notifications = "/notifications/notifications.dart";

//
////
  static String getHomeRoute() => home;
  static String getSplachRoute() => splash;
  static String getLoginRoute() => login;
  static String getForgetpasswordRoute() => forgetPassword;
  static String getOTPRoute() => otp;
  static String getSetNewPasswordRoute() => setnewpassword;
//
  static String getSinUpOneRoute() => signupone;
  static String getSignupTowRoute() => signupTow;
  static String getsignupThreeRoute() => signupThree;
//
  static String getMyProfileRoute() => myprofile;
  static String getMinutePricingRoute() => minutepricing;

  static String getCallLogRoute() => calllog;
  static String getContactsRoute() => contacts;
  static String getChatRoute() => chat;
  static String getliveRoute() => live;
  static String getSearchRoute() => search;
  static String getTransactionsRoute() => transactions;

  static String getNotificationsRoute() => notifications;

  // ignore: prefer_typing_uninitialized_variables
  static var arguments;

  //// Pages Route
  static List<GetPage> routes = [
    GetPage(
      page: () => const MainScreen(),
      name: home,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const GouantumSplash(),
      name: splash,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => LoginScreen(),
      //binding: LoginScreenBinding(),
      name: login,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const ForgetPassword(),
      name: forgetPassword,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const OTP(),
      name: otp,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const SetNewPassword(),
      name: setnewpassword,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    //
    GetPage(
      page: () => const SignupOne(),
      name: signupone,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => SignupTow(),
      name: signupTow,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const SignupThree(),
      name: signupThree,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const Search(),
      name: search,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    //
    GetPage(
      page: () => const MyProfile(),
      name: myprofile,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => MinutePricing(),
      name: minutepricing,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      page: () => const AllContacts(),
      name: contacts,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => ChatPage(arguments: arguments),
      name: chat,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const Live(),
      name: live,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const Search(),
      name: search,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      page: () => const Transactions(),
      name: transactions,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
// Notifications
    GetPage(
      page: () => const Notifications(),
      name: notifications,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
