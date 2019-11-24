import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'city.dart';
import 'sharedpref.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));


//SharedPrefs sharedPref = SharedPrefs();
//CitiesList citiesSave = CitiesList();
//CitiesList citiesLoad = CitiesList();

class MyApp extends StatefulWidget {
  LatLng currentLatLng;
  City currentCity;

  MyApp({this.currentCity,this.currentLatLng = const LatLng(12.97, 77.58)});

  @override
  _MyAppState createState() => _MyAppState();
}

//LatLng bangalore = LatLng(12.97, 77.58);
//LatLng mumbai = LatLng(19.07, 72.86);
//LatLng delhi = LatLng(28.61, 77.21);
//LatLng chennai = LatLng(13.07, 80.27);
//LatLng kolkata = LatLng(22.57, 88.36);
//LatLng jaipur = LatLng(26.91, 75.78);
//
//List<LatLng> positionList = [
//  bangalore,
//  mumbai,
//  delhi,
//  chennai,
//  kolkata,
//  jaipur
//];


class _MyAppState extends State<MyApp> {
  Set<Marker> markers = Set();
  SharedPrefs sharedPref = SharedPrefs();
  List<City> recentSearches = List<City>();
  bool dataLoaded = false;

  loadSharedPrefs() async{
    try {
      List<City> citiesList = CitiesList.fromJson(await sharedPref.read('recent')).cities;
      setState(() {
        recentSearches = citiesList;
      });
    } catch (e) {
      print('nothing there');
    }
  }
  Completer<GoogleMapController> mapController = Completer();

  void changeLatLng() async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(widget.currentLatLng));
    markers.add(Marker(
      markerId: MarkerId('${widget.currentCity.name}'),
      position: widget.currentLatLng,
    ));

//    if (i < positionList.length) {
//      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
//      i++;
//    } else {
//      i = 0;
//      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
//    }
  }

  CitiesList citiesListFromJson = CitiesList();
//  showCity(LatLng city) async {
//    GoogleMapController controller = await mapController.future;
//    controller.animateCamera(CameraUpdate.newLatLng(city));
//  }

  List<dynamic> jsonResult;

  getJson() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/cities.json");
    jsonResult = json.decode(data);
    citiesListFromJson = CitiesList.fromJson(jsonResult);
    dataLoaded = true;
    setState(() {

    });
//      return jsonResult;
  }

  @override
  void initState() {
    super.initState();
    getJson();
    loadSharedPrefs();
//    citiesSave.cities = [];

    //getJson().then((list){citiesListFromJson = CitiesList.fromJson(list);});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
//    SizedBox cityButton(LatLng cityLatLng, String city) {
//      return SizedBox(
//        width: queryData.size.width * 0.1,
//        height: queryData.size.height * 0.1,
//        child: Padding(
//          padding: const EdgeInsets.all(4.0),
//          child: RaisedButton(
//            color: Colors.lightBlueAccent,
//            child: Text(
//              '$city',
//              style: TextStyle(color: Colors.white, fontSize: 20),
//            ),
//            onPressed: () {
//              setState(() {
//                showCity(cityLatLng);
//              });
//            },
//          ),
//        ),
//      );
//    }

//    markers.add(Marker(
//      markerId: MarkerId('Bangalore'),
//      infoWindow: InfoWindow(
//          title: "Bangalore",),
//      position: bangalore,
//    ));
//    positionList.forEach((position) {
//      markers.add(Marker(
//        markerId: MarkerId('$position'),
//        infoWindow: InfoWindow(
//          title: "$position",
//        ),
//        position: position,
//      ));
//    });

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: GoogleMap(
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: widget.currentLatLng,
                  zoom: 12,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Opacity(
          opacity: dataLoaded ? 1 : 0,
          child: FloatingActionButton(
            child: Icon(Icons.search),
          onPressed: () async{
//                  loadSharedPrefs();
            City currentLocation = await showSearch(
                context: context,
                delegate: LocationSearch(citiesListFromJson.cities,recentSearches));
            widget.currentCity = currentLocation;
            currentLocation != null ? recentSearches.add(currentLocation) : print('came back');
            print(recentSearches.length);
            sharedPref.save('recent', recentSearches);
            widget.currentLatLng = LatLng(double.parse(currentLocation.lat),double.parse(currentLocation.lng));
            setState(() {
              changeLatLng();
//                    citiesSave.cities.add(currentLocation);
//                    print(citiesSave.cities[0].name);
//                    sharedPref.save('recent', citiesSave);
            });
//                  loadSharedPrefs();
          }
    ),
        ) ,
      ),
    );
  }
}

class LocationSearch extends SearchDelegate<City> {
  final List<City> cities;
  List<City> recent;

  LocationSearch(this.cities,this.recent);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<City> duplicateCitiesList = [];
    cities.forEach((city) {
      duplicateCitiesList.add(city);
    });

    List<City> suggestions;

    if(query == ''){
      if(recent.isEmpty){
        return Text('');
      }
      else{
        suggestions = recent;
        return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${suggestions[index].name.toString()} , ${suggestions[index].country.toString()}'),
                trailing: Icon(Icons.history),
                onTap: () {
                  close(context, suggestions[index]);
                },
              );
            });
      }
    }
    else {
      suggestions = duplicateCitiesList
          .where((city) => city.name.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
      return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${suggestions[index].name.toString()} , ${suggestions[index].country.toString()}'),
              onTap: () {
                close(context, suggestions[index]);
              },
            );
          });
    }

  }
}
