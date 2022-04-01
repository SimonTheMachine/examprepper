import 'dart:convert';
import 'dart:io';

import 'package:examprepper/zefyr/zefyr.dart';
import 'package:flutter/material.dart';

import 'big_unicode_data.dart';
//import 'zefyr/zefyr.dart';

class ZefyrComponent extends StatefulWidget {
  const ZefyrComponent({Key? key}) : super(key: key);

  @override
  _ZefyrComponentState createState() => _ZefyrComponentState();
}

class _ZefyrComponentState extends State<ZefyrComponent> {
  ZefyrController? _controller;
  FocusNode? _focusNode;
  int startWordIndex = 0;
  bool justCompiled = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
        _controller!.addListener(() {
          //Superscript and subscript support must be nicer.
          //fix for initializing.
          //Fix for edits (deleting and correcting)

          int currentIndex = _controller!.selection.baseOffset;
          String content = _controller!.document.toPlainText();
          if (justCompiled) {
            justCompiled = false;
            return;
          }

          if (currentIndex != 0) {
            if (currentIndex <= startWordIndex) {
              startWordIndex = currentIndex;
            } else if (content[currentIndex - 1] == ' ' ||
                content[currentIndex - 1] == '\n') {
              String s = content.substring(startWordIndex, currentIndex - 1);
              if (!(s.contains(' '))) {
                String replacement = _updateDocument(s);
                if (replacement != s) {
                  justCompiled = true;
                  _controller!
                      .replaceText(startWordIndex, s.length, replacement);

                  currentIndex = currentIndex + replacement.length - s.length;
                  justCompiled = true;
                  _controller!.updateSelection(TextSelection(
                      baseOffset: currentIndex, extentOffset: currentIndex));
                }
              }
              startWordIndex = currentIndex;
            }
          } else {
            startWordIndex = 0;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return

        /*Scaffold(
        appBar: AppBar(
          title: const Text("Editor page"),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _saveDocument(context),
              ),
            ),
          ],
        ),
        body:*/
        Center(
            child: Column(children: <Widget>[
      (_controller == null)
          ? const SizedBox.shrink()
          : ZefyrToolbar.basic(
              controller: _controller!,
              hideSuperScript: true,
              hideSubScript: true,
              hideDirection: true,
            ),
      (_controller == null)
          ? const Center(child: CircularProgressIndicator())
          : ZefyrEditor(
              padding: const EdgeInsets.all(16),
              controller: _controller!,
              focusNode: _focusNode,
            ),
    ]

                //)
                ));
  }

  //WE FIRST WRITE SOME VARIABLE THEN WE WRITE SUBSCRIPT AND THEN SUPERSCRIPT
  String _updateDocument(String substring) {
    if (substring == '') return '';
    if (substring[0] == '¤') {
      if (substring.length == 1) return '';
      return substring.substring(1);
    }

    String nonScript = '';
    String subscript = '';
    String superscript = '';

    //x_2^2
    //We first check if the string is a superscript or subscript
    List<String> splitBySubscript = substring.split('_');
    //x, _2^2

    List<String> splitBySuperscript;
    //This means that there is no subscript
    if (splitBySubscript.length == 1) {
      splitBySuperscript = splitBySubscript[0].split('^');
      nonScript = splitBySuperscript[0];

      if (splitBySuperscript.length == 2) {
        superscript = splitBySuperscript[1];
      }
    } else {
      splitBySuperscript = splitBySubscript[1].split('^');
      nonScript = splitBySubscript[0];
      subscript = splitBySuperscript[0];
      if (splitBySuperscript.length == 2) {
        superscript = splitBySuperscript[1];
      }
    }

    //print('Nonscript: ' + nonScript);
    if (nonScript.isNotEmpty) {
      // Calculates the substring of nonscript.
      String? res = BigUnicodeData.greekLettersMap[nonScript];
      if (res != null) {
        nonScript = res;
      }
    }

    //print('subscript: ' + subscript);
    if (subscript.isNotEmpty) {
      for (String k in BigUnicodeData.subscripts.keys) {
        String? res = BigUnicodeData.subscripts[k];
        if (res != null) {
          subscript = subscript.replaceAll(k, res);
        }
      }
    }

    //print('superScript: ' + superscript);
    if (superscript.isNotEmpty) {
      for (String k in BigUnicodeData.superscripts.keys) {
        String? res = BigUnicodeData.superscripts[k];
        if (res != null) {
          superscript = superscript.replaceAll(k, res);
        }
      }
    }
    return nonScript + subscript + superscript;

    /*
        

        _controller!.updateSelection(
            TextSelection(baseOffset: newPosition, extentOffset: newPosition));*/

    //print(greekLettersMap[k]);
    //contents = contents.replaceAll(k, '${greekLettersMap[k]}');
  }

  Future<NotusDocument> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    return NotusDocument.fromJson(jsonDecode("[{\"insert\":\"\n\"}]"));
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    if (_controller != null) {
      String contents = jsonEncode(_controller!.document);

      // For this example we save our document to a temporary file.
      final file = File(Directory.systemTemp.path + "/quick_start.json");
      // And show a snack bar on success.
      file.writeAsString(contents).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved'),
          ),
        );
      });
    }
  }
}
