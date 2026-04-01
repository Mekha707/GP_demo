import 'package:flutter/material.dart';

class HomeContentAIPowerdmagicWithText extends StatelessWidget {
  const HomeContentAIPowerdmagicWithText({super.key, required this.magicText});
  final String magicText;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome, color: Color(0xff0861dd), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              magicText,
              softWrap: true,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
                letterSpacing: 0.7,
                height: 1.4,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
