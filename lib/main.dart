import 'dart:convert';
import 'dart:io';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'zefyr/zefyr.dart';
import 'zefyr_component.dart';

//MAKE SMOOTHER SUBSCript and superscript (EDIT: CANT SEEM TO BE POSSIBLE.)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
//theme: ThemeData.light(), for lighttheme. or theme: ThemeData.dark() for dark.
      theme:

          //ThemeData(fontFamily: 'RobotoRegular'),
          ThemeData.dark(),

      home: const ZefyrComponent(),

      //const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  //EquationSpanBuilder? _equationSpanBuilder;

  @override
  void initState() {
    //_equationSpanBuilder = EquationSpanBuilder(controller, context);

    /*
      //String result = _controller.formatText
      print(result);
      if (result.contains('?')) {
        result = result.replaceAll('?', '');
        for (String k in greekLettersMap.keys) {
          //print(greekLettersMap[k]);
          result = result.replaceAll(k, '${greekLettersMap[k]}');
        }
      }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor page"),
        // <<< begin change
        actions: <Widget>[
          /*
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          ),
          */
          /*
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.update),
              onPressed: () => _updateDocument(),
            ),
          )*/
        ],
        // end change >>>
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*
            const Text('Hello world!2'),
            Math.tex(r'\frac a b', mathStyle: MathStyle.display),
            Expanded(
              child: ExtendedTextField(
                controller: controller,
                specialTextSpanBuilder: _equationSpanBuilder,
                maxLines: null,
              ),
            ),*/

            /*
            const Text(
                "To make greek letters write \" ? \" followed by the name of the greek letter"),
            const Text(
                "Example: writing ?alpha ?* ?sigma will produce \u03b1 \u00b7 \u03c3"),
            */
          ],
        ),
      ),
    );
  }
}

/*
class EquationSpanBuilder extends SpecialTextSpanBuilder {
  EquationSpanBuilder(this.controller, this.context);
  final TextEditingController controller;
  final BuildContext context;
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    } else if (isStart(flag, SuperText.flag)) {
      return SuperText(textStyle!, onTap,
          start: index! - (SuperText.flag.length - 1));
    } else if (isStart(flag, FatText.flag)) {
      return FatText(textStyle!, onTap,
          start: index! - (FatText.flag.length - 1));
    } else if (isStart(flag, ItalicText.flag)) {
      return ItalicText(textStyle!, onTap,
          start: index! - (ItalicText.flag.length - 1));
    } else if (isStart(flag, SubText.flag)) {
      return SubText(textStyle!, onTap,
          start: index! - (SubText.flag.length - 1));
    } else if (isStart(flag, GreekText.flag)) {
      return GreekText(textStyle!, onTap,
          start: index! - (GreekText.flag.length - 1));
    }
    return null;
  }
}

class FatText extends SpecialText {
  FatText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, "#", textStyle, onTap: onTap);
  static const String flag = "b#";

  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();
    String actualText = flag + text + "#";

    return SpecialTextSpan(
        text: text,
        actualText: actualText,
        style: textStyle?.copyWith(fontWeight: FontWeight.bold));
  }
}

class ItalicText extends SpecialText {
  ItalicText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, "#", textStyle, onTap: onTap);
  static const String flag = "i#";

  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();
    String actualText = flag + text + "#";

    return SpecialTextSpan(
        text: text,
        actualText: actualText,
        style: textStyle?.copyWith(fontStyle: FontStyle.italic));
  }
}

class SuperText extends SpecialText {
  SuperText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, " ", textStyle, onTap: onTap);

  static const String flag = "^";

  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();
    return superOrSubScript(true, text, textStyle, flag);
  }
}

String replaceWithSpecialLetters(String result) {
  if (result.contains('?')) {
    result = result.replaceAll('?', '');
    for (String k in greekLettersMap.keys) {
      //print(greekLettersMap[k]);
      result = result.replaceAll(k, '${greekLettersMap[k]}');
    }
  }
  return result;
}

SpecialTextSpan superOrSubScript(isSuper, text, textStyle, flag) {
  String result = replaceWithSpecialLetters(text);

  return SpecialTextSpan(children: [
    WidgetSpan(
        child: Transform.translate(
      offset: isSuper ? const Offset(2, -4) : const Offset(2, 8),
      child: Text(
        result + " ",
        //superscript is usually smaller in size
        textScaleFactor: 0.7,
        style: textStyle,
      ),
    )),
  ], text: '', actualText: flag + text);
}

class SubText extends SpecialText {
  SubText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, " ", textStyle, onTap: onTap);

  static const String flag = "_";

  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();
    return superOrSubScript(false, text, textStyle, flag);
  }
}

class GreekText extends SpecialText {
  GreekText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start})
      : super(flag, " ", textStyle, onTap: onTap);

  static const String flag = "?";

  final int? start;
  @override
  InlineSpan finishText() {
    final String text = getContent();

    //final String atText = toString();
    /*
    String str = "";

    for (var k in greekLettersMap.keys) {
      str += "$k : ${greekLettersMap[k]} \n";
    }
    */
    String? unicode = greekLettersMap[text];
    String actualText = flag + text + " ";
    return SpecialTextSpan(
      text: unicode ?? actualText,
      actualText: actualText,
      //style: const TextStyle(fontFeatures: [FontFeature.superscripts()])
    );

    /*
    return ExtendedWidgetSpan(
      alignment: PlaceholderAlignment.middle,
      start: start!,
      deleteAll: false,
      actualText: flag + text + flag,
      child: Math.tex(
        text,
        mathStyle: MathStyle.display,
        onErrorFallback: (err) =>
            Text(flag + text + flag, style: const TextStyle(color: Colors.red)),
      ),
    );*/
  }
}
/*
Math.tex(
        text,
        mathStyle: MathStyle.display,
        onErrorFallback: (err) =>
            Text(flag + text + flag, style: const TextStyle(color: Colors.red)),
      ),*/
*/
//TODO: debugging.
//TODO: CREATE DOCUMENTATION

//TODO: make equaition support.
//TODO: make image support.
