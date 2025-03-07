import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';

/// 사용자 위치와 타겟 위치를 바탕으로, AR 상에서 쓸 오프셋 계산
/// (동쪽양수 / 서쪽음수, 북쪽음수 / 남쪽양수)
Vector3 calculateOffsetFromGPS({
  required double userLat,
  required double userLon,
  required double targetLat,
  required double targetLon,
}) {
  // 위도 1도당 약 111,320m
  const double metersPerLat = 111320.0;
  // 경도 1도당 거리는 위도에 따라 달라짐
  double metersPerLon = 111320.0 * cos(userLat * pi / 180);

  double deltaLat = targetLat - userLat;
  double deltaLon = targetLon - userLon;

  // 북쪽 방향: -z, 동쪽 방향: +x 로 가정
  double northOffset = deltaLat * metersPerLat; // +면 북쪽, -면 남쪽
  double eastOffset = deltaLon * metersPerLon;  // +면 동쪽, -면 서쪽

  // AR 좌표계에서 x=동쪽(+), z=남쪽(+)
  // 따라서 "북쪽으로 10m"라면 z가 -10이 되어야 하므로
  // z에 -northOffset, x에 +eastOffset
  return Vector3(eastOffset, 0.0, -northOffset);
}

class ArPage extends StatefulWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  ARSessionManager? arSessionManager;
  ARAnchorManager? arAnchorManager;
  ARObjectManager? arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  // 사용자 현재 위치
  late Position currentPosition;
  bool gotLocation = false;

  // 타겟 좌표 (예시)
  final double targetLat = 37.520509;
  final double targetLon = 126.890258;

  // 노드 참조
  ARNode? anchoredNode;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("위치 서비스가 비활성화되어 있습니다.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("위치 권한이 거부되었습니다.");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint("위치 권한이 영구적으로 거부되었습니다.");
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      gotLocation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR GPS 10m 이내 표시 예제"),
      ),
      body: gotLocation
          ? ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      handleTaps: false,
      showAnimatedGuide: false,
    );
    this.arObjectManager!.onInitialize();
    _addGPSBasedAnchor();
  }

  Future<void> _addGPSBasedAnchor() async {
    // 1) 사용자 위치와 타겟 간 거리(m) 계산
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLat,
      targetLon,
    );
    debugPrint(
        "타겟까지 거리: ${distanceInMeters.toStringAsFixed(2)}\n\n\n\n\n\n\n m");

    // 2) 만약 10m 이내라면 AR 오브젝트 추가
    if (distanceInMeters <= 30.0) {
      debugPrint("10m 이내! AR 오브젝트를 배치합니다.");

      // 기존 노드가 있으면 제거
      if (anchoredNode != null) {
        await arObjectManager!.removeNode(anchoredNode!);
        anchoredNode = null;
      }

      // (x, y, z) 오프셋 계산
      Vector3 offset = calculateOffsetFromGPS(
        userLat: currentPosition.latitude,
        userLon: currentPosition.longitude,
        targetLat: targetLat,
        targetLon: targetLon,
      );
      debugPrint("계산된 AR 오프셋: $offset");
      Matrix4 anchorPose = Matrix4.identity();
      anchorPose.setTranslation(offset); // 여기서 offset이 (x, y, z)
      print('asdsadasda\n\n\n\n\n${anchorPose.toString()}');
// 2) PlaneAnchor (혹은 그냥 Anchor) 생성
      ARPlaneAnchor myAnchor = ARPlaneAnchor(transformation: anchorPose);

      Timer.periodic(Duration(seconds: 1), (timer) async {
        final trackingState = await this.arSessionManager?.getTrackingState();
        if (trackingState == "TRACKING") {
          var anchor = await this.arAnchorManager!.addAnchor(myAnchor);
          print(anchor);
          print('jdhfksdjhfs\n\n\n\dsadad');
          if (anchor == null) {
            print("앵커 생성 실패");
            return;
          }
          // 계산된 오프셋을 AR 월드 좌표계의 변환 행렬로 사용합니다.
          // Matrix4 anchorPose = Matrix4.identity();
          //
          // anchorPose.setTranslation(offset);
          // ARPlaneAnchor myAnchor = ARPlaneAnchor(transformation: anchorPose);
          // var anchor = await arAnchorManager!.addAnchor(myAnchor);
          // if (anchor == null) {
          //   print("앵커 생성에 실패했습니다.");
          //   return;
          // }
          if (this.webObjectNode != null) {
            this.arObjectManager!.removeNode(this.webObjectNode!);
            this.webObjectNode = null;
          } else {
            var newNode = ARNode(
              type: NodeType.webGLB,
              uri:
              "https://github.com/KhronosGroup/glTF-Sample-Models/raw/refs/heads/main/2.0/Duck/glTF-Binary/Duck.glb",
              scale: Vector3(0.2, 0.2, 0.2),
              position: offset,
            );
            bool? didAddWebNode = await this.arObjectManager!.addNode(
                newNode, planeAnchor: anchor);
            this.webObjectNode = (didAddWebNode!) ? newNode : null;
          }
          timer.cancel();
        }
      });
// 3) AnchorManager를 통해 앵커 등록
    }
  }
}
