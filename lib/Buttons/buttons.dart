import 'package:flutter/material.dart';

class ButtonOfAuth extends StatelessWidget {
  const ButtonOfAuth({
    super.key,
    required this.onPressed,
    required this.fontcolor,
    required this.buttoncolor,
    required this.buttonText,
    this.borderSide,
  });

  // ignore: unused_field
  final VoidCallback? onPressed;
  final Color fontcolor;
  final Color buttoncolor;
  final String buttonText;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double buttonHeight = screenWidth < 600 ? 45 : 55;
    double fontSize = screenWidth < 600 ? 14 : 16;

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttoncolor,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            color: fontcolor,
            fontSize: fontSize,
            fontFamily: 'Agency',
          ),
        ),
      ),
    );
  }
}

class HomeContentPurpuleCardButton extends StatelessWidget {
  const HomeContentPurpuleCardButton({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.onpressed,
    required this.foreColor,
    required this.backColor,
  });

  final VoidCallback onpressed;
  final IconData icon;
  final String buttonText;
  final Color foreColor;
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return SizedBox(
      width: size.width * 0.9,

      height: isTablet ? 56 : 48,
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backColor,
          foregroundColor: foreColor,
          elevation: 2, // إضافة ظل بسيط ليعطي عمقاً
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // ليتقلص المحتوى داخل الزر
            children: [
              Icon(icon, color: foreColor, size: isTablet ? 26 : 20),
              SizedBox(width: isTablet ? 18 : 12),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    buttonText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 14, // حجم الخط يتغير
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
