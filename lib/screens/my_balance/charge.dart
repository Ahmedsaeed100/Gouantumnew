import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Charge extends StatefulWidget {
  const Charge({super.key});

  @override
  State<Charge> createState() => _ChargeState();
}

class _ChargeState extends State<Charge> {
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.wallet,
                color: Color(0XFFAAACFF),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'To charge your balance, please enter an integer value in USD within the range (Min \$5 - Max \$999)',
                textAlign: TextAlign.center,
              ),
            ),
            const Text('Your Charge Value:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: ButtonStyle(
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xfff4f4f4)),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 25)),
                    textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.black,
                    )),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () {},
                child: const Text(
                  '\$ 000',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text('Deposit by:'),
                ),
                RadioListTile(
                    title: const Text('Fawry'),
                    value: 'Fawry',
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
                    }),
                RadioListTile(
                    title: const Text('Paymob'),
                    value: 'Paymob',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
