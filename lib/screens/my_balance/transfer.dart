import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/palette.dart';
import '../../widgets/my_buttons.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            FontAwesomeIcons.moneyBillTransfer,
            color: Color(0XFFAAACFF),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          child: Text(
            'To transfer an amount of your balance to one of your contacts, please enter an integer value in USD within the range (Min \$5 - Max ',
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          child: Text('Transfer Value '),
        ),
        TextButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(const Color(0xfff4f4f4)),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 25)),
              textStyle: WidgetStateProperty.all(const TextStyle(
                color: Colors.black,
              )),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: () {},
          child: const Text('\$ 00',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
        const SizedBox(height: 20),
        MyButtons(
          width: .90,
          color: Palette.mainBlueColor,
          text: 'Choose Contact',
          onPressed: () {},
        )
      ],
    );
  }
}
