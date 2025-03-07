// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:lottie/lottie.dart';
// import 'package:now_korea/player.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'admob/worldCupItemPageBanner.dart';
//
// class WorldCupItemPage extends StatefulWidget {
//   final Map item;
//   final int roundValue;
//   const WorldCupItemPage({Key? key, required this.item, required this.roundValue}) : super(key: key);
//
//   @override
//   State<WorldCupItemPage> createState() => _WorldCupItemPageState();
// }
//
// class _WorldCupItemPageState extends State<WorldCupItemPage> {
//
//   int roundValue = 0;
//   int currentIndex = 1;
//   int rankingTotal = 0;
//
//   List itemList = [];
//   List winnerItem = [];
//
//   bool rankingView = false;
//   bool visible = true;
//   bool isLoading = false;
//
//   Map<String, String> UNIT_ID = kReleaseMode
//       ? {
//     'ios': 'ca-app-pub-6941395151791292/2261297913',
//     'android': 'ca-app-pub-6941395151791292/1930125428',
//   }
//       : {
//     'ios': 'ca-app-pub-3940256099942544/4411468910',
//     'android': 'ca-app-pub-3940256099942544/1033173712',
//   };
//
//   InterstitialAd? _interstitialAd;
//
//   Future<void> winner(item) async {
//     _loadAd();
//     try {
//       setState(() {
//         isLoading = true;
//         rankingView = true;
//       });
//       String url = 'https://lsagwanaklucky.com/nowKorea/worldCupWinner';
//       Map data = {
//         'worldCupId':widget.item['_id'],
//         'id':item['id'],
//       };
//       var body = jsonEncode(data);
//       http.Response response = await http.post(
//           Uri.parse(url),
//           headers: {"Content-Type": "application/json"},
//           body: body
//       );
//       var dataJson = jsonDecode(response.body);
//       setState(() {
//         itemList = dataJson['message']['worldCupBody'];
//         itemList.sort((a, b) => (b['ranking']).compareTo(a['ranking']));
//         num a =1;
//         for(var i in itemList){
//           a = a + i['ranking'];
//
//         }
//         rankingTotal = a.toInt();
//         isLoading = false;
//         visible = false;
//       });
//     } catch (e) {
//
//     }
//   }
//   void _loadAd() async {
//     TargetPlatform os = Theme.of(context).platform;
//     await InterstitialAd.load(
//         adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           // Called when an ad is successfully received.
//           onAdLoaded: (ad) {
//             ad.fullScreenContentCallback = FullScreenContentCallback(
//               // Called when the ad showed the full screen content.
//                 onAdShowedFullScreenContent: (ad) {},
//                 // Called when an impression occurs on the ad.
//                 onAdImpression: (ad) {},
//                 // Called when the ad failed to show full screen content.
//                 onAdFailedToShowFullScreenContent: (ad, err) {
//                   // Dispose the ad here to free resources.
//                   ad.dispose();
//                 },
//                 // Called when the ad dismissed full screen content.
//                 onAdDismissedFullScreenContent: (ad) {
//                   // Dispose the ad here to free resources.
//                   ad.dispose();
//                 },
//                 // Called when a click is recorded for an ad.
//                 onAdClicked: (ad) {
//
//                 });
//
//             debugPrint('$ad loaded.');
//             // Keep a reference to the ad so you can show it later.
//             _interstitialAd = ad;
//           },
//           // Called when an ad request failed.
//           onAdFailedToLoad: (LoadAdError error) {
//             debugPrint('InterstitialAd failed to load: $error');
//           },
//         ));
//
//   }
//   @override
//   void initState() {
//     super.initState();
//     itemList = List.from(widget.item['worldCupBody']);
//     itemList.shuffle();
//     roundValue = widget.roundValue;
//     itemList.removeRange(widget.roundValue, itemList.length);
//     Future.delayed(const Duration(seconds: 1)).then((value) => {
//       setState(() {
//         visible = false;
//       })
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     var nowHeight = size.height-((360*(size.width/480))*2+100);
//     var nowWidth = size.width;
//     if(nowHeight < 50){
//       nowWidth = nowWidth - 40;
//     }
//     return Scaffold(
//       body: isLoading ? Container(
//         width: size.width,
//         height: size.height,
//         color: Colors.black87,
//         child: Center(
//             child: Lottie.asset('image/koreaLottie.json',width: 100,height: 100)
//         ),
//       ):
//       Stack(
//         alignment: Alignment.center,
//         children: [
//           rankingView?
//           WillPopScope(
//             onWillPop: () async {
//               Navigator.pop(context);
//               _interstitialAd?.show();
//               return true;
//             },
//             child:  Container(
//               color: Colors.black,
//               child: Column(
//                 children: [
//                   SafeArea(
//                     child: SizedBox(
//                       width: size.width,
//                       height: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width:50,
//                             child: IconButton(
//                                 onPressed: (){
//                                   Navigator.pop(context);
//                                   _interstitialAd?.show();
//                                 }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 100,
//                               child: Text('RanKing',style: TextStyle(color: Colors.white,fontSize: 23,fontFamily: 'kalam'),)
//                           ),
//                           Container(
//                             width: 50,
//                             // child: IconButton(
//                             //     onPressed: (){
//                             //       Navigator.pop(context);
//                             //     }, icon: const Icon(Icons.T,color: Colors.white,)
//                             // ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.separated(
//                         itemCount: itemList.length,
//                         scrollDirection:Axis.vertical,
//                         separatorBuilder: (BuildContext context, int index) => const Divider(),
//                         // allowImplicitScrolling:true,
//                         itemBuilder: (BuildContext ctx, int index) {
//                           return Row(
//                             children: [
//                               Container(
//                                 width: size.width*0.35,
//                                 alignment: Alignment.center,
//                                 child: Image(image:
//                                 NetworkImage(itemList[index]['youtubeImage']
//                                   // NetworkImage(itemList[0]['youtubeImage']
//                                 ),
//                                   fit: BoxFit.fitWidth,
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: size.width*0.6,
//                                     padding:const EdgeInsets.only(left: 5),
//                                     child: Text(
//                                       itemList[index]['title'],
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 17,
//                                           // fontFamily: 'kalam'
//                                       ),
//                                     ),
//                                   ),
//                                   LinearPercentIndicator(
//                                     width: size.width*0.6,
//                                     animation: true,
//                                     lineHeight: 20.0,
//                                     animationDuration: 2000,
//                                     percent: itemList[index]['ranking']/rankingTotal,
//                                     center: Text('${(itemList[index]['ranking']/rankingTotal*100).toStringAsFixed(1)}%',style: const TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'kalam',
//                                       letterSpacing:1.5,
//                                     ),),
//                                     progressColor: Colors.greenAccent,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           );
//                         }),
//                   ),
//                 ],
//               ),
//             ),
//           )
//          :
//           Container(
//             color: Colors.black,
//             height: size.height,
//             child: SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(
//                               context, MaterialPageRoute(builder: (_) {
//                             return Player(itemList[0]['id']);
//                           }));
//                         },
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: nowWidth,
//                               alignment: Alignment.center,
//                               child: Image(image:
//                               NetworkImage(itemList[0]['youtubeImage']
//                               // NetworkImage(itemList[0]['youtubeImage']
//                               ),
//                                 fit: BoxFit.fitWidth,
//                               ),
//                             ),
//                             Container(
//                               width: nowWidth,
//                               height: 360*(nowWidth/480),
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                 color: Colors.black54,
//                               ),
//                               child: const Icon(Icons.play_arrow,size: 90,color: Colors.white70,),
//                             ),
//                             Positioned(
//                               bottom: 5,
//                                 left: 0,
//                                 child: SizedBox(
//                                   width: nowWidth,
//                                   child: Text(
//                                       itemList[0]['title'],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontFamily: 'kalam'
//                                     ),
//                                   ),
//                                 )
//                             )
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             if(roundValue==2){
//                               winner(itemList[0]);
//                             } else {
//                               winnerItem.add(itemList[0]);
//                               if(itemList.length == 2){
//                                 itemList = List.from(winnerItem);
//                                 winnerItem = [];
//                                 currentIndex = 1;
//                                 roundValue = roundValue~/2;
//                                 visible = true;
//                               } else {
//                                 itemList.removeRange(0, 2);
//                                 currentIndex ++;
//                                 visible = true;
//                               }
//                             }
//                           });
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           width: size.width,
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             color: Colors.deepOrangeAccent,
//                           ),
//                           child: const Text('Pick',style: TextStyle(fontSize: 35.0,fontFamily: 'Kalam',color: Colors.white70)),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(
//                               context, MaterialPageRoute(builder: (_) {
//                             return Player(itemList[1]['id']);
//                           }));
//                         },
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: nowWidth,
//                               alignment: Alignment.center,
//                               child: Image(image:
//                               NetworkImage(itemList[1]['youtubeImage']
//                                 // NetworkImage(itemList[0]['youtubeImage']
//                               ),
//                                 fit: BoxFit.fitWidth,
//                               ),
//                             ),
//                             Container(
//                               width: nowWidth,
//                               height: 360*(nowWidth/480),
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                 color: Colors.black54,
//                               ),
//                               child: const Icon(Icons.play_arrow,size: 120,color: Colors.white70,),
//                             ),
//                             Positioned(
//                                 bottom: 5,
//                                 left: 0,
//                                 child: SizedBox(
//                                   width: nowWidth,
//                                   child: Text(
//                                     itemList[1]['title'],
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontFamily: 'kalam'
//                                     ),
//                                   ),
//                                 )
//                             )
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             if(roundValue==2){
//                               winner(itemList[1]);
//
//                             } else {
//                               winnerItem.add(itemList[1]);
//                               if(itemList.length == 2){
//                                 itemList = List.from(winnerItem);
//                                 winnerItem = [];
//                                 currentIndex = 1;
//                                 roundValue = roundValue~/2;
//                                 visible = true;
//                               } else {
//                                 itemList.removeRange(0, 2);
//                                 currentIndex ++;
//                                 visible = true;
//                               }
//                             }
//                           });
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           width: size.width,
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             color: Colors.blueAccent,
//                           ),
//                           child: const Text('Pick',style: TextStyle(fontSize: 35.0,fontFamily: 'Kalam',color: Colors.white70)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//               child: AnimatedOpacity(
//                 // 필드값에 따라 출력 여부를 토클함
//                 opacity: visible ? 1.0 : 0.0,
//                   onEnd:(){
//                   setState(() {
//                     visible = false;
//                   });
//                   },
//                 // 애미메이션 효과에 소요되는 시간 설정
//                 duration: const Duration(milliseconds: 1500),
//                 // 컨테이너 추가
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: 200,
//                   height: 200,
//                   decoration: const BoxDecoration(
//                     color: Colors.black87,
//                     borderRadius: BorderRadius.all(Radius.circular(8))
//                   ),
//                   child: roundValue <=2?
//                   const Text('The Final',style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 35,
//                       fontWeight: FontWeight.w600
//                   ),textAlign: TextAlign.center,)
//                       :
//                   Text('${roundValue <= 4?'Semi Final':'Round of $roundValue'}\n( $currentIndex / ${roundValue~/2} )',style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 29,
//                       fontWeight: FontWeight.w600
//                   ),textAlign: TextAlign.center,),
//                 )
//               ),
//
//           ),
//           const Positioned(
//               bottom: 0,
//               child: WorldCupItemPageBanner()
//           )
//         ],
//       ),
//     );
//   }
// }
