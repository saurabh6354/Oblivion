import 'package:dark_fall2/viewer.dart';
import 'package:funvas/funvas.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/animation.dart';

class animation extends StatelessWidget {
  const animation({Key? key}) : super(key: key);

  /// List of example funvas implementations.
  static final examples = <Funvas>[
    ExampleFunvas(),
    WaveFunvas(),
    OrbsFunvas(),
    Fifteen(),
    Sixteen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Center(child: const Text('Random animation')),
        ),
        body: FunvasViewer(
          funvases: examples,
        ),
      ),
    );
  }
}

/// Example implementation of a funvas.
///
/// It uses a very simple [Canvas.drawCircle] operation to create an animation.
class ExampleFunvas extends Funvas {
  @override
  void u(double t) {
    c.drawCircle(
      Offset(x.width / 2, x.height / 2),
      S(t).abs() * x.height / 4 + 42,
      Paint()..color = R(C(t) * 255, 42, 60 + T(t)),
    );
  }
}

/// Funvas adapted 1:1 from https://www.dwitter.net/d/3713.
class WaveFunvas extends Funvas {
  @override
  void u(double t) {
    c.scale(x.width / 1920, x.height / 1080);

    for (var i = 0; i < 64; i++) {
      c.drawRect(
        Rect.fromLTWH(
          i * 30.0,
          400 + C(4 * t + (i * 3)) * 100,
          27,
          200,
        ),
        Paint(),
      );
    }
  }
}

class Fifteen extends Funvas {
  static const _depth = 11;
  late double _angle;

  @override
  void u(double t) {
    c.drawPaint(Paint()..color = const Color(0xfff0d9b5));

    _angle = pi / 2 * _cochleoidX(-pi + 2 * pi * (t % 5) / 5);

    final s = s2q(750), d = s.width;
    _branch(d / 2, Offset(d / 2, d), 0, _depth);
  }

  double _cochleoidX(double t) {
    if (t == 0) return 1;
    return (sin(t) * cos(t)) / t;
  }

  void _branch(double d1, Offset p1, double angle, int depth) {
    if (depth == 0) return;
    // Half branch distance.
    final d2 = d1 * 2 / 3;
    final p2 = Offset(
      p1.dx + sin(angle) * d2,
      p1.dy - cos(angle) * d2,
    );
    // Stroke based on depth.
    final paint = Paint()
      ..color = const Color(0xddb58863)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = depth / _depth * 6;
    c.drawLine(p1, p2, paint);

    // Branch left.
    _branch(d2, p2, angle - _angle, depth - 1);
    // Branch right.
    _branch(d2, p2, angle + _angle, depth - 1);
  }
}

/// Funvas adapted 1:1 from https://www.dwitter.net/d/4342.
class OrbsFunvas extends Funvas {
  @override
  void u(double t) {
    c.scale(x.width / 1920, x.height / 1080);

    final v = t + 400;
    for (var q = 255; q > 0; q--) {
      final paint = Paint()..color = R(q, q, q);
      c.drawCircle(
          Offset(
            1920 / 2 + C(v - q) * (v + q),
            540 + S(v - q) * (v - q),
          ),
          40,
          paint);
    }
  }
}

class Sixteen extends Funvas {
  @override
  void u(double t) {
    c.drawPaint(Paint()..color = const Color(0xff333333));
    final d = s2q(750).width;

    const cube = [
      _Vertex3(-1 / 2, -1 / 2, -1 / 2),
      _Vertex3(-1 / 2, -1 / 2, 1 / 2),
      _Vertex3(1 / 2, -1 / 2, 1 / 2),
      _Vertex3(1 / 2, -1 / 2, -1 / 2),
      _Vertex3(1 / 2, 1 / 2, -1 / 2),
      _Vertex3(1 / 2, 1 / 2, 1 / 2),
      _Vertex3(-1 / 2, 1 / 2, 1 / 2),
      _Vertex3(1 / 2, 1 / 2, 1 / 2),
      _Vertex3(1 / 2, -1 / 2, 1 / 2),
      _Vertex3(-1 / 2, -1 / 2, 1 / 2),
      _Vertex3(-1 / 2, 1 / 2, 1 / 2),
      _Vertex3(-1 / 2, 1 / 2, -1 / 2),
      _Vertex3(1 / 2, 1 / 2, -1 / 2),
      _Vertex3(1 / 2, -1 / 2, -1 / 2),
      _Vertex3(-1 / 2, -1 / 2, -1 / 2),
      _Vertex3(-1 / 2, 1 / 2, -1 / 2),
    ];

    const camera = _Vertex3(0, 0, -3);
    final f = sqrt(pow(camera.x, 2) + pow(camera.y, 2) + pow(camera.z, 2));

    final slowedT = t / 5;
    final sectionedT = slowedT % 2 ~/ 1;

    Offset transform(_Vertex3 vertex) {
      final transformed = Offset(
        ((vertex.x - camera.x) * (f / (vertex.z - camera.z))) + camera.x,
        ((vertex.y - camera.y) * (f / (vertex.z - camera.z))) + camera.y,
      );
      return transformed * d / 2 + Offset(d / 2, d / 2);
    }

    _Vertex3 rotate(_Vertex3 vertex) {
      final radians = Curves.fastOutSlowIn.transform(slowedT % 1) * 2 * pi;
      final _Vertex3 preRotated;
      switch (sectionedT) {
        case 0:
          preRotated = _Vertex3(
            vertex.x * cos(radians) + vertex.z * sin(radians),
            vertex.y,
            -vertex.x * sin(radians) + vertex.z * cos(radians),
          );
          break;
        case 1:
          preRotated = _Vertex3(
            vertex.x,
            vertex.y * cos(radians) - vertex.z * sin(radians),
            vertex.y * sin(radians) + vertex.z * cos(radians),
          );
          break;
        default:
          throw UnimplementedError();
      }
      return _Vertex3(
        preRotated.x * cos(radians) - preRotated.y * sin(radians),
        preRotated.x * sin(radians) + preRotated.y * cos(radians),
        preRotated.z,
      );
    }

    final transformedCube = cube.map(rotate).map(transform).toList();
    for (var i = 0; i < transformedCube.length - 1; i++) {
      final p1 = transformedCube[i];
      final p2 = transformedCube[i + 1];
      c.drawLine(
        p1,
        p2,
        Paint()
          ..color = Color(0xffffffff).withRed(i * 222 ~/ transformedCube.length)
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}

class _Vertex3 {
  const _Vertex3(this.x, this.y, this.z);

  final double x, y, z;
}
