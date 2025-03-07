import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'infoController.dart';


class InfoPage extends GetView<InfoController> {
  const InfoPage ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => InfoController());
    return Scaffold(
      appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
                children: <Widget>[
                  CarouselSlider(
                    items: controller.a,
                    carouselController: controller.buttonCarouselController,
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.0,
                      height: size.width+150,
                      enlargeCenterPage: true,
                      enableInfiniteScroll:false,
                      onPageChanged: (index, reason) {
                        controller.changeImage(index);
                      },
                    ),
                  ),
                  GetBuilder<InfoController>(
                    builder: (controller) {
                      return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30,),
                                GestureDetector(
                                  onHorizontalDragStart: (details) {
                                    print(details);
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    print(details);
                                  },
                                  child: QuillEditor.basic(
                                    controller: controller.b[controller.index1],
                                    configurations: QuillEditorConfigurations(
                                        scrollPhysics:NeverScrollableScrollPhysics(),
                                        showCursor: false,
                                        embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders()

                                    )
                                  ),
                                ),
                              ],
                            ),
                          );
                    }
                  ),
            const SizedBox(height: 50,)
                ]
            ),
          ),
        ),
      floatingActionButton: Obx(()=>
        controller.showBackToTopButton.value
        ? FloatingActionButton(
          backgroundColor: Colors.white,
        onPressed: controller.scrollToTop,
        tooltip: 'Scroll to top',
        child: const Icon(Icons.keyboard_double_arrow_up, color: Colors.black,),
            )
          : Container(),
      ), // 버튼 표시 조건
    );
  }
}
