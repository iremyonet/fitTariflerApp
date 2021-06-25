class Kutle{
  int _id;
  String _boy;
  String _kilo;
  String _sonuc;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get boy => _boy;

  String get sonuc => _sonuc;

  set sonuc(String value) {
    _sonuc = value;
  }

  String get kilo => _kilo;

  set kilo(String value) {
    _kilo = value;
  }

  set boy(String value) {
    _boy = value;
  }

  Kutle(this._boy, this._kilo, this._sonuc);
  Kutle.withID(this._id,this._boy, this._kilo, this._sonuc);

  Map<String,dynamic>toMap(){
    var map=Map<String,dynamic>();
    map["id"]=_id;
    map["kilo"]=_kilo;
    map["boy"]=_boy;
    map["sonuc"]=sonuc;
    return map;
  }
  Kutle.fromMap(Map<String,dynamic>map){
    this._id= map["id"];
    this._boy= map["boy"];
    this._kilo= map["kilo"];
    this.sonuc= map["sonuc"];
  }

  @override
  String toString() {
    return 'Kutle{_boy: $_boy, _kilo: $_kilo, _sonuc: $_sonuc}';
  }
}