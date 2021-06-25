import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tarifler/tarif/compoments/colors.dart';
import 'package:fit_tarifler/tarif/detail_comp/det_appbar.dart';
import 'package:fit_tarifler/tarif/detail_comp/det_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
FirebaseFirestore firestore = FirebaseFirestore.instance;
class Tarif_Detail extends StatefulWidget {
  String baslik;
  Tarif_Detail({this.baslik});

  @override
  State<Tarif_Detail> createState() => _Tarif_DetailState();
}
class _Tarif_DetailState extends State<Tarif_Detail> {
  String tarih,tarif,onYazi;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();
 Uint8List _imageFile;
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _takeScreen()async{
    _imageFile=null;
    screenshotController.capture(delay: Duration(milliseconds: 10),pixelRatio: 2.0).then((Uint8List image)async{
      setState(() {
        _imageFile=image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Save");
      await Share.shareFiles(['$directory/screenshot.png'],
          text: 'Ini Screenshot');
    }).catchError((e) {
      print(e.toString());
    });
  }
  Future yemekBilgi()async{
   var yemekBilgi=await firestore.collection("yemekler").where("baslik",isEqualTo: widget.baslik).get();
   for(var dok in yemekBilgi.docs){
     setState(() {
       tarih=dok.data()["tarih"];
       onYazi=dok.data()["onYazi"];
       tarif=dok.data()["tarif"];
     });
   }
  }
  @override
  Widget build(BuildContext context) {
    yemekBilgi();
    return Scaffold(
      appBar: detailsAppBar(context),
      backgroundColor: colors,
      body: Container(
        child: new Center(
          child: Screenshot(
            controller: screenshotController,
            child:Column(
              children: [
                detail_img(imgSrc:"images/brgr.png"),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,color: ksecondaryColor,),
                              SizedBox(width: 10,),
                              Text("Fit Tarifler"),
                              SizedBox(width: 10,),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.baslik,style: Theme.of(context).textTheme.headline5,),
                                    SmoothStarRating(
                                      borderColor: kPrimaryColor,
                                    ),
                                    SizedBox(height: 10),
                                    Text(tarif),
                                  ],),
                              ),
                              ClipPath(
                                clipper: TarihClip(),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  width: 65,
                                  height: 66,
                                  color: kPrimaryColor,
                                  child: Text(tarih,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imageFile = null;
          screenshotController
              .capture(delay: Duration(milliseconds: 10))
              .then((Uint8List image) async {
            _imageFile = image;
            final directory = (await getApplicationDocumentsDirectory()).path;
            File imgFile = File('$directory/screenshot.png');
            imgFile.writeAsBytes(_imageFile);
            print("File Save");
            await Share.shareFiles(['$directory/screenshot.png'],
                text: 'Fit Tariflerden Yeni Tarif');
          }).catchError((onError) {
            print(onError);
          });
        },
        child: (SvgPicture.asset("icons/share.svg")),
      ), // This trailing com
    );
  }

}
class TarihClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path=Path();
    double ignoreHeig=20;
    path.lineTo(0, size.height-ignoreHeig);
    path.lineTo(size.width/2,size.height);
    path.lineTo(size.width,size.height-ignoreHeig);
    path.lineTo(size.height,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
   return false;
  }

}

