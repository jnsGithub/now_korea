// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:now_korea/admob/youtubeBanner.dart';
// import 'package:now_korea/player.dart';
//
//
// class YoutubePage extends StatefulWidget {
//   const YoutubePage({Key? key}) : super(key: key);
//
//   @override
//   State<YoutubePage> createState() => _YoutubePageState();
// }
//
// class _YoutubePageState extends State<YoutubePage> {
//   List item = [];
//   int bannerIndex = 0;
//
//   Future<void> getYoutube() async {
//     try{
//       String url = 'https://lsagwanaklucky.com/community/youtube';
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//       var dataJson = jsonDecode(response.body);
//       setState(() {
//         item = dataJson;
//         item.shuffle();
//       });
//     } catch (e){
//
//     }
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getYoutube();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Trip to Korea',style: TextStyle(fontWeight: FontWeight.w600),),
//       ),
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Container(
//               padding: EdgeInsets.zero,
//               width: size.width,
//               height: size.height,
//               child: ListView.builder(
//                 itemCount: item.length,
//                   scrollDirection:Axis.vertical,
//                   // allowImplicitScrolling:true,
//                 itemBuilder: (BuildContext ctx, int index) {
//                   return
//                     // callBanner?  const YoutubeBanner():
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(
//                           context, MaterialPageRoute(builder: (_) {
//                             return Player(item[index]['id']);
//                           }));
//                     },
//                     child: Column(
//                       children: [
//                         Image(image: NetworkImage(item[index]['youtubeImage']),fit: BoxFit.fitWidth,),
//                         Container(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           child: Text(item[index]['title'],style: const TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.w500
//                           ),textAlign: TextAlign.center,),
//                         )
//                       ],
//                     ),
//                   );
//
//                   //   Container(
//                   //   width: size.width,
//                   //   decoration: BoxDecoration(
//                   //     image: DecorationImage(
//                   //       image: NetworkImage(item[index]['youtubeImage'])
//                   //     )
//                   //   ),
//                   // );
//                 }
//               ),
//             ),
//             const Positioned(
//                 bottom: 0,
//                 child: YoutubeBanner()
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
