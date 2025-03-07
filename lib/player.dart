// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
//
//
// class Player extends StatefulWidget {
//   final String _videoID;
//   const Player(this._videoID, {super.key});
//
//   @override
//   PlayerState createState() => PlayerState(_videoID);
// }
//
// class PlayerState extends State<Player> {
//   final String _videoID;
//
//   PlayerState(this._videoID);
//
//   late YoutubePlayerController _controller;
//   String routeName = '유튜브 영상 시청';
//   // void _sendCurrentTabToAnalytics() {
//   //   widget.observer.analytics.setCurrentScreen(
//   //     screenName: '${widget.queryKind} $routeName',
//   //     screenClassOverride: '레죠아',
//   //   );
//   // }
//   @override
//   void initState() {
//     // _sendCurrentTabToAnalytics();
//     _controller = YoutubePlayerController(
//       initialVideoId: _videoID,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         // isLive: true,
//       ),
//     );
//
//     YoutubePlayer(
//       controller: _controller,
//       liveUIColor: Colors.amber,
//     );
//
//     super.initState();
//   }
//   @override
//   void deactivate() {
//     _controller.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     if(_controller.value.isFullScreen){
//       _controller.toggleFullScreenMode();
//     }
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       left: false,
//       right: false,
//       child: Container(
//         padding: const EdgeInsets.only(),
//         width: size.width*1,
//         height:size.height*1,
//         child: YoutubePlayer(
//           key: ObjectKey(_controller),
//           controller: _controller,
//           actionsPadding: const EdgeInsets.only(left: 16.0),
//           bottomActions: const [
//             CurrentPosition(),
//             SizedBox(width: 10.0),
//             ProgressBar(isExpanded: true),
//             SizedBox(width: 10.0),
//             RemainingDuration(),
//             FullScreenButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }
