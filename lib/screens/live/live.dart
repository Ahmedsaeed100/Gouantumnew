import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class Live extends StatelessWidget {
  const Live({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/img/logo/testImage/liveImageTest.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: size.height * 0.02,
              left: size.width * 0.01,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.037,
                    width: size.width * 0.3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Image of User Make Live
                        CircleAvatar(
                          radius: size.height * 0.015,
                          backgroundImage: const ExactAssetImage(
                            "assets/img/logo/testImage/user.png",
                          ),
                        ),
                        // UserName of User Make Live
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Container(
                    height: size.height * 0.037,
                    width: size.width * 0.14,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: size.width * 0.03),
                        const Text("⭐"),
                        const Text(
                          '12',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: size.width * 0.2),
                  Container(
                    height: size.height * 0.037,
                    width: size.width * 0.25,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    // number of who watching Live
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          '13,789',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.1,
                decoration: const BoxDecoration(
                  gradient: Palette.myLinearGradientTow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: size.height * 0.055,
                      width: size.width * 0.57,
                      decoration: const BoxDecoration(
                        gradient: Palette.myLinearGradientOne,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey[600],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF0000),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          "End live",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
