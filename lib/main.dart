import 'package:firebase_core/firebase_core.dart';
import 'package:fit_tarifler/login_sign/login_new.dart';
import 'package:fit_tarifler/tarif/tarif_page/tarif_p.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.green,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit Tarifler',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController kadi = TextEditingController();
  TextEditingController pass = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  void girisYap() async {
    try {
      User logUSer = (await _auth
          .signInWithEmailAndPassword(
        email: kadi.text,
        password: pass.text)).user;
      if(logUSer.emailVerified){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => exp(email: kadi.text,)));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Giriş Başarılı"),
        ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lütfen Mail Adresinizi Onaylayınız."),
        ));
      }

    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'Kullanıcı Bulunamadı') {
        print('No user found for that email.');
      } else if (e.code == 'Hatalı Şifre Girdiniz') {

      }
    }
  }

  Widget build(BuildContext context) {
    var ekranbilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranbilgisi.size.height;
    final double ekranGenislik = ekranbilgisi.size.width;
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/fittarifler-cacf6.appspot.com/o/logo.gif?alt=media&token=40e4041d-359f-4998-8893-0f237f38778c',
                fit: BoxFit.cover,
                width: ekranGenislik,
                height: ekranYuksekligi,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: ekranYuksekligi / 50,
                        left: ekranYuksekligi / 30,
                        right: ekranYuksekligi / 30,
                        top: 300),
                    child: TextField(
                      controller: kadi,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mobile_friendly,
                        ),
                        hintText: ("Kullanıcı Adı"),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ekranYuksekligi / 30),
                    child: TextField(
                      controller: pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: ("Şifre"),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        ),
                      ),
                    ),
                  ),
                  Center(child: InkWell(
                    onTap: (){},
                      child: Text("Şifrenizi mi Unuttunuz?",style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.bold),))),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: ElevatedButton(
                              child: Text(
                                'Kayıt Ol',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(color: Colors.transparent)
                                  )
                                )
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: ElevatedButton(
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
                                          side: BorderSide(color: Colors.transparent)
                                      )
                                  )
                              ),
                              onPressed: () {
                                girisYap();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




