import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

class UploadingVideo extends StatefulWidget {
  const UploadingVideo({super.key});

  @override
  State<UploadingVideo> createState() => _UploadingVideoState();
}

class _UploadingVideoState extends State<UploadingVideo> {
  int _groupValue = 0;
  final bool _isUploaded = true;

  final TextEditingController theController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: SizedBox(
          height: size.height * 0.05,
          width: size.width * 0.91,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isUploaded ? Palette.mainBlueColor : Palette.medGrayColor,
              elevation: 0,
              textStyle: TextStyle(
                fontFamily: "Helvetica",
                fontSize: size.width * 0.05,
              ),
              fixedSize: size,
            ),
            onPressed: () {},
            child: const Text(
              "Continue",
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Upload Video",
            style: TextStyle(
              fontSize: size.width * 0.042,
              fontFamily: 'inter',
            ),
          ),
          centerTitle: true,
          foregroundColor: Palette.darkGrayColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.03),
                  height: size.height * 0.22,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Palette.mainBlueColor.withOpacity(0.1),
                      border: Border.all(
                        color: Palette.mainBlueColor,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        size: size.height * 0.05,
                        color: Palette.mainBlueColor,
                      ),
                      Text(
                        "Upload Video",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontFamily: 'inter',
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "Browse",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: size.width * 0.04,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.09,
                  decoration: BoxDecoration(
                    color: Palette.medGrayColor.withOpacity(0.2),
                    border: Border.all(
                      color: Palette.darkGrayColor.withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: size.width * 0.01,
                      left: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Uploading",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    fontFamily: 'inter',
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "68 % - 12 Seconds left",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    color: Colors.grey,
                                    fontFamily: 'inter',
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.highlight_off,
                                size: size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            right: size.width * 0.05,
                            top: size.height * 0.005,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white,
                              value: 10,
                              color: Palette.mainBlueColor,
                              minHeight: size.height * 0.007,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed",
                  style: TextStyle(
                    fontSize: size.width * 0.037,
                    fontFamily: 'inter',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Palette.mainBlueColor,
                          value: 0,
                          groupValue: _groupValue,
                          onChanged: (val) {
                            setState(
                              () {
                                _groupValue = val as int;
                              },
                            );
                          },
                        ),
                        Text(
                          "One time",
                          style: TextStyle(
                            fontSize: size.width * 0.037,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Palette.mainBlueColor,
                          value: 1,
                          groupValue: _groupValue,
                          onChanged: (val) {
                            setState(
                              () {
                                _groupValue = val as int;
                              },
                            );
                          },
                        ),
                        Text(
                          "Monthly rental \$0.5",
                          style: TextStyle(
                            fontSize: size.width * 0.037,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      "Add a title",
                      style: TextStyle(
                        fontSize: size.width * 0.037,
                        fontFamily: 'inter',
                      ),
                    ),
                    MytextField(
                      theController: theController,
                      onsave: (value) {},
                      validator: (value) {
                        return;
                      },
                      hintText: 'Your title here',
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      "Your video pricing per minute",
                      style: TextStyle(
                        fontSize: size.width * 0.037,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    MytextField(
                      theController: theController,
                      onsave: (value) {},
                      validator: (value) {
                        return;
                      },
                      hintText: '\$ 5.0',
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
