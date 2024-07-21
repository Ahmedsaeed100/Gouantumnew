import 'package:flutter/material.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/utilities/palette.dart';

class UsersListSearch extends StatelessWidget {
  final UserModel? user;
  final Size size;

  const UsersListSearch({
    super.key,
    required this.size,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.004,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  user!.userImage,
                  height: size.height * 0.05,
                  width: size.width * 0.12,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: size.width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.name,
                      style: TextStyle(
                        fontSize: size.height * 0.024,
                        fontFamily: "Helvetica",
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    const Text(
                      'IT Team leader',
                      style: TextStyle(
                        fontFamily: "Helvetica",
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.005,
                        vertical: size.height * 0.005,
                      ),
                      child: Row(
                        children: [
                          Container(
                            color: Colors.red,
                            child: Image.asset(
                              'assets/img/egypt.png',
                              fit: BoxFit.cover,
                              height: size.height * 0.02,
                              width: size.width * 0.04,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          const Text("⭐⭐⭐⭐"),
                          SizedBox(width: size.width * 0.02),
                          const Text(
                            '3.5',
                            style: TextStyle(
                              color: Palette.medGrayColor,
                              fontFamily: "Helvetica",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '\$5.4 / Minute - \$0.5 / live',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Palette.medGrayColor,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // FollowAndUnfollowButton(size: size, user:current ),
        ],
      ),
    );
  }
}
