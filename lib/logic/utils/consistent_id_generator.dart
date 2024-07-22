import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateConsistentId(String str1, String str2) {
  final List<String> sortedStrings = [str1, str2]..sort();
  final String combinedString = sortedStrings.join('_');
  final bytes = utf8.encode(combinedString);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
