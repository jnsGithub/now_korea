// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:now_korea/admob/worldCupBanner.dart';
// import 'package:now_korea/utile/gradientText.dart';
// import 'package:now_korea/worldCupItemPage.dart';
//
//
// class WorldCupPage extends StatefulWidget {
//   const WorldCupPage({Key? key}) : super(key: key);
//
//   @override
//   State<WorldCupPage> createState() => _WorldCupPageState();
// }
//
// class _WorldCupPageState extends State<WorldCupPage> {
//
//   List item = [];
//   List roundString = ['Round of 32','Round of 16','Round of 8','Round of 4'];
//   List roundOf = [64,32,16,8];
//
//   int roundValue = 8;
//   int bannerIndex = 0;
//
//
//   Future<void> getItem() async {
//     try {
//       String url = 'https://lsagwanaklucky.com/nowKorea/worldCupItem';
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//       var dataJson = jsonDecode(response.body);
//       setState(() {
//         item = dataJson['message'];
//         item.shuffle();
//       });
//     } catch (e) {
//
//     }
//   }
//   round(itemBody){
//     roundString = ['Round of 32','Round of 16','Round of 8','Round of 4'];
//     roundOf = [32,16,8,4];
//     int itemLength = itemBody['worldCupBody'].length;
//     int itemCount = 1;
//     if(itemLength >= 64){
//       itemCount = 4;
//     } else if(itemLength >= 32){
//       roundString.removeRange(0, 1);
//       roundOf.removeRange(0, 1);
//       itemCount = 3;
//     } else if(itemLength >= 16){
//       roundString.removeRange(0, 2);
//       roundOf.removeRange(0, 2);
//       itemCount = 2;
//     } else {
//       roundString.removeRange(0, 3);
//       roundOf.removeRange(0, 3);
//     }
//     showDialog(
//       context: context,
//       // barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
//       builder: ((context) {
//         return Dialog(
//           child:Container(
//             width: 300,
//             height: 300,
//             alignment: Alignment.center,
//             child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: itemCount,
//                 scrollDirection:Axis.vertical,
//                 separatorBuilder: (BuildContext context, int index) => const Divider(),
//                 // allowImplicitScrolling:true,
//                 itemBuilder: (BuildContext ctx, int index) {
//                   return
//                     TextButton(
//                         onPressed: (){
//                           Navigator.pop(context);
//                           Navigator.push(
//                               context, MaterialPageRoute(builder: (_) {
//                             return WorldCupItemPage(item:itemBody,roundValue:roundOf[index]);}));
//                         },
//                         child:Text(roundString[index]),
//                     );
//                 }),
//           ),
//         );
//       }),
//     );
//   }
//   @override
//   void initState() {
//     super.initState();
//     getItem();
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         height: size.height,
//         color: Colors.black,
//         child: SafeArea(
//           child:
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               ListView.separated(
//                   itemCount: item.length,
//                   scrollDirection:Axis.vertical,
//                   // allowImplicitScrolling:true,
//                   itemBuilder: (BuildContext ctx, int index) {
//                     List a = [];
//                     a = item[index]['worldCupBody'];
//                     a.sort((a, b) => (b['ranking']).compareTo(a['ranking']));
//                     return GestureDetector(
//                       onTap: (){
//                         round(item[index]);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 30),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Image(image: NetworkImage(a[0]['youtubeImage']),fit: BoxFit.fitWidth,),
//                                 Container(
//                                   width: size.width,
//                                   height: 360*(size.width/480),
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.black54,
//                                   ),
//                                   child:  const GradientText(
//                                     text: 'VS', gradient: LinearGradient(colors: [
//                                     Colors.redAccent,
//                                     Colors.yellowAccent,
//                                   ]),
//                                     style: TextStyle(fontSize: 45.0,fontFamily: 'Kalam'),),
//                                 )
//                               ],
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(top: 15),
//                               child: Text(item[index]['worldCupKindOf'],style: const TextStyle(
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.w700,
//                                 color: Colors.white
//                               ),textAlign: TextAlign.center,),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                       // callBanner?  const YoutubeBanner():
//                     //   GestureDetector(
//                     //     onTap: (){
//                     //
//                     //     },
//                     //     child: Column(
//                     //       children: [
//                     //         Image(image: NetworkImage(item[index]['youtubeImage']),fit: BoxFit.fitWidth,),
//                     //         Container(
//                     //           margin: const EdgeInsets.only(bottom: 10),
//                     //           child: Text(item[index]['title'],style: const TextStyle(
//                     //               fontSize: 19,
//                     //               fontWeight: FontWeight.w500
//                     //           ),textAlign: TextAlign.center,),
//                     //         )
//                     //       ],
//                     //     ),
//                     //   );
//                     //
//                     // //   Container(
//                     // //   width: size.width,
//                     // //   decoration: BoxDecoration(
//                     // //     image: DecorationImage(
//                     // //       image: NetworkImage(item[index]['youtubeImage'])
//                     // //     )
//                     // //   ),
//                     // // );
//                   },  separatorBuilder: (BuildContext context, int index) => const Divider(),
//               ),
//               const Positioned(
//                   bottom: 0,
//                   child: WorldCupBanner()
//               )
//             ],
//           ),
//         ),
//       ),
//       // floatingActionButton:Container(
//       //   decoration: const BoxDecoration(
//       //       color: Colors.deepPurpleAccent,
//       //       borderRadius: BorderRadius.all(Radius.circular(90))
//       //   ),
//       //   child: IconButton(
//       //     onPressed: (){
//       //
//       //     },
//       //     color: Colors.white,
//       //     icon: const Icon(Icons.add_circle_outline,size: 37),
//       //   ),
//       // ),
//     );
//   }
// }
