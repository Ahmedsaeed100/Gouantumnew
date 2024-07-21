// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/call/call_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_state.dart';
import 'package:gouantum/screens/calls/presentaion/screens/call_screen.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/widgets/show_toast.dart';
import 'package:gouantum/screens/home/home_screen.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_plus/share_plus.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  // int index = 0;
  final pages = [
    const AppHomeScreen(),
    const AllContacts(),
    const ChatContacts(),
    const AllCallsLog(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    firstState();
    // debugPrint('UserIdIs: ${CacheHelper.getString(key: 'uId')}');
    Future.delayed(const Duration(milliseconds: 500), () {
      checkInComingTerminatedCall();
    });
  }

  @mustCallSuper
  @protected
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkInComingTerminatedCall() async {
    if (CacheHelper.getString(key: 'terminateIncomingCallData').isNotEmpty) {
      //if there is a terminated call
      Map<String, dynamic> callMap =
          jsonDecode(CacheHelper.getString(key: 'terminateIncomingCallData'));
      await CacheHelper.removeData(key: 'terminateIncomingCallData');
      CallModel callModel = CallModel.fromJson(callMap);

      ///this for terminated accept so listener will navigate
      if (callModel.outCall && callModel.acceptOut == null) {
        ///now we could handel accept button in background so we don't need this solution
        // await FirebaseFirestore.instance
        //     .collection(FirestoreConstants.callsCollection)
        //     .doc(callModel.id)
        //     .update({'acceptOut': true});
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
                create: (_) => CallCubit(),
                child: CallScreen(
                  isReceiver: true,
                  callModel: callModel,
                ));
          },
        ));
      }
    }
  }

  HomeController homeController = Get.put(HomeController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ///online user
      userState('Active');
    } else {
      ///offline user
      userState('Nonactive');
    }
    if (state == AppLifecycleState.inactive) {
      ///offline user
      userState('Nonactive');
    }
  }

  void userState(String userStatus) async {
    await homeController.firestore
        .collection("_users")
        .doc(homeController.auth.currentUser?.uid)
        .update(userStatus != "Active"
            ? {'accountStatus': userStatus, 'busy': false}
            : {'accountStatus': userStatus});
  }

  void firstState() async {
    await homeController.firestore
        .collection("_users")
        .doc(homeController.auth.currentUser?.uid)
        .update({'accountStatus': "Active", 'busy': false});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    final TextEditingController postShareController = TextEditingController();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        //GetUserData States
        if (state is ErrorGetUsersState) {
          showToast(msg: state.message);
        }
        if (state is ErrorGetCallHistoryState) {
          //  showToast(msg: state.message);
        }
        //FireCall States
        if (state is ErrorFireVideoCallState) {
          // showToast(msg: state.message);
        }
        if (state is ErrorPostCallToFirestoreState) {
          showToast(msg: state.message);
        }
        if (state is ErrorUpdateUserBusyStatus) {
          showToast(msg: state.message);
        }
        if (state is SuccessFireVideoCallState) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) {
              return BlocProvider(
                create: (_) => CallCubit(),
                child: CallScreen(
                  isReceiver: false,
                  callModel: state.callModel,
                ),
              );
            },
          ));
        }

        //Receiver Call States
        if (state is SuccessInComingCallState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return BlocProvider(
                  create: (_) => CallCubit(),
                  child: CallScreen(
                    isReceiver: true,
                    callModel: state.callModel,
                  ),
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        var homeCubit = HomeCubit.get(context);
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: Visibility(
            // to hide floating Action Button when keyboard appears
            visible: !showFab,
            child: SizedBox(
              height: size.height * 0.085,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: size.height * 0.23,
                          margin: EdgeInsets.symmetric(
                            vertical: size.height * 0.05,
                            horizontal: size.width * 0.05,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Who would you like to invite?',
                                style: TextStyle(fontSize: size.height * 0.025),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    shareMethod(
                                      context,
                                      size,
                                      postShareController,
                                    );
                                  },
                                  child: Text(
                                    "Invite My Clients",
                                    style: TextStyle(
                                      fontSize: size.height * 0.022,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    shareMethod(
                                      context,
                                      size,
                                      postShareController,
                                    );
                                  },
                                  child: Text(
                                    "Invite A Provider",
                                    style: TextStyle(
                                      fontSize: size.height * 0.022,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  backgroundColor: const Color(0xff10466b),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      Text(
                        'invite',
                        style: TextStyle(
                          fontSize: size.width * 0.022,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: MyBottomTabBar(
            index: homeCubit.index,
            onChangeTab: (value) => homeCubit.onChangeTab(value),
          ),
          body: ModalProgressHUD(
            inAsyncCall: homeCubit.fireCallLoading,
            child: pages[homeCubit.index],
          ),
        ));
      },
    );
  }

  Future<dynamic> shareMethod(BuildContext context, Size size,
      TextEditingController postShareController) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.02, horizontal: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite Message',
                  style: TextStyle(fontSize: size.height * 0.025),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Enter the invite message to share',
                  style: TextStyle(fontSize: size.height * 0.02),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: postShareController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: size.height * 0.02),
                    hintText:
                        'Dear Gents Now you can call me\ndirectly through Gouantum.',
                    hintStyle: TextStyle(fontSize: size.width * 0.04),
                  ),
                  maxLines: 6,
                ),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(size.height * 0.05),
                  ),
                  child: const Text('Share'),
                  onPressed: () {
                    Share.share('check out my website https://example.com',
                        subject: 'Look what I made!');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
