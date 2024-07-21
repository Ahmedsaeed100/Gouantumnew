import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class SearchTextField extends StatelessWidget {
  final Size size;
  final String hintText;
  const SearchTextField({
    super.key,
    required this.size,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {},
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Palette.medGrayColor,
          ),
          suffixIcon: Icon(
            Icons.search,
            size: size.height * 0.035,
          ),
        ),
      ),
    );
  }
}
