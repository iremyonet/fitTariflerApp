import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
final _picker=ImagePicker();
FirebaseFirestore firestore = FirebaseFirestore.instance;
File imageFile;
TextEditingController _adSoyad = TextEditingController();
TextEditingController _konum = TextEditingController();
TextEditingController _meslek = TextEditingController();
TextEditingController _yas = TextEditingController();
TextEditingController _kg = TextEditingController();
TextEditingController _cinsiyet = TextEditingController();
 var ad,konum,meslek,cns,yas,kg;
class profile extends StatefulWidget {
   profile({Key key}) : super(key: key);
  @override
  _profileState createState() => _profileState();
}
class _profileState extends State<profile> {
  TextStyle _style(){
  return TextStyle(
  fontWeight: FontWeight.bold
  );
  }
  @override
  Widget build(BuildContext context) {
    firestore.collection("users")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((docSnap) {
      setState(() {
       ad = docSnap.data()["_adSoyad"];
       konum=docSnap.data()["_konum"];
       meslek=docSnap.data()["_meslek"];
       yas=docSnap.data()["_yas"];
       kg=docSnap.data()["_kg"];
       cns=docSnap.data()["_cinsiyet"];
      });
    });
    String email =FirebaseAuth.instance.currentUser.email;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("İsim"),
            SizedBox(height: 4,),
            Text(ad.toString(), style: _style(),),
            SizedBox(height: 16,),
            Text("Email", style: _style(),),
            SizedBox(height: 4,),
            Text(email.toString()),
            SizedBox(height: 16,),
            Text("Konum", style: _style(),),
            SizedBox(height: 4,),
            Text(konum.toString()),
            SizedBox(height: 16,),
            Text("Meslek", style: _style(),),
            SizedBox(height: 4,),
            Text(meslek.toString()),
            SizedBox(height: 16,),
            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}
class CustomAppBar extends StatefulWidget
    with PreferredSizeWidget{
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 320);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<void>_showDiag(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Seçim Yapınız'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector( 
                    child: Text("Kamera"),
                    onTap: (){
                      _openCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Galeri"),
                    onTap: (){
                   getGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  var resimUrl;
   var url="https://i.pinimg.com/736x/3f/94/70/3f9470b34a8e3f526dbdb022f9f19cf7.jpg";
  Future getGallery(BuildContext context)async{
    final pickedFile=await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile=File(pickedFile.path);
    });
    var ref=FirebaseStorage.instance.ref().child("users").child(FirebaseAuth.instance.currentUser.email).child("profil.png");
    UploadTask uploadTask=ref.putFile(imageFile);
    resimUrl=await ref.getDownloadURL();
    print("URL ADRESİ: ${resimUrl}");

    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context)async{
    final picture=await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile=File(picture.path);
    });
    var ref=FirebaseStorage.instance.ref().child("users").child(FirebaseAuth.instance.currentUser.email).child("resim");
    ref.putFile(imageFile);
    Navigator.of(context).pop();

  }

  @override
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                  color: Colors.red,
                  blurRadius: 20,
                  offset: Offset(0, 0)
              )
            ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:50),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: imageFile == null ? Image.network(url) : Image.network(resimUrl),
                      ),
                    ),
                    SizedBox(height: 10,),
                    FlatButton.icon(
                        onPressed: (){
                          _showDiag(context);
                        },
                        icon: Icon(Icons.picture_as_pdf_outlined),
                        label: Text("Resminizi Güncelleyin")),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Favoriler", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text("8", style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Yaş", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text(yas.toString(), style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Kilo", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text(kg.toString(), style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Text("Cinsiyet", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text(cns.toString(), style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),)
                  ],
                ),

                SizedBox(width: 32,),
                SizedBox(width: 16,)

              ],
            ),
            SizedBox(height: 8,),

            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: (){
                  _adSoyad.value=_adSoyad.value.copyWith(
                    text: ad.toString(),
                  );
                  _konum.value=_konum.value.copyWith(
                      text: konum.toString());
                  _meslek.value=_meslek.value.copyWith(
                      text: meslek.toString());
                  _yas.value=_yas.value.copyWith(
                      text: yas.toString());
                  _cinsiyet.value=_cinsiyet.value.copyWith(
                      text: cns.toString());
                  _kg.value=_kg.value.copyWith(
                      text: kg.toString());
                     _displayDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
                  child: Transform.rotate(
                    angle: (math.pi * 0.05),
                    child: Container(
                      width: 110,
                      height: 32,
                      child: Center(child: Text("Profili Güncelle"),),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20
                            )
                          ]
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height-70);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text('Profilini Güncelle'),
              actions: <Widget>[
                TextFormField(
                  controller: _adSoyad,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Adınız Soyadınız'
                  ),
                ),
                TextFormField(
                  controller: _konum,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Konum'
                  ),
                ),
                TextFormField(
                  controller: _meslek,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Mesleğiniz'
                  ),
                ),
                TextFormField(
                  controller: _yas,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Yaşınız'
                  ),
                ),
                TextFormField(
                  controller: _kg,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Kilonuz'
                  ),
                ),
                TextFormField(
                  controller: _cinsiyet,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Cinsiyetiniz'
                  ),
                ),

                FlatButton(
                  child: new Text('Güncelle'),
                  onPressed: () {
                    Map<String,dynamic>ekle=Map();
                    ekle["_adSoyad"]=_adSoyad.text;
                    ekle["_meslek"]=_meslek.text;
                    ekle["_konum"]=_konum.text;
                    ekle["_yas"]=_yas.text;
                    ekle["_cinsiyet"]=_cinsiyet.text;
                    ekle["_kg"]=_kg.text.toUpperCase();
                    firestore.collection("users").doc(FirebaseAuth.instance.currentUser.email).update(ekle).then((_){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Bilgileriniz Güncellendi."),
                      ));
                    });
                    Navigator.of(context).pop();
                    },
                ),
              ],
            ),

          );
        });

}

