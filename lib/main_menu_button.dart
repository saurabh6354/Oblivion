import 'package:dark_fall2/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenuButton extends StatefulWidget {
  final String text;
  final Function() onTap;

  MainMenuButton(
    Key key,
    this.text,
    this.onTap,
  ) : super(key: key);

  @override
  _MainMenuButtonState createState() => _MainMenuButtonState();
}

class _MainMenuButtonState extends State<MainMenuButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          gradient: MainTheme.mainButtonGradient,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.cinzel(
              textStyle: TextStyle(
                color: MainTheme.lightTextColor,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
