import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';

enum Method { get, post, put, delete }

class ProxyService {
  int offset = 0;
  int limit = 9;
  String url = env.baseUrl;
  Method method;

  Future<Map> find(final param) {
    String url = this.url;

    if (param is Map) {
      int index = 0;

      param.forEach((key, value) {
        url += "${index == 0 ? '?' : '&'}${key.toString()}=${value.toString()}";
        index += 1;
      });
    } else if (param is String) {
      url += "${param.toString()}";
    }

    return this._request(Method.get, url).then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future<Map> post(final param) {
    return this
        ._request(Method.post, this.url, param: param)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future<Map> put(final Map body) {
    String apiUrl = this.url + body['id'];

    return this
        ._request(Method.put, apiUrl, param: body)
        .then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future<Map> delete(String param) {
    String apiUrl = this.url + param;

    return this._request(Method.delete, apiUrl).then((http.Response response) {
      return json.decode(response.body);
    });
  }

  Future<http.Response> _request(Method method, String url, {Map param}) {
    switch (method) {
      case Method.delete:
        return http.delete(url, headers: {"Content-Type": "application/json"});
        break;
      case Method.put:
        return http.put(url,
            body: param, headers: {"Content-Type": "application/json"});
        break;
      case Method.post:
        return http.post(url,
            body: param, headers: {"Content-Type": "application/json"});
        break;
      default:
        return http.get(url, headers: {"Content-Type": "application/json"});
        break;
    }
  }
}
