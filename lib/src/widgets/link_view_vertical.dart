import 'dart:convert';
import 'package:flutter/material.dart';

class LinkViewVertical extends StatelessWidget {
  final String url;
  final String title;
  final String description;
  final String imageUri;
  final Function() onTap;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool? showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final double? radius;
  final Color? bgColor;

  LinkViewVertical({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.onTap,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.showMultiMedia,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.bgColor,
    this.radius,
  }) : super(key: key);

  double computeTitleFontSize(double height) {
    var size = height * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight, layoutWidth) {
    return 1;
  }

  int? computeBodyLines(layoutHeight) {
    return 1;
  }

  @override
  Widget build(BuildContext context) {    
    var layoutWidth = MediaQuery.of(context).size.width;
    var layoutHeight = 250.0;

    var _titleTS = titleTextStyle ??
        TextStyle(
          fontSize: computeTitleFontSize(layoutHeight),
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    var _bodyTS = bodyTextStyle ??
        TextStyle(
          fontSize: computeTitleFontSize(layoutHeight) - 1,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        );

    ImageProvider? _img = imageUri != '' ? NetworkImage(imageUri) : null;
    if (imageUri.startsWith('data:image')) {
      _img = MemoryImage(
        base64Decode(imageUri.substring(imageUri.indexOf('base64') + 7)),
      );
    }

    return GestureDetector(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showMultiMedia!
                ? Container(
                    child: _img == null
                        ? Container(color: bgColor ?? Colors.grey)
                        : Container(
                            height: 200,
                            padding: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: radius == 0
                                  ? BorderRadius.zero
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                              image: DecorationImage(
                                image: _img,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  )
                : SizedBox(height: 5),
            _buildTitleContainer(
                _titleTS, computeTitleLines(layoutHeight, layoutWidth)),
            _buildBodyContainer(_bodyTS, computeBodyLines(layoutHeight)),
          ],
        ));
    
  }

  Widget _buildTitleContainer(TextStyle _titleTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
      child: Container(
        alignment: Alignment(-1.0, -1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: _titleTS,
              overflow: TextOverflow.ellipsis,
              maxLines: _maxLines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle _bodyTS, _maxLines) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
        child: Container(
          alignment: Alignment(-1.0, -1.0),
          child: Text(
            description,
            style: _bodyTS,
            overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
            maxLines: bodyMaxLines ?? _maxLines,
          ),
        ),
      ),
    );
  }
}
