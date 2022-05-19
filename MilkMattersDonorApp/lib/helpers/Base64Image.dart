import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

/// A collection of methods which are used to convert and manage images stored in Base-64

/// Return the [Image] representation of a base 64 string
Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}
/// Return a [Uint8List] from an image's base 64 string
Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}
/// Return an image's base 64 string from a [Uint8List]
String base64String(Uint8List data) {
  return base64Encode(data);
}