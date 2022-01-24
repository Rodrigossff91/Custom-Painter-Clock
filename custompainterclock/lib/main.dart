import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Teste",
        home: Container(
            color: Color(0xFFFAFF00),
            alignment: Alignment.center,
            child: ClockView()));
  }
}

class ClockView extends StatefulWidget {
  const ClockView({
    Key? key,
  }) : super(key: key);

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void setState(VoidCallback fn) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAFF00),
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    /// Ponto de partida e radio do circulo
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    // Circulo front
    var darkCircle = Paint()..color = Colors.red;

    // Circulo back
    var whiteCircle = Paint()
      ..color = Colors.black
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;

    // Circulo central
    var whiteCircleCenter = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // Linha Segundos
    var handSec = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    // Linha minutos
    var handMinut = Paint()
      ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.blue])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    // Linha horas
    var handHours = Paint()
      ..shader = const RadialGradient(colors: [Colors.yellow, Colors.green])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    // Linhas
    var dashBrush = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    // Desenhar Circulos
    canvas.drawCircle(center, radius - 40, whiteCircle);
    canvas.drawCircle(center, radius - 40, darkCircle);
    canvas.drawCircle(center, 10, whiteCircleCenter);

    //  Posição da linha segundo
    var positionHandSecX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var positionHandSecY = centerX + 80 * sin(dateTime.second * 6 * pi / 180);

    // Desenhar Linha
    canvas.drawLine(
        center, Offset(positionHandSecX, positionHandSecY), handSec);

    //  Posição da linha minuto
    var positionHandMinX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    var positionHandMinY = centerX + 80 * sin(dateTime.minute * 6 * pi / 180);

    // Desenhar Linha
    canvas.drawLine(
        center, Offset(positionHandMinX, positionHandMinY), handMinut);

    //  Posição da linha horas
    var positionHandHoursX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var positionHandHoursY = centerX +
        60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    // Desenhar Linha
    canvas.drawLine(
        center, Offset(positionHandHoursX, positionHandHoursY), handHours);

    // Raio das linhas desenhadas
    var outerCircleRadius = radius;
    // Tamanho das linhas desenhadas
    var innerCircleRadius = radius - 14;

    // Quantidades de linhas desenhadas
    for (var i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);

      // Desenhar Linhas
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
