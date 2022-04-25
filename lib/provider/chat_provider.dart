
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/chat_model.dart';
import 'package:resturant_delivery_boy/data/repository/chat_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:resturant_delivery_boy/view/base/custom_snackbar.dart';
class ChatProvider with ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});
  List<Messages>  _messages = [];
  List<Messages> get messages => _messages;
  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  List <XFile> _imageFile;
  List <XFile> get imageFile => _imageFile;
  List <XFile>_chatImage = [];
  List<XFile> get chatImage => _chatImage;

  bool _isLoading= false;
  bool get isLoading => _isLoading;
  Future<void> getChatMessages (BuildContext context, int orderId) async {
    ApiResponse apiResponse = await chatRepo.getMessage(orderId,1);
    _messages = [];
    if (apiResponse.response != null&& apiResponse.response.data['messages']!= {} && apiResponse.response.statusCode == 200) {
      _messages.addAll(ChatModel.fromJson(apiResponse.response.data).messages);
    } else {
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    notifyListeners();
  }

  void pickImage(bool isRemove) async {
    final ImagePicker _picker = ImagePicker();
    if(isRemove) {
      _imageFile = [];
      _chatImage = [];
    }else {
      _imageFile = await _picker.pickMultiImage(imageQuality: 30);
        if (_imageFile != null) {
          _chatImage.addAll(_imageFile);
        }
    }
    _isSendButtonActive = true;
    notifyListeners();
  }
  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int orderId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessage(message, file, orderId);
    if (response.statusCode == 200) {
      _imageFile = [];
      _chatImage = [];
      file =[];
      getChatMessages(context, orderId);
      _isLoading= false;
    } else {
      showCustomSnackBar('write something...', context);
    }
    _imageFile = [];
    _isLoading= false;
    notifyListeners();
    return response;
  }

}
