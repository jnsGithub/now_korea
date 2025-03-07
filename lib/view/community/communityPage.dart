import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:now_korea/view/community/communityController.dart';

import '../../component/textfield.dart';
import '../../global.dart';





class CommunityPage extends GetView<CommunityController> {
  const CommunityPage ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => CommunityController());
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
                children: [
                  TextFieldComponent(text: '제목', controller: controller.title, multi: false, color: gray700, typeNumber: false,),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 390,
                            child: QuillSimpleToolbar(
                              controller: controller.textController,
                              configurations:  QuillSimpleToolbarConfigurations(
                                showDirection:true,
                                embedButtons:   FlutterQuillEmbeds.toolbarButtons(
                                    imageButtonOptions : const QuillToolbarImageButtonOptions()
                                ),
                                showLineHeightButton:true,

                              ),
                            ),
                          ),
                          Container(
                            width: 390,
                            height: 390,
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: gray300),
                            ),
                            child: QuillEditor.basic(
                              controller: controller.textController,
                            ),
                          ),
                          const SizedBox(height: 30,)
                        ],
                      ),
                    ],
                  ),
                ]
            ),
          )
      ),
    );
  }
}
