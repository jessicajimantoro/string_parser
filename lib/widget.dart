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
  Widget? accept(NodeVisitor visitor) {
    print('block widget $blockType visited!');
    List<Widget> widgets = <Widget>[];

    if (children != null) {
      print('children != null');
      for (Node child in children!) {
        if (child is BlockWidget) {
          visitor.visitBlockElement(child);
        } else if (child is InlineWidget) {
          widgets.add(Text('Inline ${child.inlineType}'));
          visitor.visitInlineElement(child);
        }
      }
    }

    if (blockType == BlockType.heading) {
      return _headingWidget();
    }

    if (widgets.isNotEmpty) {
      return Column(
        children: widgets,
      );
    }
    return null;
  }

  Widget? _headingWidget() {
    if (rawText.startsWith('###')) {
      rawText = rawText.replaceRange(0, 4, '');
      return Text('h3: $rawText');
    } else if (rawText.startsWith('##')) {
      rawText = rawText.replaceRange(0, 3, '');
      return Text('h2: $rawText');
    } else if (rawText.startsWith('#')) {
      rawText = rawText.replaceRange(0, 2, '');
      return Text('h1: $rawText');
    }
    return null;
  }
}

class InlineWidget extends InlineElement {
  InlineWidget({
    required InlineType inlineType,
  }) : super(inlineType: inlineType);

  @override
  Widget accept(NodeVisitor visitor) {
    print('inline widget $inlineType visited!');
    return Text('Inline $inlineType');
  }
}

class WidgetVisitor extends NodeVisitor {
  List<Widget> _widgets = [];

  List<Widget> get widgets => _widgets;

  @override
  void visitBlockElement(BlockElement blockElement) {
    final blockWidget = (blockElement as BlockWidget).accept(this);
    if (blockWidget != null) {
      _widgets.add(blockWidget);
    }
  }

  @override
  void visitInlineElement(InlineElement inlineElement, [onlyOnce = false]) {
    final inlineWidget = (inlineElement as InlineWidget).accept(this);

    if (onlyOnce) {
      _widgets = [inlineWidget];
    }
  }
}
