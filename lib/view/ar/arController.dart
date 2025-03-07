
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vector_math/vector_math_64.dart';



class ArController extends GetxController {
  // late ARSessionManager arSessionManager;
  // late ARObjectManager arObjectManager;
  // late ARAnchorManager arAnchorManager;

  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose(){
    // arSessionManager.dispose();
    super.onClose();
  }
  // onARViewCreated(
  //     ARSessionManager arSessionManager,
  //     ARObjectManager arObjectManager,
  //     ARAnchorManager arAnchorManager,
  //     ARLocationManager arLocationManager) {
  //   this.arSessionManager = arSessionManager;
  //   this.arObjectManager = arObjectManager;
  //   this.arAnchorManager = arAnchorManager;
  //
  //   this.arSessionManager.onInitialize(
  //     showFeaturePoints: false,
  //     showPlanes: true,
  //     customPlaneTexturePath: "assets/triangle.png",
  //     showWorldOrigin: true,
  //   );
  //   this.arObjectManager.onInitialize();
  // }
}
