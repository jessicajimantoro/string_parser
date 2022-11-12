import 'package:flutter_test/flutter_test.dart';
import 'package:string_parser/ast.dart';
import 'package:string_parser/parser.dart';
import 'package:string_parser/widget.dart';

void main() {
  test('tesstt', () {
    WidgetVisitor widgetVisitor = WidgetVisitor();

    List<Node> children = Parser.fromLongText(
      '### Aku adalah anak gembala\nSelalu riang serta gembira\n- Karena #aku# senang bekerja',
    );

    BlockWidget root = BlockWidget(blockType: BlockType.root);
    root.children?.addAll(children);

    print(root.children);

    widgetVisitor.visitBlockElement(root);

    print(widgetVisitor.children);
  });

  test('parse text', () {
    print(Parser.parseText('ke mana-mana #hatiku# senang'));
  });
}
