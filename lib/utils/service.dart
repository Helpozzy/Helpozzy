import 'dart:io';

import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  generateHeaders() async {
    String _token = await SharedPref.readString(AUTH_TOKEN);
    return {
      'Authorization': 'Bearer $_token',
    };
  }

  Future<Map<String, dynamic>> post(
      String _url, Map<String, String> _headers, Map<String, String> _params) {
    print('_url => $_url');
    // ignore: unnecessary_null_comparison
    if (_headers != null) {
      print('_headers => $_headers');
    }
    print('_params => $_params');
    return http
        .post(Uri.parse(BASE_URL + _url),
            // ignore: unnecessary_null_comparison
            headers: (_headers != null) ? _headers : {},
            body: _params)
        .then(
      (response) {
        final code = response.statusCode;
        final body = response.body;
        final jsonBody = json.decode(body);
        print('response code => $code');
        print('response body => $body');
        Map<String, dynamic> _resDic;
        if (code == 200) {
          _resDic = Map<String, dynamic>.from(jsonBody);
          _resDic[STATUS] = _resDic[SUCCESS] == 1;
          if (!_resDic[STATUS]) {
            if (_resDic[IS_TOKEN_EXPIRED] == 1) {
              _resDic[HTTP_CODE] = 401;
            }
          }
        } else {
          _resDic = Map<String, dynamic>();
          _resDic[STATUS] = false;
          _resDic[IS_TOKEN_EXPIRED] = 0;
          _resDic[MESSAGE] = jsonBody[MESSAGE] != null
              ? jsonBody[MESSAGE]
              : 'Something went wrong';
          _resDic[HTTP_CODE] = code;
        }

        print('===>> Response : $_resDic');
        return _resDic;
      },
    );
  }

  Future<Map<String, dynamic>> get(String _url, Map<String, String> _headers) {
    print('_url => $_url');
    // ignore: unnecessary_null_comparison
    if (_headers != null) {
      print('_headers => $_headers');
    }

    return http
        .get(Uri.parse(BASE_URL + _url),
            headers: (_headers != {}) ? _headers : {})
        .then(
      (response) {
        final code = response.statusCode;
        final body = response.body;
        final jsonBody = json.decode(body);
        print('response code => $code');
        Map<String, dynamic> _resDic;
        if (code == 200) {
          _resDic = Map<String, dynamic>.from(jsonBody);
          _resDic[STATUS] = _resDic[SUCCESS] == 1;
          if (!_resDic[STATUS]) {
            if (_resDic[IS_TOKEN_EXPIRED] == 1) {
              _resDic[HTTP_CODE] = 401;
            }
          }
        } else {
          _resDic = Map<String, dynamic>();
          _resDic[STATUS] = false;
          _resDic[IS_TOKEN_EXPIRED] = 0;
          _resDic[MESSAGE] = jsonBody[MESSAGE] != null
              ? jsonBody[MESSAGE]
              : 'Something went wrong';
          _resDic[HTTP_CODE] = code;
        }

        print('===>> Response : $_resDic');
        return _resDic;
      },
    );
  }

  Future<Map<String, dynamic>> delete(
      String _url, Map<String, String> _headers) {
    print('_url => $_url');
    if (_headers != {}) {
      print('_headers => $_headers');
    }

    return http
        .delete(Uri.parse(BASE_URL + _url),
            headers: (_headers != {}) ? _headers : {})
        .then(
      (response) {
        final code = response.statusCode;
        final body = response.body;
        final jsonBody = json.decode(body);
        print('response code => $code');
        print('response body => $body');
        Map<String, dynamic> _resDic;
        if (code == 200) {
          _resDic = Map<String, dynamic>.from(jsonBody);
          _resDic[STATUS] = _resDic[SUCCESS] == 1;
          if (!_resDic[STATUS]) {
            if (_resDic[IS_TOKEN_EXPIRED] == 1) {
              _resDic[HTTP_CODE] = 401;
            }
          }
        } else {
          _resDic = Map<String, dynamic>();
          _resDic[STATUS] = false;
          _resDic[IS_TOKEN_EXPIRED] = 0;
          _resDic[MESSAGE] = jsonBody[MESSAGE] != null
              ? jsonBody[MESSAGE]
              : 'Something went wrong';
          _resDic[HTTP_CODE] = code;
        }

        print('===>> Response : $_resDic');
        return _resDic;
      },
    );
  }

  Future<Map<String, dynamic>> postWithImage(
      String _url,
      Map<String, String> _headers,
      Map<String, String> _params,
      String _imageKey,
      File _imageFile) async {
    // ignore: unnecessary_null_comparison
    if (_headers != null) {
      print('_headers => $_headers');
    }
    print('_params => $_params');

    print('_url => $_url');
    var request = http.MultipartRequest("POST", Uri.parse(BASE_URL + _url));
    // ignore: unnecessary_null_comparison
    if (_headers != null) {
      request.headers.addAll(_headers);
    }
    // ignore: unnecessary_null_comparison
    if (_params != null) {
      request.fields.addAll(_params);
    }
    // ignore: unnecessary_null_comparison
    if (_imageFile != null) {
      // final _name = '${DateTime.now().toIso8601String()}.${_type.split('/').last}';

      // final _partFile = http.MultipartFile(_imageKey,
      //     _imageFile.readAsBytes().asStream(), _imageFile.lengthSync(),
      //     filename: _name);
      // request.files.add(_partFile);

      print('request files: ${request.files}');
    }
    var response = await request.send();
    final code = response.statusCode;
    print('response code => $code');
    final responseBody = await http.Response.fromStream(response);
    final body = responseBody.body;
    print('response ==> $body');
    final jsonBody = json.decode(body);

    print('response body => $jsonBody');
    Map<String, dynamic> _resDic;
    if (code == 200) {
      _resDic = Map<String, dynamic>.from(jsonBody);
      _resDic[STATUS] = _resDic[SUCCESS] == 1;
    } else {
      _resDic = Map<String, dynamic>();
      _resDic[STATUS] = false;
      _resDic[IS_TOKEN_EXPIRED] = 0;
      _resDic[MESSAGE] = jsonBody[MESSAGE] != null
          ? jsonBody[MESSAGE]
          : 'Something went wrong';
    }
    _resDic[HTTP_CODE] = code;
    print('===>> Response : $_resDic');
    return _resDic;
  }
}
