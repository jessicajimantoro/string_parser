import 'package:flutter/widgets.dart';
import 'package:string_parser/ast.dart';
import 'package:string_parser/widgets/heading_widget.dart';

class BlockWidget extends BlockElement {
  String text;
  List<Widget> widgets = [];

  HeadingType? _headingType;

  BlockWidget({
    required BlockType blockType,
    List<Node>? children,
    this.text = '',
  }) : super(
          blockType: blockType,
          children: children,
        );

  BlockWidget.heading({
    required BlockType blockType,
    required HeadingType headingType,
    List<Node>? children,
    this.text = '',
  }) : super(
          blockType: blockType,
          children: children,
        ) {
    _headingType = headingType;
  }

  @override
  void accept(NodeVisitor visitor, [BlockWidget? parent]) {
    if (blockType == BlockType.heading) {
      widgets.add(
        HeadingWidget.widget(
          headingType: _headingType ?? HeadingType.h1,
          text: text,
        ),
      );
    } else if (blockType == BlockType.unorderedList) {
      widgets.add(const Text('- '));
    }

    if (children != null) {
      for (Node child in children!) {
        if (child is BlockWidget) {
          (visitor as WidgetVisitor).visitBlockElement(child, this);
        } else if (child is InlineWidget) {
          (visitor as WidgetVisitor).visitInlineElement(child, this);
        }
      }
    }
  }
}

class InlineWidget extends InlineElement {
  String text;

  InlineWidget({
    required InlineType inlineType,
    this.text = '',
  }) : super(inlineType: inlineType);

  @override
  void accept(NodeVisitor visitor, [BlockWidget? parent]) {
    Widget widget = Text(text);

    if (inlineType == InlineType.bold) {
      widget = Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    parent?.widgets.add(widget);
    print(parent?.widgets);
  }
}

class WidgetVisitor extends NodeVisitor {
  final List<Widget> _children = [];

  Widget get widget => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      );
  List<Widget> get children => _children;

  @override
  void visitBlockElement(BlockElement blockElement, [BlockWidget? parent]) {
    (blockElement as BlockWidget).accept(this, parent);

    if (blockElement.blockType == BlockType.unorderedList) {
      _children.add(
        Row(
          children: blockElement.widgets,
        ),
      );
    } else {
      _children.addAll(blockElement.widgets);
    }
  }

  @override
  void visitInlineElement(InlineElement inlineElement, [BlockWidget? parent]) {
    (inlineElement as InlineWidget).accept(this, parent);
  }
}
