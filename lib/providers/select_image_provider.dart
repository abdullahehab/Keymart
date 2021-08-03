import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelectImageProvider extends ChangeNotifier {
  File _image;
  String _imageUrl;
  Uint8List _bytes;

  File get getImages => _image;

  String get getImageUrl => _imageUrl;
  Uint8List get getbytes => _bytes;

  void changeImageValue(File image) {
    _image = image;
    notifyListeners();
  }

  void changeImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void changeBytes(Uint8List _bytes) {
    _bytes = _bytes;
    notifyListeners();
  }
}
