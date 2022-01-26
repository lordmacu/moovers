import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  HomeController controllerHome = Get.put(HomeController());

  getLocationForce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

       Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        print("aquiii estoy en el force");

        _permissionGranted = await location.requestPermission();

        if (_permissionGranted != PermissionStatus.granted) {
          prefs.setDouble("latitude", 4.672134);
          prefs.setDouble("longitude", -74.084966);

          controllerHome.latitude.value=4.672134;
          controllerHome.longitude.value=-74.084966;
          return;
        }
      }
    //  location.enableBackgroundMode(enable: true);

      _locationData = await location.getLocation();

      print("aquiii el location  ${_locationData}");

      if (_locationData.longitude != null) {
        prefs.setDouble("latitude", _locationData.latitude!);
        prefs.setDouble("longitude", _locationData.longitude!);

        controllerHome.latitude.value=_locationData.latitude!;
        controllerHome.longitude.value=_locationData.longitude!;

      }

  }

  getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getDouble("latitude") == null) {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {

        _permissionGranted = await location.requestPermission();

        if (_permissionGranted != PermissionStatus.granted) {
          prefs.setDouble("latitude", 4.672134);
          prefs.setDouble("longitude", -74.084966);

          controllerHome.latitude.value=4.672134;
          controllerHome.longitude.value=-74.084966;
          return;
        }
      }
      //location.enableBackgroundMode(enable: true);

      _locationData = await location.getLocation();

      print("aquiii el location  ${_locationData}");

      if (_locationData.longitude != null) {
        prefs.setDouble("latitude", _locationData.latitude!);
        prefs.setDouble("longitude", _locationData.longitude!);

        controllerHome.latitude.value=_locationData.latitude!;
        controllerHome.longitude.value=_locationData.longitude!;
        Get.to(() => Home());
      }
    } else {
      controllerHome.latitude.value= prefs.getDouble("latitude")!;
      controllerHome.longitude.value=prefs.getDouble("longitude")!;
      Get.to(() => Home());
    }
  }

  @override
  void onInit() {
    getLocation();
  }
}
