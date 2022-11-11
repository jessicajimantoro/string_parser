import 'package:flutter/widgets.dart';
import 'package:string_parser/ast.dart';

class BlockWidget extends BlockElement {
  String rawText;

  BlockWidget({
    required BlockType blockType,
    List<Node>? children,
    this.rawText = '',
  }) : super(
          blockType: blockType,
          children: children,
        );

  @override
  void accept(NodeVisitor visitor) {
    print('block widget $blockType visited!');
    List<Widget> widgets = <Widget>[];

    if (children != null) {
      for (Node child in children!) {
        if (child is BlockWidget) {
          visitor.visitBlockElement(child);
        } else if (child is InlineWidget) {
          widgets.add(
            Text(child.rawText),
          );
          visitor.visitInlineElement(child);
        }
      }
    }
  }
}

class InlineWidget extends InlineElement {
  String rawText;

  InlineWidget({
    required InlineType inlineType,
    this.rawText = '',
  }) : super(inlineType: inlineType);

  @override
  void accept(NodeVisitor visitor) {
    print('inline widget $inlineType visited!');
  }
}

class WidgetVisitor extends NodeVisitor {
  List<Widget> _widgets = [];

  List<Widget> get widgets => _widgets;

  @override
  void visitBlockElement(BlockElement blockElement) {
    (blockElement as BlockWidget).accept(this);
  }

  @override
  void visitInlineElement(InlineElement inlineElement) {
    (inlineElement as InlineWidget).accept(this);
  }
}
