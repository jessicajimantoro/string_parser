import 'package:flutter/widgets.dart';

enum HeadingType {
  h1,
  h2,
  h3,
}

class HeadingWidget {
  static Widget widget({
    required HeadingType headingType,
    String text = '',
  }) {
    TextStyle textStyle;

    switch (headingType) {
      case HeadingType.h1:
        textStyle = const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        );
        break;
      case HeadingType.h2:
        textStyle = const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        );
        break;
      case HeadingType.h3:
        textStyle = const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );
        break;
    }
    return Text(
      text,
      style: textStyle,
    );
  }
}
