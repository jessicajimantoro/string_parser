import 'package:flutter_test/flutter_test.dart';
import 'package:string_parser/ast.dart';

class KangVisit implements NodeVisitor {
  @override
  void visitBlockElement(BlockElement blockElement) {
    blockElement.accept(this);
  }

  @override
  void visitInlineElement(InlineElement inlineElement) {
    inlineElement.accept(this);
  }
}

void main() {
  late BlockElement root;
  setUp(() {
    root = BlockElement(blockType: BlockType.root);
  });
  test('Root without any element', () {
    KangVisit kangVisit = KangVisit();
    kangVisit.visitBlockElement(root);
  });

  test('Root with inline element', () {
    root.children?.add(InlineElement(inlineType: InlineType.bold));

    KangVisit kangVisit = KangVisit();
    kangVisit.visitBlockElement(root);
  });

  test('Root with block element', () {
    root.children?.add(BlockElement(blockType: BlockType.unorderedList));

    KangVisit kangVisit = KangVisit();
    kangVisit.visitBlockElement(root);
  });

  test('Root with block & inline element', () {
    root.children?.add(
      BlockElement(
        blockType: BlockType.unorderedList,
        children: [
          BlockElement(
            blockType: BlockType.orderedList,
            children: [
              InlineElement(
                inlineType: InlineType.bold,
              ),
              InlineElement(
                inlineType: InlineType.italic,
              ),
            ],
          ),
          InlineElement(
            inlineType: InlineType.bold,
          ),
          InlineElement(
            inlineType: InlineType.italic,
          ),
        ],
      ),
    );

    KangVisit kangVisit = KangVisit();
    kangVisit.visitBlockElement(root);
  });
}
