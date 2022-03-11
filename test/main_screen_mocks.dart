import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {}

final mockedMainScreenClient = MockClient((request) async {
  final jsonMap = {"a": "b"};
  return Response(json.encode(jsonMap), 200);
});
