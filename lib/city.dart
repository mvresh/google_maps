//class City{
//  String country;
//  String name;
//  String lat;
//  String lng;
//
//  City({this.country,this.name,this.lat,this.lng});
//
//  factory City.fromJson(Map<String, dynamic> parsedJson){
//    return City(
//        country: parsedJson['country'],
//        name : parsedJson['name'],
//        lat: parsedJson['lat'],
//        lng: parsedJson['lng']
//    );
//  }
//
//}

class CitiesList {
  List<City> cities;

  CitiesList({this.cities});

  CitiesList.fromJson( data) {
      cities = List<City>();
      data.forEach((item){
        cities.add(City.fromJson(item));
      });
  }
}

class City {
  String country;
  String name;
  String lat;
  String lng;

  @override
  bool operator ==(other) => other is City && lat == other.lat && lng == other.lng ;
  @override
  int get hashCode => lat.hashCode*lng.hashCode;

  City(
      {this.country,this.name,this.lat,this.lng});

  City.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String,dynamic> toJson() => {
    'country': country,
    'name': name,
    'lat': lat,
    'lng': lng,
  };

}