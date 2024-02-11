import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:sist_nav_connect/utils/helpers.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  Location location = Location();
  MainBloc() : super(MainInitial()) {
    on<GetLocationPermission>(onGetLocationPermission);
    on<GetCurrentLocation>(onGetCurrentLocation);
  }

  FutureOr<void> onGetLocationPermission(
    GetLocationPermission event,
    Emitter<MainState> emit,
  ) async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showToast("grant location permission");
        return;
      }
    }
  }

  FutureOr<void> onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<MainState> emit,
  ) async {
    add(GetLocationPermission());
    var locationEnabled = await location.serviceEnabled();
    if (!locationEnabled) {
      locationEnabled = await location.requestService();
      if (!locationEnabled) {
        return;
      }
    }
    locationEnabled = await location.serviceEnabled();
    var currentLocation = await location.getLocation();
    print("current location : $currentLocation");
    if (currentLocation.latitude != null) {
      emit(CurrentLocationState(
        location: LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        ),
      ));
    }
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   emit(CurrentLocation(locationData: currentLocation));
    // });
  }
}
