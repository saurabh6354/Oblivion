import 'package:flutter/material.dart';
import 'physics_visualize.dart';

class information2 extends StatelessWidget {
  const information2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            "assets/images/How_to_play_visualize.png",
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
                            builder: (context) => new physicsvisualize()));
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
