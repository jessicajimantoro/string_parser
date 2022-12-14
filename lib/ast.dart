enum BlockType {
  root,
  heading,
  unorderedList,
  orderedList,
  table,
  paragraph,
}

enum InlineType {
  regular,
  bold,
  italic,
  boldItalic,
}

abstract class Node {
  void accept(NodeVisitor visitor);
}

/// Multiple elements
class BlockElement extends Node {
  List<Node>? children;
  final BlockType blockType;

  BlockElement({
    required this.blockType,
    this.children,
  }) {
    children ??= List.empty(growable: true);
  }

  @override
  void accept(NodeVisitor visitor) {
    print('block element $blockType visited!');
    if (children != null) {
      for (Node child in children!) {
        if (child is BlockElement) {
          visitor.visitBlockElement(child);
        } else if (child is InlineElement) {
          visitor.visitInlineElement(child);
        }
      }
    }
  }
}

/// Single element, can't be combined with another element,
/// including [InlineElement]
class InlineElement extends Node {
  final InlineType inlineType;

  InlineElement({
    required this.inlineType,
  });

  @override
  void accept(NodeVisitor visitor) {
    print('inline element $inlineType visited!');
  }
}

abstract class NodeVisitor {
  void visitBlockElement(BlockElement blockElement);
  void visitInlineElement(InlineElement inlineElement);
}
