import 'package:flutter/material.dart';
import 'package:string_parser/ast.dart';
import 'package:string_parser/widget.dart';
import 'package:string_parser/parser.dart';

class CPBuilder extends StatelessWidget {
  final WidgetVisitor visitor;
  final String unparsedString;

  const CPBuilder({
    Key? key,
    this.unparsedString = '',
    required this.visitor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlockWidget root = _createNode(Parser.fromLongText(unparsedString));
    visitor.visitBlockElement(root);

    return visitor.widget;
  }

  BlockWidget _createNode(List<Node>? children) {
    BlockWidget root = BlockWidget(blockType: BlockType.root);
    root.children?.addAll(children ?? []);

    return root;
  }
}
