import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
TextEditingController _adSoy = TextEditingController();
TextEditingController _yas = TextEditingController();
TextEditingController _cinsiyet = TextEditingController();
TextEditingController mail = TextEditingController();
TextEditingController pass = TextEditingController();
class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void kayitOl() async{
    try {
      UserCredential _user=await auth.createUserWithEmailAndPassword(
          email: mail.text, password: pass.text);
      User _newUser=_user.user;
      await _newUser.sendEmailVerification();
      Map<String,dynamic>ekle=Map();
      ekle["_adSoyad"]=_adSoy.text;
      ekle["_yas"]=_cinsiyet.text;
      ekle["_cinsiyet"]=_chosenValue.toString();
      firestore.collection("users").doc(FirebaseAuth.instance.currentUser.email).set(ekle).then((_){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lütfen Mailinizi Onaylayınız."),
        ));
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Şifreniz Minimum 6 Haneli Olmalıdır"),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Bu Mail Adresi ile Daha Önce Kayıt Yapılmış"),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
  var ekranGenis=MediaQueryData().size.width;
  var _chosenValue;
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height*0.3,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height:MediaQuery.of(context).size.height*0.3,
                          child: Image.asset("images/login.png")),
                      Center(
                        child: RichText(text: TextSpan(style: Theme.of(context).textTheme.headline5.copyWith(fontWeight:FontWeight.w500),
                          children: [
                            TextSpan(text: "Hesabınızı Oluşturun",style: TextStyle(color: Colors.white)),
                          ],
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top:16.0,left: 16,right: 16),
                  child: TextField(
                    controller: _adSoy,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ad-Soyad',
                    ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(top:14.0,left: 16,right: 16),
                  child: TextField(
                    controller: mail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mail Adresiniz',
                    ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(top:14.0,left: 16,right: 16),
                  child: TextField(
                    obscureText: true,
                    controller: pass,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifreniz',
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top:14.0,left: 16,right: 16),
                child: TextField(
                  controller: _yas,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Yaşınızı Giriniz',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:14.0,left: 16,right: 16),
                child: DropdownButton<String>(
                  focusColor:Colors.white,
                  value: _chosenValue,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Erkek',
                    'Kız',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  hint:Text(
                    "Cinsiyetinizi Seçiniz",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: TextButton(
                  child: Text("Kayıt Ol",style:TextStyle(fontSize: 14),),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      ),
                    ),
                  ),
                  onPressed: (){
                    kayitOl();
                  },
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
