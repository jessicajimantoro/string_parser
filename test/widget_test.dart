import 'package:flutter_test/flutter_test.dart';
import 'package:string_parser/ast.dart';
import 'package:string_parser/widget.dart';

void main() {
  late BlockWidget root;

  setUp(() {
    root = BlockWidget(blockType: BlockType.root);
  });

  test('Root without any element', () {
    WidgetVisitor widgetVisitor = WidgetVisitor();

    widgetVisitor.visitBlockElement(root);
  });

  test('Root with inline element', () {
    root.children?.add(InlineWidget(inlineType: InlineType.bold));

    WidgetVisitor widgetVisitor = WidgetVisitor();
    widgetVisitor.visitBlockElement(root);
  });

  test('Root with block element', () {
    root.children?.add(BlockWidget(blockType: BlockType.unorderedList));

    WidgetVisitor widgetVisitor = WidgetVisitor();
    widgetVisitor.visitBlockElement(root);
  });

  test('Root with block & inline element', () {
    root.children?.add(
      BlockWidget(
        blockType: BlockType.unorderedList,
        children: [
          InlineWidget(
            inlineType: InlineType.bold,
          ),
          InlineWidget(
            inlineType: InlineType.italic,
          ),
        ],
      ),
    );

    WidgetVisitor widgetVisitor = WidgetVisitor();
    widgetVisitor.visitBlockElement(root);
    print(widgetVisitor.widgets);
  });
}
