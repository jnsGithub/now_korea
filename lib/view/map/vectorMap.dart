import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:now_korea/view/map/VectorMapController.dart';
import 'package:vector_map/vector_map.dart';

import '../../admob/mainBanner.dart';
import '../../main.dart';
import 'package:lottie/lottie.dart'as lottie;





class VectorMapView extends GetView<VectorController> {
  const VectorMapView ({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => VectorController());
    return GetBuilder<VectorController>(
      builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.dropdownValue,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 23),),
          ),
          body: SafeArea(
            child: controller.loading?
            Column (
              children: [
                // Container(
                //   width: size.width,
                //   height: 40,
                //   margin: const EdgeInsets.only(bottom: 12,top: 8),
                //   child: TabBar(
                //     isScrollable : false,
                //     tabs:const [
                //       Text('Festival',style: TextStyle(
                //         // color: Colors.black45,
                //           fontSize: 19
                //       ),),
                //       Text('Culture',style: TextStyle(
                //         // color: Colors.black45,
                //           fontSize: 19
                //       ),)
                //     ],
                //     onTap:(int index){
                //       setState(() {
                //         festivalOrCulture = index == 0 ? true:false;
                //       });
                //     },
                //     // indicatorColor:Colors.purple ,
                //     labelColor: Colors.black,
                //     unselectedLabelColor: Colors.black45,
                //     controller: tabAreaCodeController,
                //   ),
                // ),
                SizedBox(
                  width: size.width,
                  height: 40,
                  child: TabBar(
                    isScrollable : true,
                    tabs:controller.data.map((Model choice){
                      return Text(choice.name,style: const TextStyle(
                        // color: Colors.black45,
                          fontSize: 19
                      ),);
                    }).toList(),
                    onTap:(int index){
                      controller.tabChange(index);

                    },
                    // indicatorColor:Colors.purple ,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black45,
                    controller: controller.tabController,
                  ),
                ),
                Expanded(
                    child:
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        VectorMap(
                          controller: controller.vecController,
                          clickListener: (feature) =>
                          {
                            controller.clickListener(feature)
                          }
                        ),
                        const Positioned(
                            bottom: 0,
                            child: MainBanner()
                        ),
                        Positioned(
                            bottom: 27,
                            right: 16,
                            child: Container()
                        ),
                      ],
                    )
                ),
              ],
            ): Center( child: lottie.Lottie.asset('image/koreaLottie.json',width: 150,height: 150),) ,
          ),

        );
      }
    );
  }
}
//    // floatingActionButton:  !firstChoice ? Container():loading?Column(
//       //   mainAxisAlignment: MainAxisAlignment.end,
//       //   children: [
//       //     // Container(
//       //     //   margin: const EdgeInsets.only(bottom: 9),
//       //     //   decoration: const BoxDecoration(
//       //     //       color: Colors.deepPurpleAccent,
//       //     //       borderRadius: BorderRadius.all(Radius.circular(90))
//       //     //   ),
//       //     //   child: IconButton(
//       //     //     color: Colors.white,
//       //     //     onPressed: (){
//       //     //       Navigator.push(
//       //     //           context, MaterialPageRoute(builder: (_) {
//       //     //         return ChatGPT();
//       //     //       }));
//       //     //     },
//       //     //     icon: const Icon(Icons.remove_circle_outline,size: 37),
//       //     //   ),
//       //     // ),
//       //     Container(
//       //       margin: const EdgeInsets.only(bottom: 9),
//       //       decoration: const BoxDecoration(
//       //           color: Colors.deepPurpleAccent,
//       //           borderRadius: BorderRadius.all(Radius.circular(90))
//       //       ),
//       //       child: IconButton(
//       //         color: Colors.white,
//       //         onPressed: (){
//       //           _controller!.zoomOnCenter(false);
//       //           setState(() {
//       //             MapLayer layer = MapLayer(
//       //                 dataSource: polygons,
//       //                 theme: MapRuleTheme(contourColor:Colors.black26, colorRules: [
//       //                       (feature) {
//       //                     int? value = feature.id - 1;
//       //                     return value == selectedIndex ? Colors.deepPurpleAccent : null;
//       //                   },
//       //                 ])
//       //             );
//       //             _controller = VectorMapController(layers: [layer], delayToRefreshResolution: 0 ,minScale: scale-9);
//       //             scale = scale -9;
//       //           });
//       //         },
//       //         icon: const Icon(Icons.remove_circle_outline,size: 37),
//       //       ),
//       //     ),
//       //     Container(
//       //       decoration: const BoxDecoration(
//       //           color: Colors.deepPurpleAccent,
//       //           borderRadius: BorderRadius.all(Radius.circular(90))
//       //       ),
//       //       child: IconButton(
//       //         onPressed: (){
//       //           _controller!.zoomOnCenter(true);
//       //           setState(() {
//       //             scale = _controller.scale;
//       //           });
//       //         },
//       //         color: Colors.white,
//       //         icon: const Icon(Icons.add_circle_outline,size: 37),
//       //       ),
//       //     ),
//       //   ],
//       // ):Container(),
