import 'package:flutter/material.dart';
import 'package:string_parser/ast.dart';
import 'package:string_parser/widgets/heading_widget.dart';

class BlockWidget extends BlockElement {
  String text;
  List<Widget> widgets = [];
  List<TextSpan> spans = [];

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
      widgets.add(
        Container(
          margin: const EdgeInsets.only(
            right: 5.0,
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          height: 6,
          width: 6,
          alignment: Alignment.center,
        ),
      );
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
    TextStyle style = const TextStyle();

    if (inlineType == InlineType.bold) {
      style = const TextStyle(
        fontWeight: FontWeight.bold,
      );
    } else if (inlineType == InlineType.italic) {
      style = const TextStyle(
        fontStyle: FontStyle.italic,
      );
    } else if (inlineType == InlineType.boldItalic) {
      style = const TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      );
    }

    if (parent?.blockType == BlockType.paragraph) {
      parent?.spans.add(
        TextSpan(
          text: text,
          style: style.copyWith(
            height: 1.5,
          ),
        ),
      );
    }
    parent?.widgets.add(
      Text(
        text,
        style: style.copyWith(
          height: 1.5,
        ),
      ),
    );
  }
}

class WidgetVisitor extends NodeVisitor {
  final List<Widget> _children = [];

  Widget get widget => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
    } else if (blockElement.blockType == BlockType.paragraph) {
      _children.add(
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: blockElement.spans,
          ),
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
