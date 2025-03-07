import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../model/info.dart';

class InfoRepository {
  FirebaseStorage storage = FirebaseStorage.instance;
  final infoCollection = FirebaseFirestore.instance.collection('info');

  createInfo(title,infoList) async {
    try {
      await infoCollection.add({
        'title': title,
        'infoList': infoList,
        'createDate': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  getInfo() async {
    RxList<InfoModel> a = <InfoModel>[].obs;
    QuerySnapshot querySnapshot = await infoCollection.get();
    for(var doc in querySnapshot.docs){
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentId'] = doc.id;
      a.add(InfoModel.fromJson(data));
    }

    return a;
  }
  // getExhibitionInfo() async {
  //   DocumentSnapshot documentSnapshot = await exhibitionCollection.doc(exhibitionInfo.documentId).get();
  //   Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //   data['documentId'] = documentSnapshot.id;
  //   return Exhibition.fromJson(data);
  // }
  //

}
