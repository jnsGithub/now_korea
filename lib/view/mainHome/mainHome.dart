import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../admob/mainBanner.dart';
import 'mainHomeController.dart';





class MainHome extends GetView<MainHomeController> {
  const MainHome ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => MainHomeController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Now Korea',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
          leading: const Image(image: AssetImage('image/img.png'),width: 50,fit: BoxFit.fitWidth,),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                            Get.toNamed('/ar');
                          },
                          child: Text('더보기 >')
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: size.width,
                    height: 200,
                    child: Obx(()=>
                        ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.info.length,
                        controller: PageController(viewportFraction: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Get.toNamed('/infoPage',arguments: controller.info[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 150,
                              height: 210,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl: controller.info[index].infoList[0]['url'],
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Festivals & Cultural',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed('/vectorMap',arguments:'Festival' );
                        // setState(() {
                        //   Navigator.push(
                        //       context, MaterialPageRoute(builder: (_) {
                        //     return const HomePage(dropdownValue: 'Festival');
                        //   }));
                        // });
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            width: size.width*0.47,
                            height: size.width*0.47,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Image(
                                image: AssetImage('image/festival.png'),
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              width: size.width*0.47,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter, // 그라데이션 시작점 (위)
                                  end: Alignment.topCenter, // 그라데이션 끝점 (아래)
                                  colors: [
                                    Colors.black,  // 시작 색상
                                    Colors.black12,   // 끝 색상
                                  ],
                                ),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: const Text('Festival',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed('/vectorMap',arguments:'Culture' );
                        // setState(() {
                        //   Navigator.push(
                        //       context, MaterialPageRoute(builder: (_) {
                        //     return const HomePage(dropdownValue: 'Culture');
                        //   }));
                        // });
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: size.width*0.47,
                            height: size.width*0.47,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Image(
                                image: AssetImage('image/culture.png'),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                              width: size.width*0.47,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter, // 그라데이션 시작점 (위)
                                  end: Alignment.topCenter, // 그라데이션 끝점 (아래)
                                  colors: [
                                    Colors.black,  // 시작 색상
                                    Colors.black12,   // 끝 색상
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: const Text('Culture',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),)
                          )
                        ],
                      ),
                    )
                  ],
                ),
                // GestureDetector(
                //   onTap: (){
                //     // setState(() {
                //     //   Navigator.push(
                //     //       context, MaterialPageRoute(builder: (_) {
                //     //     return const YoutubePage();
                //     //   }));
                //     // });
                //   },
                //   child: SizedBox(
                //     width: size.width,
                //     height: size.width*0.47,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8.0),
                //       child: Image(
                //         image: AssetImage('image/${controller.choiceImage[controller.randomNum]['choice3']}'),
                //       ),
                //     ),
                //   ),
                // ),
              ]
          ),
        ),
      bottomNavigationBar: const SafeArea(child: SizedBox(height:50,child: Center(child: MainBanner()))),
    );
  }
}
