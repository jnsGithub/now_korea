class InfoModel {
  final String documentId;
  final DateTime createDate;
  final List infoList;

  InfoModel({required this.documentId,required this.createDate, required this.infoList});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      documentId: json['documentId'],
      createDate: DateTime.fromMillisecondsSinceEpoch(json['createDate'].seconds * 1000),
      infoList: json['infoList'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'createDate': createDate.millisecondsSinceEpoch ~/ 1000,
      'infoList': infoList,
    };
  }
}
