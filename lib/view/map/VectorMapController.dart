
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_map/vector_map.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart'as lottie;
import '../../global.dart';
import '../../itemPage.dart';
import '../../main.dart';
import '../../mapPage.dart';



class VectorController extends GetxController with GetTickerProviderStateMixin {
  List<Model> data = <Model>[


    // Model('Seoul'),
    // Model('Busan'),
    // Model('Daegu'),
    // Model('Incheon'),
    // Model('Gwangju'),
    // Model('Daejeon'),
    // Model('Ulsan'),
    // Model('Sejong-si'),
    // Model('Gyeonggi-do'),
    // Model('Gangwon-do'),
    // Model('Chungcheongbuk-do'),
    // Model('Chungcheongnam-do'),
    // Model('Jeollabuk-do'),
    // Model('Jellanam-do'),
    // Model('Gyeongsangbuk-do'),
    // Model('Gyeongsangnam-do'),
    // Model('Jeju-do')
  ];
  List festivalItem = [];
  List cultureItem = [];
  List item = [];

  int selectedIndex = 0;
  int randomNum = 0;


  String dropdownValue = 'Festival';

  double translateX = 0.0;
  double translateY = 0.0;
  double scale = 83.08435860753484;

  bool splash = false;
  bool loading = false;
  bool firstChoice  = false;

  late TabController tabController;
  late TabController tabAreaCodeController;

  late VectorMapController vecController;
  late MapDataSource polygons;
  @override
  void onInit() {
    dropdownValue = Get.arguments;
    if(local == 'en'){
      data = [
        Model('Seoul'),
        Model('Busan'),
        Model('Daegu'),
        Model('Incheon'),
        Model('Gwangju'),
        Model('Daejeon'),
        Model('Ulsan'),
        Model('Sejong-si'),
        Model('Gyeonggi-do'),
        Model('Gangwon-do'),
        Model('Chungcheongbuk-do'),
        Model('Chungcheongnam-do'),
        Model('Jeollabuk-do'),
        Model('Jellanam-do'),
        Model('Gyeongsangbuk-do'),
        Model('Gyeongsangnam-do'),
        Model('Jeju-do')
      ];
    } else {
      data = <Model>[
        Model('ソウル'), // Seoul
        Model('プサン'), // Busan
        Model('テグ'), // Daegu
        Model('インチョン'), // Incheon
        Model('クァンジュ'), // Gwangju
        Model('テジョン'), // Daejeon
        Model('ウルサン'), // Ulsan
        Model('セジョンシ'), // Sejong-si
        Model('キョンギ道'), // Gyeonggi-do
        Model('カンウォン特別自治道'), // Gangwon-do
        Model('チュンチョンブク道'), // Chungcheongbuk-do
        Model('チュンチョンナム道'), // Chungcheongnam-do
        Model('チョルラブク道'), // Jeollabuk-do
        Model('チョンラナム道'), // Jeollanam-do
        Model('キョンサンブク道'), // Gyeongsangbuk-do
        Model('キョンサンナム道'), // Gyeongsangnam-do
        Model('チェジュ') // Jeju-do
      ];
    }
    tabController = TabController(
      length: data.length,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    loadVectorMap();
    super.onInit();
  }
  clickListener(feature){
    tabController.index = feature.id-1;
    selectedIndex =feature.id-1;
    MapLayer layer = MapLayer(
        dataSource: polygons,
        theme: MapRuleTheme(contourColor:Colors.black26, colorRules: [
              (feature) {
            int? value = feature.id - 1;
            return value == selectedIndex  ? Colors.deepPurpleAccent : null;
          },
        ])
    );
    vecController = VectorMapController(layers: [layer], delayToRefreshResolution: 0,minScale:scale );
    List itemList = [];
    for(var i in item){

      String where = i['addr1'].replaceAll(RegExp('\\s'), "");
      List<String> j = where.split(',');
      if(data[selectedIndex].name == j[j.length-1] || j[0].contains(data[selectedIndex].name)){
        itemList.add(i);
      }
    }
    showModal(itemList);

    update();
  }
  tabChange(int index){
    MapLayer layer = MapLayer(
        dataSource: polygons,
        theme: MapRuleTheme(contourColor:Colors.black26, colorRules: [
              (feature) {
            int? value = feature.id - 1;
            return value == index ? Colors.deepPurpleAccent : null;
          },
        ])
    );
    selectedIndex = index;
    vecController = VectorMapController(layers: [layer], delayToRefreshResolution: 0 ,minScale: scale);
    List itemList = [];
    for(var i in item){
      String where = i['addr1'].replaceAll(RegExp('\\s'), "");
      List<String> j = where.split(',');
      if(data[selectedIndex].name == j[j.length-1] || j[0].contains(data[selectedIndex].name)){
        itemList.add(i);
      }
    }
    showModal(itemList);
    update();
  }
  loadVectorMap() async{
    vecController = VectorMapController(delayToRefreshResolution: 0,minScale:scale );
    polygons = await MapDataSource.geoJson(geoJson: koreaGeoJson,keys:['CTP_ENG_NM'],labelKey:'CTP_ENG_NM' );
      MapLayer layer = MapLayer(
          dataSource: polygons,
          theme: MapRuleTheme(
              contourColor:Colors.black26,
              colorRules: [
                    (feature) {
                  int? value = feature.id -1;
                  return value == 0 ?  Colors.deepPurpleAccent: null;
                },
              ])
      );
    vecController.addLayer(layer);
    loading = true;
    String url = 'https://apis.data.go.kr/B551011/$localUrl/areaBasedList1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=1000&pageNo=1&MobileOS=ETC&MobileApp=NowKorea&_type=json&listYN=Y&arrange=Q&contentTypeId=78';
    if(dropdownValue  != 'Culture'){
      url = 'https://apis.data.go.kr/B551011/$localUrl/searchFestival1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=1000&pageNo=1&MobileOS=ETC&MobileApp=NowKorea&_type=json&listYN=Y&arrange=R&eventStartDate=20230101&eventEndDate=20251231';
    }
    var response = await http.get(Uri.parse(url));

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonDate = jsonDecode(jsonString);
    if (jsonDate['response']['body']['items']['item'].isNotEmpty) {
      var firstItem = jsonDate['response']['body']['items']['item'][0];
    }
    for(var i in jsonDate['response']['body']['items']['item']){
      if(i['firstimage2'] != '') {
        item.add(i);
      }
    }
    update();
  }
  showModal (List itemList){
    DateTime time =DateTime.now();
    List ingItem = [];
    for(var i in itemList){
      if(dropdownValue == 'Culture'){
        if(i['firstimage'] != '') {
          ingItem.add(i);
        }
      }else if(time.compareTo(DateTime.parse(i['eventenddate']))<0 && i['firstimage'] != '' ){
        ingItem.add(i);
      }
    }
    if(ingItem.isEmpty){
      showDialog(
          context: Get.context!,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          // barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text( 'There are no events in progress',textAlign: TextAlign.center,)
            );
          });
    } else {
      showDialog(
          context: Get.context!,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          // barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Text(data[selectedIndex].name,textAlign: TextAlign.center,),
              content: SizedBox(
                width: 500,
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount:ingItem.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        String title = getTitle(ingItem[index]['title']);
                        DateTime eventStartDate = DateTime.now();
                        DateTime eventEndDate = DateTime.now();
                        bool isIng= false;
                        if(dropdownValue == 'Festival'){
                          eventStartDate = DateTime.parse(ingItem[index]['eventstartdate']);
                          eventEndDate   = DateTime.parse(ingItem[index]['eventenddate']);
                          if(time.compareTo(eventStartDate)>0) {
                            isIng = true;
                          }
                        }
                        return
                          ingItem[index]['firstimage'] == '' ?Container():
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) {
                                return ItemPage(item: ingItem[index],festivalOrCulture:dropdownValue == 'Festival');
                              }));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(title,style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),textAlign: TextAlign.center,),
                                    // Text('(${title[1]}'),
                                    dropdownValue == 'Festival' ? Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text('${eventStartDate.month} / ${eventStartDate.day} / ${eventStartDate.year} ~ ${eventEndDate.month} / ${eventEndDate.day} / ${eventEndDate.year}',
                                        style: const TextStyle(fontWeight: FontWeight.w600),),
                                    ):Container()
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      image: NetworkImage(ingItem[index]['firstimage']),
                                      loadingBuilder: (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return  lottie.Lottie.asset('image/koreaLottie.json',width: 100,height: 100);
                                      },
                                    ),
                                    dropdownValue == 'Culture'? Container():Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: isIng? 80:60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color:isIng ?  Colors.blueAccent :Colors.deepPurpleAccent,
                                              borderRadius: const BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Text(isIng ? 'ongoing':'soon',style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white
                                          ),),
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          color: Color(0xff006FFF),
                        ),
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.map,size: 55),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) {
                              return MapPage(item: ingItem,name:data[selectedIndex].name,index: selectedIndex,);
                            }));
                          },
                        ),
                      ),)
                  ],
                ),
              ),
            );
          });
    }
  }
}
