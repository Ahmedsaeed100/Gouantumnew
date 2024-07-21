import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';

class ItemPostText extends StatefulWidget {
  final String text;
  const ItemPostText({super.key, required this.text});

  @override
  State<ItemPostText> createState() => _ItemPostTextState();
}

class _ItemPostTextState extends State<ItemPostText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        //TO DO: copy text
        Clipboard.setData(ClipboardData(text: widget.text)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied to Clipboard'),
            ),
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReadMoreText(
          widget.text,
          trimLines: 8,
          textAlign: widget.text.characters.first == 'ا' ||
                  widget.text.characters.first == 'أ' ||
                  widget.text.characters.first == 'إ' ||
                  widget.text.characters.first == 'آ' ||
                  widget.text.characters.first == 'ء' ||
                  widget.text.characters.first == 'ؤ' ||
                  widget.text.characters.first == 'ئ' ||
                  widget.text.characters.first == 'ب' ||
                  widget.text.characters.first == 'ت' ||
                  widget.text.characters.first == 'ث' ||
                  widget.text.characters.first == 'ج' ||
                  widget.text.characters.first == 'ح' ||
                  widget.text.characters.first == 'خ' ||
                  widget.text.characters.first == 'د' ||
                  widget.text.characters.first == 'ذ' ||
                  widget.text.characters.first == 'ر' ||
                  widget.text.characters.first == 'ز' ||
                  widget.text.characters.first == 'س' ||
                  widget.text.characters.first == 'ش' ||
                  widget.text.characters.first == 'ص' ||
                  widget.text.characters.first == 'ض' ||
                  widget.text.characters.first == 'ط' ||
                  widget.text.characters.first == 'ظ' ||
                  widget.text.characters.first == 'ع' ||
                  widget.text.characters.first == 'غ' ||
                  widget.text.characters.first == 'ف' ||
                  widget.text.characters.first == 'ق' ||
                  widget.text.characters.first == 'ك' ||
                  widget.text.characters.first == 'ل' ||
                  widget.text.characters.first == 'م' ||
                  widget.text.characters.first == 'ن' ||
                  widget.text.characters.first == 'ه' ||
                  widget.text.characters.first == 'و' ||
                  widget.text.characters.first == 'ي'
              ? TextAlign.right
              : TextAlign.left,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Length,
          trimCollapsedText: '  Show more',
          trimExpandedText: '  Show less',
          delimiterStyle: const TextStyle(
            color: Colors.blueAccent,
            height: 1,
          ),
          lessStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          postDataTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
