import 'dart:convert';
import 'dart:io';

import 'package:examprepper/zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:tap_canvas/tap_canvas.dart';

import 'big_unicode_data.dart';
//import 'zefyr/zefyr.dart';

class ZefyrComponent extends StatefulWidget {
  final ZefyrController controller;
  const ZefyrComponent({Key? key, required this.controller}) : super(key: key);

  @override
  _ZefyrComponentState createState() => _ZefyrComponentState();
}

class _ZefyrComponentState extends State<ZefyrComponent> {
  ZefyrController? _controller;
  int startWordIndex = 0;
  bool justCompiled = false;
  FocusNode? _editorFocusNode;
  bool _isEditing = true;
  bool _newFocus = false;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _editorFocusNode = FocusNode();

    _controller!.addListener(() {
      int currentIndex = _controller!.selection.baseOffset;

      if (justCompiled) {
        justCompiled = false;
        return;
      }

      if (currentIndex != 0) {
        String content = _controller!.document.toPlainText();
        if (currentIndex <= startWordIndex) {
          startWordIndex = currentIndex;
        } else if ((content[currentIndex - 1] == ' ' ||
            content[currentIndex - 1] == '\n')) {
          String s = content.substring(startWordIndex, currentIndex - 1);
          if (!(s.contains(' '))) {
            String replacement = _updateDocument(s);
            if (replacement != s) {
              currentIndex = currentIndex + replacement.length - s.length;
              justCompiled = true;
              _controller!.updateSelection(TextSelection(
                  baseOffset: currentIndex, extentOffset: currentIndex));

              justCompiled = true;
              _controller!.replaceText(startWordIndex, s.length, replacement);
            }
          }
          startWordIndex = currentIndex;
        }
      } else {
        startWordIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_newFocus) {
      _setCursorToEnd();
      _newFocus = false;
    }
    return TapOutsideDetectorWidget(
        onTappedOutside: () {
          if (_isEditing) {
            //print(widget.id.toString() + ': focus lost');

            setState(() {
              _isEditing = false;
            });
          }
        },
        onTappedInside: () {
          if (!_isEditing) {
            //_editorFocusNode!.requestFocus();
            //print(widget.id.toString() + ': focus gained');

            setState(() {
              _isEditing = true;
              _newFocus = true;
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: _isEditing
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                )
              : null,
          child: Column(children: <Widget>[
            (_controller == null)
                ? const Center(child: CircularProgressIndicator())
                : ZefyrEditor(
                    padding: const EdgeInsets.all(16),
                    controller: _controller!,
                    focusNode: _editorFocusNode,
                  ),
            _isEditing
                ? ZefyrToolbar.basic(
                    controller: _controller!,
                    hideSuperScript: true,
                    hideSubScript: true,
                    hideDirection: true,
                  )
                : const SizedBox.shrink(),
          ]),
        ));
  }

  //Set cursor to last index in file.
  void _setCursorToEnd() {
    _controller!.updateSelection(TextSelection(
        baseOffset: _controller!.document.toPlainText().length,
        extentOffset: _controller!.document.toPlainText().length));
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
}
