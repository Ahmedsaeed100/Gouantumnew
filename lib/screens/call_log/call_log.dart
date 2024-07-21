// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gouantam/utilities/palette.dart';
// import 'package:gouantam/widgets/widgets.dart';

// import '../../model/users.dart';
// import '../home/home_controller.dart';

// class CallLog extends StatefulWidget {
//   const CallLog({super.key});

//   @override
//   State<CallLog> createState() => _CallLogState();
// }

// class _CallLogState extends State<CallLog> {
//   HomeController controller = Get.put(HomeController());
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return GetBuilder<HomeController>(
//         init: controller,
//         builder: (controller) {
//           print('reload');
//           return StreamBuilder(
//               stream: controller.allContactsStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.data == null) {
//                   return const Center(child: Text('something went wrong'));
//                 }
//                 List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
//                     snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const ClampingScrollPhysics(),
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     var user = UserModel.fromJson(data[index].data());
//                     return Flex(
//                       direction: Axis.horizontal,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             margin: EdgeInsets.symmetric(
//                               vertical: size.height * 0.02,
//                               horizontal: size.width * 0.02,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     UserCircleImage(
//                                       size: size,
//                                       image: user.userImage,
//                                       borderColor: Palette.greenColor,
//                                       userStateColor: Palette.greenColor,
//                                       imageCircalSize: size.height * 0.027,
//                                     ),
//                                     SizedBox(
//                                       width: size.width * 0.02,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               user.name,
//                                               style: TextStyle(
//                                                 fontSize: size.height * 0.025,
//                                                 fontFamily: "Helvetica",
//                                               ),
//                                             ),
//                                             SizedBox(width: size.width * 0.015),
//                                             const Icon(
//                                               Icons.favorite,
//                                               color: Colors.red,
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(height: size.height * 0.01),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "2:13 min |",
//                                               style: TextStyle(
//                                                 fontSize: size.height * 0.015,
//                                                 color: Colors.grey,
//                                                 fontFamily: "Helvetica",
//                                               ),
//                                             ),
//                                             SizedBox(width: size.width * 0.02),
//                                             Text(
//                                               "Yesterday  |",
//                                               style: TextStyle(
//                                                 fontSize: size.height * 0.015,
//                                                 color: Colors.grey,
//                                                 fontFamily: "Helvetica",
//                                               ),
//                                             ),
//                                             SizedBox(width: size.width * 0.02),
//                                             Text(
//                                               "\$0.10",
//                                               style: TextStyle(
//                                                 fontSize: size.height * 0.017,
//                                                 color: Palette.greenColor,
//                                                 fontFamily: "Helvetica",
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     // print("calllllllllll");
//                                   },
//                                   icon: Icon(
//                                     Icons.call,
//                                     size: size.height * 0.035,
//                                     color: Palette.mainBlueColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               });
//         });
//   }
// }
