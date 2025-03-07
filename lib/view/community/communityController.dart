import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



class CommunityController extends GetxController {
  TextEditingController title = TextEditingController();
  QuillController textController = QuillController.basic();
  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose(){
    super.onClose();
    textController.dispose();
  }


}
