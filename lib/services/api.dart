import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const _limit = 19;

Future<List> getAll(int offset) async {
  http.Response response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=BGbun7WFDQeFiyTeetrGHU2aH47ZO2it&limit=$_limit&offset=$offset&rating=G');
  return json.decode(response.body)['data'];
}

Future<List> getSearch(String search, int offset) async {
  http.Response response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=BGbun7WFDQeFiyTeetrGHU2aH47ZO2it&q=$search&limit=$_limit&offset=$offset&rating=G&lang=pt');
  return json.decode(response.body)['data'];
}
