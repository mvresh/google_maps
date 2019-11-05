import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

LatLng bangalore = LatLng(12.97, 77.58);
LatLng mumbai = LatLng(19.07, 72.86);
LatLng delhi = LatLng(28.61, 77.21);
LatLng chennai = LatLng(13.07, 80.27);
LatLng kolkata = LatLng(22.57, 88.36);
LatLng jaipur = LatLng(26.91, 75.78);

List<LatLng> positionList = [
  bangalore,
  mumbai,
  delhi,
  chennai,
  kolkata,
  jaipur
];

class _MyAppState extends State<MyApp> {
  Set<Marker> markers = Set();

  Completer<GoogleMapController> mapController = Completer();
  int i = 1;

  void changeLatLng() async {
    GoogleMapController controller = await mapController.future;
    if (i < positionList.length) {
      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
      i++;
    } else {
      i = 0;
      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
    }
  }

  showCity(LatLng city) async{
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(city));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    SizedBox cityButton(LatLng cityLatLng,String city) {

      return SizedBox(
        width: queryData.size.width * 0.1,
        height: queryData.size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: Text('$city',style: TextStyle(color: Colors.white,fontSize: 20),),
            onPressed: (){
              setState(() {
                showCity(cityLatLng);
              });
            },
          ),
        ),
      );
    }
//    markers.add(Marker(
//      markerId: MarkerId('Bangalore'),
//      infoWindow: InfoWindow(
//          title: "Bangalore",),
//      position: bangalore,
//    ));
    positionList.forEach((position) {
      markers.add(Marker(
        markerId: MarkerId('$position'),
        infoWindow: InfoWindow(
          title: "$position",
        ),
        position: position,
      ));
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Maps'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: GoogleMap(
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: positionList[0],
                  zoom: 12,
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: <Widget>[
                    cityButton(bangalore,'Bangalore'),
                    cityButton(mumbai,'Mumbai'),
                    cityButton(delhi,'Delhi'),
                    cityButton(chennai,'Chennai'),
                    cityButton(kolkata,'Kolkata'),
                    cityButton(jaipur,'Jaipur'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
