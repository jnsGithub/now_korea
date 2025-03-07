import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:now_korea/model/info.dart';



class InfoController extends GetxController {
  CarouselSliderController buttonCarouselController = CarouselSliderController();
  late InfoModel info;
  List<Widget> a = [];
  List<QuillController> b = <QuillController>[];
  RxBool showBackToTopButton = false.obs;
  ScrollController scrollController = ScrollController();
  int index1 = 0;
  @override
  void onInit() {
    super.onInit();
    info = Get.arguments;
    scrollController.addListener(() {
      if (scrollController.offset > 300) {
        // 스크롤 위치가 300 이상일 때 탑 버튼 표시

          showBackToTopButton.value = true;

      } else {

          showBackToTopButton.value = false;

      }
    });
    getInfo();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
  }
  scrollToTop() {
    scrollController.animateTo(
      0, // 0으로 이동
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  changeImage(int index){
    index1=index;
    update();
  }
  getInfo(){
    for(var i in info.infoList){
      final json = jsonDecode(i['eng']);
      QuillController controller = QuillController.basic();
      Size size = MediaQuery.of(Get.context!).size;
      controller.document = Document.fromJson(json);
      controller.readOnly = true;
      a.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: i['url'],
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fitWidth,
            width: size.width,
          ),
         ),
      );
      b.add( controller);
    }
    update();
  }
  // Widget a (){
  //   Size size = MediaQuery.of(Get.context!).size;
  //   return Image(
  //       image: AssetImage('image/travel_supplies.jpg'),
  //     fit: BoxFit.fitWidth,
  //     width: size.width,
  //   );
  // }
}
