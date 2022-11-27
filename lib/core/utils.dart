
import 'dart:convert';

import 'package:crypto/crypto.dart';

String stringToMd5(String str) {
  var bytesToHash = utf8.encode(str);
  var md5Digest = md5.convert(bytesToHash);
  return md5Digest.toString();
}