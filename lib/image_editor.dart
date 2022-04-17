import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:tap_canvas/tap_canvas.dart';

class ResizebleWidget extends StatefulWidget {
  const ResizebleWidget({required this.image});

  final FileImage image;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

const ballDiameter = 30.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  double height = 0.0;
  double width = 200.0;
  double heightToWidthRatio = 1;
  late FileImage image;
  double maxWidth = 50;
  bool firstRun = true;
  bool _isEditing = true;

  @override
  void initState() {
    image = widget.image;

    ResizeImage res =
        ResizeImage(image, width: width.round(), allowUpscaling: true);

    if ((res.width != null && res.height != null)) {
      width = res.width!.toDouble();
      height = res.height!.toDouble();
    } else {
      getDimensions(res);
    }

    heightToWidthRatio = height / width;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      maxWidth = MediaQuery.of(context).size.width - ballDiameter - 30;
      firstRun = false;
    }
    return TapOutsideDetectorWidget(
        onTappedOutside: () {
          if (_isEditing) {
            setState(() {
              _isEditing = false;
            });
          }
        },
        onTappedInside: () {
          if (!_isEditing) {
            setState(() {
              _isEditing = true;
            });
          }
        },
        child: SizedBox(
            width: width + ballDiameter,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Image(
                    image: ResizeImage(widget.image,
                        width: width.round(), allowUpscaling: true)),
                SizedBox(
                  height: height,
                  child: Visibility(
                    visible: _isEditing,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ManipulatingBall(
                            onDrag: (dx, dy) {
                              var newWidth = width - 2 * dx;
                              setNewWidth(newWidth);
                            },
                          ),
                          SizedBox(
                            width: width - ballDiameter,
                          ),
                          ManipulatingBall(
                            onDrag: (dx, dy) {
                              var newWidth = width + 2 * dx;
                              setNewWidth(newWidth);
                            },
                          ),
                        ]),
                  ),
                ),
              ],
            )));
  }

  void setNewWidth(double newWidth) {
    if (newWidth < 50) {
      newWidth = 50;
    } else if (newWidth > maxWidth) {
      newWidth = maxWidth;
    } else {
      width = newWidth;
    }
    height = width * heightToWidthRatio;
    setState(() {});
  }

  Future<void> getDimensions(ResizeImage image) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    setState(() {
      width = info.width.toDouble();
      height = info.height.toDouble();
      heightToWidthRatio = height / width;
    });
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({Key? key, required this.onDrag}) : super(key: key);

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
