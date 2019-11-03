import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
LatLng bangalore = LatLng(12.97, 77.58);
LatLng mumbai = LatLng(19.07, 72.87);
LatLng delhi = LatLng(28.64, 77.21);
LatLng chennai = LatLng(13.06, 80.23);
List <LatLng> positionList = [bangalore,mumbai,delhi,chennai];

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> mapController = Completer();
  int i = 1;

  void changeLatLng() async{
    GoogleMapController controller = await mapController.future;
    if(i < positionList.length){
      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
      i++;
    }
    else{
      i = 0;
      controller.animateCamera(CameraUpdate.newLatLng(positionList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Maps'),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller){
                mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: positionList[0],
                zoom: 12,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text('Change City',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    setState(() {
                      changeLatLng();
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

