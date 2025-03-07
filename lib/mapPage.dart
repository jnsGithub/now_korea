
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:ui' ;
import 'package:lottie/lottie.dart'as lottie;
import 'admob/mapBanner.dart';
class MapPage extends StatefulWidget {
  final List item;
  final String name;
  final int index;
  const MapPage({Key? key, required this.item, required this.name, required this.index}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = [];
  List latLng = [
    // 서울
    {
      'lat':37.562,
      'lng':127.0091,
      'level':11.0
    },
    //부산
    {
      'lat':35.18,
      'lng':129.0689,
      'level':10.5
    },
    //대구
   {
      'lat':35.8294,
      'lng':128.5655,
      'level':11.0
    },
    //인천
    {
      'lat':37.457,
      'lng':126.7058,
      'level':10.0
    },
    //광주
    {
      'lat':35.1566,
      'lng':126.8363,
      'level':11.0
    },
    //대전
    {
      'lat':36.34,
      'lng':127.3944,
      'level':11.0
    },
    //울산
    {
      'lat':35.5538,
      'lng':129.2381,
      'level':10.0
    },
    //세종
    {
      'lat':36.5608,
      'lng':127.2589,
      'level':11.0
    },
    //경기도
    {
      'lat':37.532,
      'lng':127.0833,
      'level':9.0
    },
    //강원도
    {
      'lat':37.8268,
      'lng':128.1594,
      'level':8.2
    },
    //충청북도
    {
      'lat':37.0008,
      'lng':127.7,
      'level':8.4
    },
    //충청남도
    {
      'lat':36.719,
      'lng':126.7996,
      'level':8.4
    },
    //전라북도
    {
      'lat':35.7181,
      'lng':127.1537,
      'level':8.4
    },
    //전라 남도
    {
      'lat':34.8601,
      'lng':126.9234,
      'level':8.4
    },
    //경상북도
    {
      'lat':36.286,
      'lng':128.8918,
      'level':8.4
    },
    // 경상남도
    {
      'lat':35.4607,
      'lng':128.2133,
      'level':8.4
    },
    //제주도
    {
      'lat':33.3829,
      'lng':126.5361,
      'level':9.4
    },
  ];
  List itemInfo = [];
  List<String> entities =['&nbsp;','&lt;','&gt;','&amp;','&apos;','&quot;','&lsquo;','&rsquo;','&ldquo;','&rdquo;','&deg;','&middot;','&times;','&divide;','&minus;','&infin;','&sim;','&ne;','&le;','&ge;','&&ndash;','&mdash;','&bull;','&hellip;','&prime;','&Prime;','&copy;','&reg;','&trade;'];
  List title = [];
  String overview = '';
  bool isLoading = false;
  Future<void> getItem (item) async
  {
    try {
      setState(() {
        isLoading = true;
      });
      title = item['title'].split('(');
      String url = 'https://apis.data.go.kr/B551011/EngService1/detailImage1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=NowKorea&_type=json&contentId=${item['contentid']}&imageYN=Y&subImageYN=Y';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      var data = utf8.decode(response.bodyBytes);
      var dataJson = jsonDecode(data);
      setState(() {
        if(dataJson['response']['body']['items'] == null ||dataJson['response']['body']['items'] == ''){
          itemInfo.add({'smallimageurl':item['firstimage2']});
        } else {
          itemInfo = dataJson['response']['body']['items']['item'];
        }
      });

      url = 'https://apis.data.go.kr/B551011/EngService1/detailCommon1?serviceKey=akHKlagTZpkQLeNR8HA730172lY0QXOLtzt%2BXt6dUo29FxJMLtX%2BrOvT4tW0%2BUjy7sXjEKzIs4y2uMJK9ZefcA%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=NowKorea&_type=json&contentId=${item['contentid']}&defaultYN=N&firstImageYN=N&areacodeYN=N&catcodeYN=N&addrinfoYN=N&mapinfoYN=N&overviewYN=Y';
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
        isLoading = false;
        showModal(item);
      });

    } catch(e){

    }
  }
  showModal (item){
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                  child:Column(
                    children: [
                      Text(title[0],style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text('(${title[1]}',style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87
                      ), textAlign: TextAlign.center),
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
                          child: Text(overview.replaceAll('<br>', '\n').replaceAll('.', '.\n'),style: const TextStyle(
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
                      item['tel'] ==''? Container():const Text('Tel',style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: Colors.deepPurpleAccent
                      ),),
                      item['tel'] ==''? Container(margin: const EdgeInsets.only(bottom: 15,top: 15),):Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(bottom: 15,top: 15),
                          child: Text('${item['tel'].replaceAll('<br>', '\n')}',style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height:1.5,
                            wordSpacing:1.2,
                          ),)
                      ),
                      const Text('Tel',style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19
                      ),),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(bottom: 60,top: 5),
                          child: Text('${item['tel'].replaceAll('<br>', '\n')}',style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height:1.5,
                            wordSpacing:1.2,
                          ),)
                      )
                    ],
                  )
              ),
            ),
          );
        });
  }
  late CameraPosition _kGooglePlex;

  Future<Uint8List?> loadNetWorkImage (path) async{
    var completer = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((image, synchronousCall) { completer.complete(image);})
    );
    var imageInfo = await completer.future;
    var byteData = await imageInfo.image.toByteData(format:ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List? imageBytes = await loadNetWorkImage(imagePath);


    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes!, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }
  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);


    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    const double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    const double borderWidth = 3.0;

    const double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              0.0,
              0.0,
              size.width,
              size.height
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              shadowWidth,
              shadowWidth,
              size.width - (shadowWidth * 2),
              size.height - (shadowWidth * 2)
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(
    //       Rect.fromLTWH(
    //           size.width,
    //           0.0,
    //           tagWidth,
    //           tagWidth
    //       ),
    //       topLeft: radius,
    //       topRight: radius,
    //       bottomLeft: radius,
    //       bottomRight: radius,
    //     ),
    //     tagPaint);

    // Add tag text


    // Oval for the image
    Rect oval = Rect.fromLTWH(
        imageOffset,
        imageOffset,
        size.width - (imageOffset * 2),
        size.height - (imageOffset * 2)
    );

    // Add path for oval image
    canvas.clipPath(Path()
      ..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt()
    );

    // Convert image to bytes
    final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? uint8List = byteData?.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List!);
  }
  getMarker ()async {
    for(var i in widget.item){
      List name = i['title'].split('(');
      // Uint8List? image = await loadNetWorkImage(i['firstimage2']);
      // ui.Codec markerImage = await ui.instantiateImageCodec(
      //   image!.buffer.asUint8List(),
      //   targetHeight: 100,
      //   targetWidth: 100
      // );
      // ui.FrameInfo frameInfo = await markerImage.getNextFrame();
      // ByteData? byteData = await frameInfo.image.toByteData(
      //   format: ui.ImageByteFormat.png
      // );
      // Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
      markers.add(Marker(
          markerId: MarkerId(i['contentid']),
          draggable: true,
          infoWindow: InfoWindow(
            title:name[0]
          ),
          icon: await getMarkerIcon(i['firstimage2'],const Size(200.0, 200.0)),
          onTap: (){
            setState(() {
              getItem(i);
            });
          },
          position: LatLng(double.parse(i['mapy']), double.parse(i['mapx'])))
      );
      setState(() {

      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _kGooglePlex =  CameraPosition(
        target: LatLng(latLng[widget.index]['lat'],latLng[widget.index]['lng']),
        zoom: latLng[widget.index]['level']
    );
    // getPolyline();
    getMarker();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MAP'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: Set.from(markers),
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
            // polylines: polyline,
          ),
         isLoading ? Container(
           width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              backgroundBlendMode: BlendMode.saturation,
              color: Colors.black87
            ),
           child: Center(
             child: lottie.Lottie.asset('image/koreaLottie.json',width: 150,height: 150)
           ),
          ): Container(),
          const Positioned(
              bottom: 0,
              child: MapBanner()
          )
        ],
      ),
    );
  }
}
