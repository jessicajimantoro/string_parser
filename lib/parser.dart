import 'dart:convert';

import 'package:string_parser/ast.dart';
import 'package:string_parser/widget.dart';
import 'package:string_parser/widgets/heading_widget.dart';

class Parser {
  static final _headerPattern =
      RegExp(r'^ {0,3}(#{1,3})[ \x09\x0b\x0c](.*?)#*$');
  static final _ulPattern =
      RegExp(r'^([ ]{0,3})()([*+-])(([ \t])([ \t]*)(.*))?$');

  static List<Node> fromLongText(String longText) {
    List<String> lines = const LineSplitter().convert(longText);

    List<Node> children = [];

    for (String line in lines) {
      if (_isHeader(line)) {
        children.add(
          BlockWidget.heading(
            blockType: BlockType.heading,
            headingType: HeadingType.h2,
            text: line,
          ),
        );
      } else if (_isUnorderedList(line)) {
        children.add(
          BlockWidget(
            blockType: BlockType.unorderedList,
            text: line,
            children: parseText(
              line.replaceFirst('- ', ''),
            ),
          ),
        );
      } else {
        children.add(
          BlockWidget(
            blockType: BlockType.paragraph,
            children: parseText(line),
          ),
        );
      }
    }

    return children;
  }

  static List<Node> parseText(String text) {
    List<Node> children = [];

    String temp = '';
    bool boldOpened = false;
    bool italicOpened = false;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == '#') {
        if (!boldOpened) {
          children.add(
            InlineWidget(
              inlineType: InlineType.regular,
              text: temp,
            ),
          );
          temp = '';
        } else {
          children.add(
            InlineWidget(
              inlineType: InlineType.bold,
              text: temp,
            ),
          );
          temp = '';
        }

        boldOpened = !boldOpened;
        continue;
      } else if (text[i] == '*') {
        if (!italicOpened) {
          children.add(
            InlineWidget(
              inlineType: InlineType.regular,
              text: temp,
            ),
          );
          temp = '';
        } else {
          children.add(
            InlineWidget(
              inlineType: InlineType.italic,
              text: temp,
            ),
          );
          temp = '';
        }

        italicOpened = !italicOpened;
        continue;
      } else {
        temp += text[i];
      }
    }

    if (temp != '') {
      children.add(
        InlineWidget(
          inlineType: InlineType.regular,
          text: temp,
        ),
      );
    }

    return children;
  }

  static bool _isHeader(String line) => _headerPattern.hasMatch(line);
  static bool _isUnorderedList(String line) => _ulPattern.hasMatch(line);
}
