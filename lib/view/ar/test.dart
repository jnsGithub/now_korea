// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
// class ARCoreExample extends StatefulWidget {
//   const ARCoreExample({Key? key}) : super(key: key);
//
//   @override
//   _ARCoreExampleState createState() => _ARCoreExampleState();
// }
//
// class _ARCoreExampleState extends State<ARCoreExample> {
//   ArCoreController? arCoreController;
//   bool modelAdded = false;
//
//   @override
//   void dispose() {
//     arCoreController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ARCore Flutter Plugin Example'),
//       ),
//       body: ArCoreView(
//         onArCoreViewCreated: _onArCoreViewCreated,
//         enableTapRecognizer: true, // 탭 이벤트가 필요하면 true
//       ),
//     );
//   }
//
//   void _onArCoreViewCreated(ArCoreController controller) async {
//     arCoreController = controller;
//     await Future.delayed(Duration(seconds: 2));
//     // ARCore가 주변 환경을 충분히 인식(Tracking)하기 전에는
//     // 모델이 안 보일 수 있으므로, 몇 초 기다리거나
//     // 카메라 트래킹 상태를 체크한 뒤 추가하는 것을 권장합니다.
//     // 여기서는 단순히 초기화 직후 곧바로 추가하는 예시만 보여줍니다.
//     _addGLBModel();
//   }
//
//   Future<void> _addGLBModel() async {
//     if (arCoreController == null || modelAdded) return;
//
//     // GLB 모델(원격 URL 예시)
//     final node = ArCoreReferenceNode(
//       name: "MyGLBModel",
//       // 실제 GLB 모델이 있는 URL로 교체하세요
//       objectUrl:
//       "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Box/glTF-Binary/Box.glb",
//       position: vector.Vector3(0.0, 0.0, -1.0),  // 카메라 앞 -1m 지점
//       scale: vector.Vector3(0.5, 0.5, 0.5),     // 모델 크기 조정
//     );
//
//     try {
//       await arCoreController!.addArCoreNode(node);
//       modelAdded = true;
//       debugPrint("✅ GLB 모델 노드가 씬에 추가되었습니다!");
//     } catch (e) {
//       debugPrint("❌ GLB 모델 추가 실패: $e");
//     }
//   }
// }
