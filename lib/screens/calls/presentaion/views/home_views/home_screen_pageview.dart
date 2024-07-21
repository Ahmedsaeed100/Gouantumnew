import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/Interactive_chat/constants/constants.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/screens/calls/shared/constats.dart';
import 'package:gouantum/widgets/show_toast.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'call_item_view.dart';
import 'user_item_view.dart';

// ignore: must_be_immutable
class HomeScreenPageView extends StatelessWidget {
  final List<UserModel> users;
  final List<CallModel> calls;
  final bool isUsers;
  HomeScreenPageView({
    super.key,
    required this.users,
    required this.calls,
    required this.isUsers,
  });
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (context) {
        return StreamBuilder(
          stream: homeController.streamFeaturedProviders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return const Center(child: Text('something went wrong'));
            }
            List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                (homeController.allContactsSearchKey != "")
                    ? homeController
                        .getCaseInsensitiveUsers(snapshot.data!.docs)
                    : snapshot.data!.docs;

            return ListView.separated(
                itemBuilder: (context, index) {
                  if (isUsers) {
                    return UserItemView(
                      userModel: UserModel.fromJson(
                        data[index].data(),
                      ),
                    );
                  } else {
                    return CallItemView(callModel: calls[index]);
                  }
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: isUsers ? data.length : calls.length);
          },
        );
      },
    );
  }
}

startVideoCall(
    {required receiverID, required context, required isVideo}) async {
  HomeController homeController = Get.put(HomeController());
  var receiver = await FirebaseFirestore.instance
      .collection(FirestoreConstants.userCollection)
      .doc(receiverID)
      .get()
      .then((value) => UserModel.fromJson(value.data()!));
  var receivedMinCost = receiver.callMinuteCast;
  var callerBalance = homeController.user!.myBalance;
  if (callerBalance > receivedMinCost) {
    if (!receiver.busy) {
      await HomeCubit.get(context).fireVideoCall(
        callModel: CallModel(
            id: 'call_${UniqueKey().hashCode.toString()}',
            //callerId: CacheHelper.getString(key: 'uId'),
            callerId: homeController.user!.userUID,
            callerAvatar: homeController.user!.userImage,
            callerName: homeController.user!.name,
            receiverId: receiver.userUID,
            receiverAvatar: receiver.userImage,
            receiverName: receiver.name,
            status: CallStatus.ringing.name,
            createAt: DateTime.now().millisecondsSinceEpoch,
            current: true,
            outCall: receiver.accountStatus == 'Active' ? false : true,
            isVideo: isVideo,
            callMinuteCast: homeController.user!.callMinuteCast),
      );
    } else {
      showToast(msg: 'User is busy');
    }
  } else {
    showToast(msg: 'no balance');
  }
}
