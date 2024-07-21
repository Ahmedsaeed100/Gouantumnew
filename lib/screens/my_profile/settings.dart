// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gouantum/screens/login/login.dart';

import 'reset_password.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.size,
  });
  final Size size;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _switchVal = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.size.height * 0.01,
        horizontal: widget.size.width * 0.05,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.size.height * 0.02,
              horizontal: widget.size.width * 0.02,
            ),
            child: TextButton(
              style: ButtonStyle(
                elevation: WidgetStateProperty.all(0),
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xfff4f4f4)),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                    horizontal: widget.size.width * 0.25, vertical: 18)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Copy profile link',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: widget.size.width * 0.03,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.voice_over_off,
                    color: Color(0xff405fe6),
                  ),
                  SizedBox(width: widget.size.width * 0.05),
                  const Text('Offline Mode'),
                ],
              ),
              Switch.adaptive(
                activeColor: const Color(0xff405fe6),
                value: _switchVal,
                onChanged: (val) {
                  setState(
                    () {
                      _switchVal = val;
                    },
                  );
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.size.height * 0.02,
              horizontal: widget.size.width * 0.001,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.block,
                      color: Color(0xff405fe6),
                    ),
                    SizedBox(width: widget.size.width * 0.05),
                    const Text('Blocked List'),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff405fe6),
                  size: 18,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const RestPassword());
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: widget.size.height * 0.02,
                horizontal: widget.size.width * 0.001,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.security,
                        color: Color(0xff405fe6),
                      ),
                      SizedBox(width: widget.size.width * 0.05),
                      const Text('Change Password'),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff405fe6),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginScreen());
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: widget.size.height * 0.02,
                horizontal: widget.size.width * 0.001,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Color(0xff405fe6),
                      ),
                      SizedBox(width: widget.size.width * 0.05),
                      const Text('Offline Mode'),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xfff405fe6),
                    size: 18,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}