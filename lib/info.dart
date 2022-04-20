import 'package:dark_fall2/dark_fall.dart';
import 'package:flutter/material.dart';
import 'main_menu_button.dart';
import 'dark_fall.dart';

class information extends StatelessWidget {
  const information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            "assets/images/How_to_play.png",
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
              ),
              Center(
                child: RaisedButton(
                  elevation: 20,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LightsOutGame()));
                  },
                  child: new Text(
                    "Start Game",
                    style: new TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
