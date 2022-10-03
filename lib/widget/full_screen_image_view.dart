import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:vector_math/vector_math_64.dart';

class FullScreenView extends StatefulWidget {
  FullScreenView({required this.imgUrl});
  final String imgUrl;

  @override
  _FullScreenViewState createState() => _FullScreenViewState(imgUrl: imgUrl);
}

class _FullScreenViewState extends State<FullScreenView> {
  _FullScreenViewState({required this.imgUrl});
  final String imgUrl;
  double _scale = 1.0;
  double _previousScale = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dismissible(
          key: Key(imgUrl),
          onDismissed: (direction) {
            Navigator.of(context).pop();
          },
          direction: DismissDirection.down,
          child: GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              _previousScale = _scale;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() => _scale = _previousScale * details.scale);
            },
            onScaleEnd: (ScaleEndDetails details) {
              _previousScale = 0.0;
            },
            child: Transform(
              transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
              alignment: FractionalOffset.center,
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.fitWidth,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                progressIndicatorBuilder: (context, _, __) {
                  return Center(
                    child: CircularProgressIndicator(color: PRIMARY_COLOR),
                  );
                },
                errorWidget: (context, url, error) {
                  return Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 0,
          child: Material(
            color: TRANSPARENT_COLOR,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: WHITE,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
