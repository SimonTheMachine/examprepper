import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'zefyr_component.dart';

//TODO: make image support.
//TODO: make equaition support.
//TODO: DOCUMENTATION.

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

      home: const MyHomePage(),

      //const ZefyrComponent(),
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
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: ZefyrComponent(),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                newButton('Add new Image', Icons.image, () {
                  print('Add new image');
                }),
                newButton('Add new Text', Icons.text_fields, () {
                  print('Add new Text');
                }),
                newButton('Add new Equation', Icons.functions, () {
                  print('Add new equation');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget newButton(String tooltip, IconData icon, VoidCallback onPressed) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).buttonTheme.colorScheme!.primary,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Badge(
          badgeColor: Theme.of(context).buttonTheme.colorScheme!.primary,
          position: BadgePosition.topEnd(top: -15, end: -12),
          badgeContent: Transform.translate(
              offset: const Offset(0.3, -2),
              child: const Text(
                '+',
                textAlign: TextAlign.center,
              )),
          child: Icon(icon),
        ),
        tooltip: tooltip,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}

/*
Math.tex(
        text,
        mathStyle: MathStyle.display,
        onErrorFallback: (err) =>
            Text(flag + text + flag, style: const TextStyle(color: Colors.red)),
      ),*/
