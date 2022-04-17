import 'dart:io';

import 'package:badges/badges.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:tap_canvas/tap_canvas.dart';
import 'package:file_picker/file_picker.dart';
import 'image_editor.dart';
import 'zefyr/zefyr.dart';
import 'zefyr_component.dart';

//TODO: make equaition support.

//TODO: DOWNLOADABILITY
//TODO: DOCUMENTATION.

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
          mainAxisSize: MainAxisSize.min,
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
            /*
            CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(widgetList),
                  ),
                ),
              ],
            ),
            */
            /*
            LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight - 50,
                      ),
                      
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widgetList,
                      )));
            }),
            */
            //const SizedBox.shrink(),
            buildListView(),

            /*
              ))
              child: SingleChildScrollView(
                  ),
            ),
            */
            const SizedBox(
              height: 8,
            ),
            const Spacer(),
            const Divider(),
            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                newButton('Add new Image', Icons.image, () {
                  print('Add new image');

                  addNewImage();
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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 168,
      child: ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return widgetList[index];
        },
        shrinkWrap: true,
      ),
    );
  }

  void addNewTextField() {
    ZefyrController _controller = ZefyrController();
    widgetList.add(ZefyrComponent(
      controller: _controller,
    ));
    setState(() {});
  }

  Future<void> addNewImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path.toString());
      widgetList.add(ResizebleWidget(
        image: FileImage(file),
      ));
      setState(() {});
      //Image(image: ResizeImage(FileImage(file), width: 300))
      /*

      img.Image? image = img.decodeImage(file.readAsBytesSync());

      if (image != null) {
        image = img.copyResize(image, width: 120);
        print(Directory.current.path);
        File('thumbnail-test.png').writeAsBytesSync(image.getBytes());
      }

      if (image != null) {
        

        /*  
          SizedBox(
          height: 400,
          child: Image.memory(
            image.getBytes(),
            //fit: BoxFit.cover,
          ),
        ));
        */
        setState(() {});
      }
      */

      /*
      path.basename(file.path);
      widgetList.add(Image.file(file));
      setState(() {});

      Widget image = ResizebleWidget(
        image: Image.file(file),
      );
      */
      // widgetList.add(image);

      // setState(() {});
    } else {
      // User canceled the picker
    }
    //TODO: do the image picker
    //TODO: image cropper.
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
