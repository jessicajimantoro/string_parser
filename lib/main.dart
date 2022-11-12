import 'package:flutter/material.dart';
import 'package:string_parser/builder.dart';
import 'package:string_parser/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: CPBuilder(
            unparsedString:
                '### Aku adalah anak gembala\n*Selalu #\\#riang# serta* gembira\n- Karena #aku# senang *bekerja*\n- Tak pernah malas ataupun lelach',
            visitor: WidgetVisitor(),
          ),
        ),
      ),
    );
  }
}
