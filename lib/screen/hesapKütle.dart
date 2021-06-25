import 'package:fit_tarifler/model/K%C3%BCtle.dart';
import 'package:fit_tarifler/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';
class KutleEndex extends StatefulWidget {

  const KutleEndex({Key key}) : super(key: key);

  @override
  _KutleEndexState createState() => _KutleEndexState();
}

class _KutleEndexState extends State<KutleEndex> {
  @override
  DatabaseHelper db=DatabaseHelper();
  List<Kutle>tumVeri;
  void initState() {
    // TODO: implement initState
    super.initState();
    tumVeri=List<Kutle>();
    db=DatabaseHelper();
     db.tumVeriler().then((value){
       for(Map okunanVeri in value){
         tumVeri.add(Kutle.fromMap(okunanVeri));
       }
     });
  }
  @override
  var boy,kilo,sonuc;
  double valueBoy,valueKilo,indeks;
  String data = "";
  TextEditingController _boy = TextEditingController();
  TextEditingController _kilo = TextEditingController();
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height*0.3,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
              ),
              child:Padding(
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
                          TextSpan(text: "Vücut-Kütle Endeksi",style: TextStyle(color: Colors.white)),
                        ],
                      ),),
                    ),
                    IconButton(
                      icon:SvgPicture.asset("icons/menu.svg",color: Colors.white,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top:16.0,left: 16,right: 16),
                child: TextField(
                  controller: _kilo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kilonuz (Örnek:80)',
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top:14.0,left: 16,right: 16),
                child: TextField(
                  controller: _boy,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Boyunuz (Örnek:1.80)',
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TextButton(
                child: Text("Hesapla",style:TextStyle(fontSize: 14),),
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
                onPressed: () {
                  setState(
                        () {
                      if (_boy.text.isNotEmpty &&
                          _kilo.text.isNotEmpty) {
                        valueBoy = double.parse(_boy.text);
                        valueKilo = double.parse(_kilo.text);
                        indeks = valueKilo / (valueBoy * valueBoy);
                        print(indeks);
                        if (indeks < 18) {
                          data = "Zayıf \n\n VKİ : ${indeks.toStringAsFixed(5)} ";
                        } else if (indeks >= 18 && indeks < 25) {
                          data =
                          "Normal \n\n  VKİ : ${indeks.toStringAsFixed(5)}";
                        } else if (indeks >= 25 && indeks < 30) {
                          data = "Kilolu \n\n VKİ : ${indeks.toStringAsFixed(5)}";
                        } else if (indeks >= 30 && indeks < 35) {
                          data = "Obez\n\n VKİ : ${indeks.toStringAsFixed(5)}";
                        } else {
                          data =
                          "Ciddi Obez \n\n VKİ : ${indeks.toStringAsFixed(5)}";
                        }
                      } else {
                        data = "Boy veya kilo boş olamaz ! ";
                      }
                    },
                  );
                  Kutle a=new Kutle(valueBoy.toString(),valueKilo.toString(),indeks.toString());
                  db.kutleEkle(a);
                  setState(() {
                    tumVeri.insert(0,a);
                  });
                },
              ),
            ),
            Text("Sonuc:${data} ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Divider(),
            SizedBox(height: 10,),
            Text("Geçmiş Sonuçlar",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            Divider(),
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: tumVeri.length,
                    itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      title: Text("Kilo: ${tumVeri[index].kilo}   Boy: ${tumVeri[index].boy}"),
                      subtitle: Text("Sonuc: ${tumVeri[index].sonuc}"),
                    ),
                  );
                    }),
              ],
            )],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            db.kutleSil();
            tumVeri.clear();
            final snackBar = SnackBar(content: Text('Tüm Geçmiş Kayıtlar Temizlendi'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        },
        child: const Icon(Icons.delete),
        backgroundColor: Colors.pink.shade200,
      ),
    );
  }
  void dbVeriler()async{
    var sonuc=await db.tumVeriler();
    print(sonuc);
  }

}
