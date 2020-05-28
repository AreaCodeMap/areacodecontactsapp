import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: HomeScreen.navKey,
      home: Scaffold(
        body: Container(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getContactsPermissions();
  }

  void getContactsPermissions() async {
    while (true) {
      print("ContactPermissions while loop hit");
      var permissionStatus = await Permission.contacts.status;

      if (permissionStatus.isGranted) {
        print("Permission granted");
        return;
      }

      if (permissionStatus.isUndetermined || permissionStatus.isDenied) {
        print("Permission requested");
        await Permission.contacts.request();
      }

      if (permissionStatus.isPermanentlyDenied ||
          permissionStatus.isRestricted) {
        print("Permission is Permanantly Denied, presenting permissions modal");
        await permissionsModal();
      }
    }
  }

  Future<void> permissionsModal() async {
    final context = HomeScreen.navKey.currentState.overlay.context;

    String title = 'Permission Required';
    String message =
        'This app needs permissions to contacts to view area codes';
    String buttonText = 'Go to Settings';

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text(buttonText),
                onPressed: () {
                  AppSettings.openAppSettings();
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
