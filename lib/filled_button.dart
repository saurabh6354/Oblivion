import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dark_fall2/themes.dart';

class FilledButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;

  const FilledButton({Key? key, @required this.text, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            text ?? ''.toUpperCase(),
            style: GoogleFonts.bebasNeue(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        height: 50,
        decoration: BoxDecoration(
          gradient: MainTheme.mainButtonGradient,
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
      ),
    );
  }
}
