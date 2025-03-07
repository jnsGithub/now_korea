import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart'as lottie;
import 'package:now_korea/global.dart';
import 'admob/itemPageBanner.dart';

class ItemPage extends StatefulWidget {
  final Map item;
  final bool festivalOrCulture;
  const ItemPage({Key? key, required this.item, required this.festivalOrCulture}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Map item = {};

  bool isLoading = false;

  String overview = '';

  List itemInfo = [];
  String title = '';
  List<String> entities =['&nbsp;','&lt;','&gt;','&amp;','&apos;','&quot;','&lsquo;','&rsquo;','&ldquo;','&rdquo;','&deg;','&middot;','&times;','&divide;','&minus;','&infin;','&sim;','&ne;','&le;','&ge;','&&ndash;','&mdash;','&bull;','&hellip;','&prime;','&Prime;','&copy;','&reg;','&trade;'];

  DateTime? eventStartDate ;
  DateTime? eventEndDate ;
  List<Marker> markers = [];

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Future<void> openMap() async {
    String url = '';
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${double.parse(item['mapy'])},${double.parse(item['mapx'])}';
    String urlAppleMaps = 'https://maps.apple.com/?q=${double.parse(item['mapy'])},${double.parse(item['mapx'])}';
    if(Platform.isAndroid){
      url = googleUrl;
    } else if(Platform.isIOS){
      url = urlAppleMaps;
    }
    launch(url);
  }

  Future<void> getItem () async
  {
    try {
      String url = 'https://apis.data.go.kr/B551011/$localUrl/detailImage1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&_type=json&contentId=${item['contentid']}&imageYN=Y&subImageYN=Y';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      var data = utf8.decode(response.bodyBytes);
      var dataJson = jsonDecode(data);
      print(dataJson);
      setState(() {
        if(dataJson['response']['body']['items'] == null ||dataJson['response']['body']['items'] == ''){
          itemInfo.add({'originimgurl':item['firstimage']});
        } else {
          itemInfo = dataJson['response']['body']['items']['item'];
        }
      });

      url = 'https://apis.data.go.kr/B551011/$localUrl/detailCommon1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=NowKorea&_type=json&contentId=${item['contentid']}&defaultYN=N&firstImageYN=N&areacodeYN=N&catcodeYN=N&addrinfoYN=N&mapinfoYN=N&overviewYN=Y';
      response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      data = utf8.decode(response.bodyBytes);
      dataJson = jsonDecode(data);
      setState(() {
        overview = dataJson['response']['body']['items']['item'][0]['overview'].toString();
        for(var i in entities){
          overview = overview.replaceAll(i, '');
        }
        isLoading = true;
      });
    } catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    item = widget.item;
    title = getTitle(item['title']);
    _kGooglePlex= CameraPosition(
      target: LatLng(double.parse(item['mapy']), double.parse(item['mapx'])),
      zoom: 14.4746,
    );
    markers.add(Marker(
        markerId: const MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: LatLng(double.parse(item['mapy']), double.parse(item['mapx']))));
    if(widget.festivalOrCulture){
      eventStartDate = DateTime.parse(item['eventstartdate']);
      eventEndDate= DateTime.parse(item['eventenddate']);
    }
    getItem();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading ?
        Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(title,style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  // Text('(${title[1]}',style: const TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.black87
                  // ), textAlign: TextAlign.center),
                  widget.festivalOrCulture ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('${eventStartDate?.month} / ${eventStartDate?.day} / ${eventStartDate?.year} ~ ${eventEndDate?.month} / ${eventEndDate?.day} / ${eventEndDate?.year}',
                      style: const TextStyle(fontWeight: FontWeight.w600),),
                  ):Container(),
                  ListView.builder(
                    itemCount:itemInfo.length,
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext ctx, int index) {
                      return Image(
                        image: NetworkImage(itemInfo[index]['originimgurl']),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text('Info',style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: Colors.deepPurpleAccent
                    ),),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 30,top: 15),
                      child: Text(overview.replaceAll('<br>', '\n').replaceAll('.', '.\n\n'),style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height:1.5,
                        wordSpacing:1.2,
                      ),)
                  ),
                  const Text('Address',style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Colors.deepPurpleAccent
                  ),),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 5,top: 15),
                      child: Text('${item['addr1']}',style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height:1.5,
                        wordSpacing:1.2,
                      ),)
                  ),
                  item['tel'] == '' ?Container():const Text('Tel',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Colors.deepPurpleAccent
                  ),),
                  item['tel'] == '' ?Container(margin: const EdgeInsets.only(bottom: 15,top: 15),):Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 15,top: 15),
                      child: Text('${item['tel'].replaceAll('<br>', '\n')}',style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height:1.5,
                        wordSpacing:1.2,
                      ),)
                  ),
                  Container(
                    width: size.width,
                    height: size.width,
                    margin: const EdgeInsets.only(bottom: 60),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: Set.from(markers),
                      initialCameraPosition: _kGooglePlex,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
                bottom: 0,
                child: ItemPageBanner()
            )
          ],
        ): Center( child: lottie.Lottie.asset('image/koreaLottie.json',width: 150,height: 150),),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(90)),
          color: Color(0xff006FFF),
        ),
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.map,size: 55),
          onPressed: (){
            openMap();
          },
        ),
      ),
    );
  }
}
