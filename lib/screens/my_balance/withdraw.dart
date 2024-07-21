import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utilities/palette.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  String? gender;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: const Icon(
                FontAwesomeIcons.wallet,
                color: Color(0XFFAAACFF),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 20.0,
              ),
              child: Text(
                'By reaching \$100 in your balance, you can request to withdraw your money via bank transfer to your bank. The process might take up to 30 days after the submission of your withdrawal request.',
                textAlign: TextAlign.center,
              ),
            ),
            const Text('Withdrawal Value:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xfff4f4f4)),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 25)),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.black,
                    )),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {},
                child: const Text('\$ 000'),
              ),
            ),
            Column(
              children: [
                const Text('Withdraw with:'),
                RadioListTile(
                    title: const Text('Bank Account (Egypt)'),
                    value: 'Bank Account (Egypt)',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    }),
                RadioListTile(
                    title: const Text('Vodafone Cash'),
                    value: 'Vodafone Cash',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    })
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all(Size(size.width * .90, 50)),
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(
                      Palette.mainBlueColor,
                    ),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 25)),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.white,
                    )),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {},
                child: const Text('Withdrawal Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
