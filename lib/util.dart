import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'zefyr/zefyr.dart';

class Util {
  Future<NotusDocument> _loadDocument() async {
    //_controller = ZefyrController(document);
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    return NotusDocument.fromJson(jsonDecode("[{\"insert\":\"\n\"}]"));
  }

  void _saveDocument(BuildContext context, ZefyrController _controller) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    String contents = jsonEncode(_controller.document);

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
