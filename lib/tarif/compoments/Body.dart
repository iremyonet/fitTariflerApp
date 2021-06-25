import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tarifler/main.dart';
import 'package:fit_tarifler/reports/ReportPage.dart';
import 'package:fit_tarifler/screen/hakkimizda.dart';
import 'package:fit_tarifler/screen/hesapK%C3%BCtle.dart';
import 'package:fit_tarifler/screen/profile.dart';
import 'package:fit_tarifler/tarif/tarif_page/tarif_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'alert.dart';
import 'colors.dart';
FirebaseFirestore firestore = FirebaseFirestore.instance;
class Body extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const Body({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool menuAcik=false;
  bool bilgi=false;

  @override
  Widget build(BuildContext context) {
    double ekranYuksek=MediaQuery.of(context).size.height;
    double ekranGen=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          bodyMenu(context),
          bodyAnim(ekranYuksek, ekranGen, context),
        ],
      ),
    );
  }

  AnimatedPositioned bodyAnim(double ekranYuksek, double ekranGen, BuildContext context){
    return AnimatedPositioned(
          top:menuAcik?0.1*ekranYuksek:0,
          bottom:menuAcik?0.1*ekranYuksek:0,
          left:menuAcik?0.5*ekranGen:0,
          right:menuAcik?-0.4*ekranGen:0,
          duration: Duration(milliseconds: 500),
          child: SingleChildScrollView(
            child: Material(
              borderRadius: menuAcik? BorderRadius.all(Radius.circular(30)):null,
              elevation: 8,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top:12,left: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          IconButton(
                            icon:SvgPicture.asset("icons/menu.svg"),
                            onPressed: (){
                              setState(() {
                                menuAcik=!menuAcik;
                              });
                            },
                          ),
                          RichText(text: TextSpan(style: Theme.of(context).textTheme.headline5.copyWith(fontWeight:FontWeight.bold),
                            children: [
                              TextSpan(text: "Fit",style: TextStyle(color: ksecondaryColor)),
                              TextSpan(text: "Tarifler",style: TextStyle(color: kPrimaryColor)),
                            ],
                          ),),
                          IconButton(icon: SvgPicture.asset("icons/notification.svg"), onPressed: () {  },),
                        ],
                      ),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: firestore.collection("yemekler").snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot>querySnapshot) {
                              if (!querySnapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                var list=querySnapshot.data.docs;
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    String baslik=list[index]["baslik"];
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 20, bottom: 20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [ BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                            color: Color(0XFF343442),
                                          ),
                                          ]
                                      ),
                                      child: Material(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => Tarif_Detail(baslik:baslik,)));
                                          },
                                          child: Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 20, bottom: 20, right: 15),
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor.withOpacity(0.13),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Text("Yemek Adı: ${baslik} "),
                                                ],
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Column(
                                                      children: [

                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
 Widget bodyMenu(BuildContext context){
   final TextStyle menuFont=TextStyle(color: Colors.black,fontSize: 17);
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton.icon(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => profile()));
              },
              icon:SvgPicture.asset("icons/person.svg",color: Colors.purple,),
              label: Text("Profilim",style: menuFont,)
          ),
          SizedBox(height: 10,),
          FlatButton.icon(
              onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => yemek2()));
              },
              icon:Icon(Icons.restaurant,color: Colors.purple,),
              label: Text("Günün Menüsü",style: menuFont,)
          ),
          SizedBox(height: 10,),
          FlatButton.icon(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => hakkimizda()));
              },
              icon:SvgPicture.asset("icons/notification.svg",color: Colors.purple,),
              label: Text("Hakkımızda",style: menuFont,)
          ),
          FlatButton.icon(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PieChartSample3()));
              },
              icon:Icon(Icons.graphic_eq,color: Colors.purple,),
              label: Text("Grafikler",style: menuFont,)
          ),

          SizedBox(height: 10,),
          FlatButton.icon(
              onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => KutleEndex()));
              },
              icon:SvgPicture.asset("icons/home.svg",color: Colors.purple,),
              label: Text("Vücut-Kütle Endeksi",style: menuFont,)
          ),
          SizedBox(height: 10,),
          FlatButton.icon(
              onPressed: (){
                var dialog = CustomAlertDialog(
                    title: "Çıkış Yap",
                    message: "Çıkış Yapmak İstiyor Musunuz?",
                    onPostivePressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    positiveBtnText: 'Evet',
                    negativeBtnText: 'Hayır');
                showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog);

              },
              icon:Icon(Icons.exit_to_app,color: Colors.purple,),
              label: Text("Çıkış Yap",style: menuFont,)
          ),
        ],
      ),
    ),
  );
 }
showAlertDialog(BuildContext context) {

  Widget continueButton = FlatButton(
    child: Text("Devam Et"),
    onPressed:  () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => profile()));
    },
  );

}

