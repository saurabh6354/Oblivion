import 'dart:async';
import 'package:flutter/material.dart';

class physicsvisualize extends StatefulWidget {
  const physicsvisualize({Key? key}) : super(key: key);

  @override
  _physicsvisualizeState createState() => _physicsvisualizeState();
}

class _physicsvisualizeState extends State<physicsvisualize> {
  double velocityValue = 0;
  double accelerationValue = 0;

  double ballX = 0;

  // settings
  bool appHasStarted = false;

  // start timer
  void startTimer() {
    appHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      updateVelocity();
      updateAcceleration();
    });
  }

  // velocity
  void updateVelocity() {
    setState(() {
      ballX += velocityValue / 400;
      if (ballX > 1.3) {
        ballX = -1.3;
      } else if (ballX < -1.3) {
        ballX = 1.3;
      }
    });
  }

  // acceleration
  void updateAcceleration() {
    setState(() {
      (velocityValue += accelerationValue / 100).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (appHasStarted == false) {
      startTimer();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MOTION  VISUALIZE',
                        style: TextStyle(
                            decorationColor: Colors.red,
                            fontSize: 40,
                            fontFamily: "opensans",
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[900]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(''),
                      ),
                      Text(''),
                    ],
                  )),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment(ballX, 0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('v = ' + velocityValue.round().toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          // velocity slider
                          Slider(
                            min: 0,
                            max: 8,
                            activeColor: Colors.red,
                            inactiveColor: Colors.grey[400],
                            //label: "$velocityValue",
                            value: (velocityValue + 4) < 8
                                ? (velocityValue + 4)
                                : 8,
                            //divisions: 8,
                            onChanged: (newValue) {
                              setState(() {
                                velocityValue = newValue - 4;
                              });
                            },
                          ),
                          Text(
                            'V E L O C I T Y',
                            style: TextStyle(
                                color: Colors.yellow[400], fontSize: 20),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('a = ' + accelerationValue.round().toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          // acceleration slider
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Slider(
                              min: -1,
                              max: 1,
                              activeColor: Colors.deepPurple[300],
                              inactiveColor: Colors.deepPurple[200],
                              label: "$accelerationValue",
                              value: accelerationValue,
                              divisions: 2,
                              onChanged: (newValue) {
                                setState(() {
                                  accelerationValue = newValue;
                                });
                              },
                            ),
                          ),
                          Text('A C C E L E R A T I O N',
                              style: TextStyle(
                                  color: Colors.yellow[400], fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
