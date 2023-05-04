import 'package:http/http.dart' as http;
import 'dart:async';

class Server {
  String baseUrl;
  Server({required this.baseUrl});

  Future<http.Response> get(String path) async {
    var url = Uri.https(baseUrl, path);
    var response = await http.get(url);
    return response;
  }
}
