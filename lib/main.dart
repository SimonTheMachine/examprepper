import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tap_canvas/tap_canvas.dart';
import 'zefyr/zefyr.dart';
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

      home: const TapCanvas(child: MyHomePage()),

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
  //List<ZefyrController> controllerList = [];
  List<FocusNode> focusList = [];

  List<Widget> widgetList = [];
  @override
  void initState() {
    //addNewTextField();
    //TODO: LOAD WIDGETS FROM FILE.

    //_equationSpanBuilder = EquationSpanBuilder(controller, context);

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
            const SizedBox(
              height: 8,
            ),
            //Expanded(child: zefyrListBuilder()),
            /*const Padding(
              padding: EdgeInsets.all(15.0),
              child: ZefyrComponent(),
            ),*/
            Column(
              children: widgetList,
            ),
            const SizedBox(
              height: 8,
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

                  addNewTextField();
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
  /*
  ListView zefyrListBuilder() {
    print('rebuilding');
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return widgetList[index];
          /*
          ZefyrComponent(
            controller: controllerList[index],
            focusNode: focusList[index],
          );*/
        },
        itemCount: widgetList.length);
    /*
          return InkWell(
            onTap: () {
              print("tapped");
              focusIndex = index;
              setState(() {});
            },
            child: index == focusIndex
                ? ZefyrComponent(controller: controllerList[index])
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    child: Column(children: <Widget>[
                      ZefyrComponent(controller: controllerList[index]),
                      ZefyrToolbar.basic(
                        //TODO: WRONG
                        controller: ZefyrController(),
                        hideSuperScript: true,
                        hideSubScript: true,
                        hideDirection: true,
                      ),
                    ]),
                  ),
          );
          */
  }
  */

  void addNewTextField() {
    ZefyrController _controller = ZefyrController();

    widgetList.add(ZefyrComponent(
      controller: _controller,
    ));
    /*
      widgetList.add();*/

    setState(() {
      //controllerList.add(_controller);
      //focusList.add(_focusNode);
    });
  }

  Widget newButton(String tooltip, IconData icon, VoidCallback onPressed) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).buttonTheme.colorScheme!.primary,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Badge(
          toAnimate: false,
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
