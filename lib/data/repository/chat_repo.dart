import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ChatRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ChatRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getMessage(int orderId,int offset) async {
    try {
      final response = await dioClient.post('${AppConstants.GET_MESSAGE_URI}?offset=$offset&limit=100',  data: {"order_id": orderId, "token": sharedPreferences.getString(AppConstants.TOKEN)},);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int orderId) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_URI}'));
    for(int i=0; i<file.length;i++){
      if(file != null) {
        File _file = File(file[i].path);
        print('----------XFile--------->');
        request.files.add(http.MultipartFile('image[]', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
      }
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message,
      'token':  sharedPreferences.getString(AppConstants.TOKEN),
      'order_id': orderId.toString(),

    });
    request.fields.addAll(_fields);
    print('=========>Message ==>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }

}
