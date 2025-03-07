import 'dart:math';

import 'package:get/get.dart';
import 'package:now_korea/model/info.dart';
import 'package:now_korea/repository/info.dart';



class MainHomeController extends GetxController {
  int randomNum = 0;
  RxList<InfoModel> info = <InfoModel>[].obs;
  List choiceImage = [
    {
      'choice1':'choiceImage1_1.png',
      'choice2':'choiceImage1_2.png',
      'choice3':'choiceImage1_3.png',
      'text':'ⓒ한국관광공사 사진갤러리 - 오도연,전우석,최서연'
    },
    {
      'choice1':'choiceImage2_1.png',
      'choice2':'choiceImage2_2.png',
      'choice3':'choiceImage2_3.png',
      'text':'ⓒ한국관광공사 사진갤러리 - IR 스튜디오,지병선,조광연'
    },
    {
      'choice1':'choiceImage3_1.png',
      'choice2':'choiceImage3_2.png',
      'choice3':'choiceImage3_3.png',
      'text':'ⓒ한국관광공사 사진갤러리 - 정성주,한국관광공사 조우진,김용천'
    },
  ];
  InfoRepository infoRepository = InfoRepository();
  @override
  void onInit() {
    super.onInit();
    randomNum = Random().nextInt(3);
    getInfo();
  }
  getInfo() async {
    info.value = await infoRepository.getInfo();
  }
}
