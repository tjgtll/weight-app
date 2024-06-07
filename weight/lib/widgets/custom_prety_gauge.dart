import 'dart:math' as math;
import 'package:flutter/material.dart';

class GaugeSegment {
  final String segmentName;

  final double segmentSize;

  final Color segmentColor;

  GaugeSegment(this.segmentName, this.segmentSize, this.segmentColor);
}

class GaugeNeedleClipper extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0.01 * size.height);
    path.lineTo(2 * size.width * 0.5, size.height);
    path.lineTo(0 * size.width * 0.5, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(GaugeNeedleClipper oldClipper) => false;
}

class ArcPainter extends CustomPainter {
  ArcPainter(
      {this.startAngle = 0, this.sweepAngle = 0, this.color = Colors.grey});

  final double startAngle;

  final double sweepAngle;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // final rect = Rect.fromLTRB(size.width * 0.1, size.height * 0.1,
    //     size.width * 0.9, size.height * 0.9);
    final rect = Rect.fromCircle(
        center: size.bottomCenter(Offset.zero), radius: size.shortestSide);
    const useCenter = false;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.6;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class GaugeMarkerPainter extends CustomPainter {
  GaugeMarkerPainter(this.text, this.position, this.textStyle);

  final String text;
  final TextStyle textStyle;
  final Offset position;

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class PrettyGauge extends StatefulWidget {
  final double gaugeSize;

  final List<GaugeSegment>? segments;

  final double minValue;

  final double maxValue;

  final double? currentValue;

  final int currentValueDecimalPlaces;

  final Color needleColor;

  final Color defaultSegmentColor;

  final Widget? valueWidget;

  final Widget? displayWidget;

  final bool showMarkers;

  final TextStyle startMarkerStyle;

  final TextStyle endMarkerStyle;

  @override
  _PrettyGaugeState createState() => _PrettyGaugeState();

  const PrettyGauge(
      {super.key,
      this.gaugeSize = 200,
      this.segments,
      this.minValue = 0,
      this.maxValue = 100.0,
      this.currentValue,
      this.currentValueDecimalPlaces = 1,
      this.needleColor = Colors.black,
      this.defaultSegmentColor = Colors.grey,
      this.valueWidget,
      this.displayWidget,
      this.showMarkers = true,
      this.startMarkerStyle =
          const TextStyle(fontSize: 10, color: Colors.black),
      this.endMarkerStyle =
          const TextStyle(fontSize: 10, color: Colors.black)});
}

class _PrettyGaugeState extends State<PrettyGauge> {
  //This method builds out multiple arcs that make up the Gauge
  //using data supplied in the segments property
  List<Widget> buildGauge(List<GaugeSegment> segments) {
    List<CustomPaint> arcs = [];
    double cumulativeSegmentSize = 0.0;
    double gaugeSpread = widget.maxValue - widget.minValue;

    for (var segment in segments.reversed) {
      arcs.add(
        CustomPaint(
          size: Size(widget.gaugeSize, widget.gaugeSize),
          painter: ArcPainter(
              startAngle: math.pi,
              sweepAngle:
                  ((gaugeSpread - cumulativeSegmentSize) / gaugeSpread) *
                      math.pi,
              color: segment.segmentColor),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + segment.segmentSize;
    }

    return arcs;
  }

  @override
  Widget build(BuildContext context) {
    List<GaugeSegment>? segments = widget.segments;
    double? currentValue = widget.currentValue;
    int currentValueDecimalPlaces = widget.currentValueDecimalPlaces;

    if (widget.currentValue! < widget.minValue) {
      currentValue = widget.minValue;
    }
    if (widget.currentValue! > widget.maxValue) {
      currentValue = widget.maxValue;
    }
    // Make sure the decimal place if supplied meets Darts bounds (0-20)
    if (currentValueDecimalPlaces < 0) {
      currentValueDecimalPlaces = 0;
    }
    if (currentValueDecimalPlaces > 20) {
      currentValueDecimalPlaces = 20;
    }

    if (segments != null) {
      double totalSegmentSize = 0;
      for (var segment in segments) {
        totalSegmentSize = totalSegmentSize + segment.segmentSize;
      }
      if (totalSegmentSize != (widget.maxValue - widget.minValue)) {
        throw Exception('Total segment size must equal (Max Size - Min Size)');
      }
    } else {
      segments = [
        GaugeSegment(
            '', (widget.maxValue - widget.minValue), widget.defaultSegmentColor)
      ];
    }

    return SizedBox(
      height: widget.gaugeSize,
      width: widget.gaugeSize,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          ...buildGauge(segments),
          // widget.showMarkers
          //     ? CustomPaint(
          //         size: Size(widget.gaugeSize, widget.gaugeSize),
          //         painter: GaugeMarkerPainter(widget.minValue.toString(),
          //             Offset(0, widget.gaugeSize), widget.startMarkerStyle))
          //     : Container(),
          // widget.showMarkers
          //     ? CustomPaint(
          //         size: Size(widget.gaugeSize, widget.gaugeSize),
          //         painter: GaugeMarkerPainter(
          //             widget.maxValue.toString(),
          //             Offset(widget.gaugeSize, widget.gaugeSize),
          //             widget.endMarkerStyle))
          //     : Container(),
          Container(
            height: widget.gaugeSize,
            width: widget.gaugeSize,
            alignment: Alignment.bottomCenter,
            child: Transform(
              origin: const Offset(0, 0),
              transform: Matrix4.rotationX(0),
              child: Transform.rotate(
                origin: Offset(0, (widget.gaugeSize / 2)),
                angle: math.pi +
                    (math.pi / 2) +
                    ((currentValue! - widget.minValue) /
                        (widget.maxValue - widget.minValue) *
                        math.pi),
                child: ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: GaugeNeedleClipper(),
                  child: Container(
                    alignment: AlignmentDirectional.topStart,
                    width: widget.gaugeSize,
                    height: widget.gaugeSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.gaugeSize,
            width: widget.gaugeSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.displayWidget ?? Container(),
                widget.valueWidget ??
                    Text(
                        currentValue.toStringAsFixed(currentValueDecimalPlaces),
                        style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
            width: 100,
          ),
        ],
      ),
    );
  }
}
