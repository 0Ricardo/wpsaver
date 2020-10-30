import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {


  // Variables
  final App _app = new App();
  InterstitialAd _interstitial;

  @override
  void initState() {
    super.initState();
    /// Show interstitial Ad
    _interstitial = _app.createInterstitialAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _interstitial?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 65),
        child: Center(
          child: Column(
            children: <Widget>[
              /// App icon
              _app.getAppLogo(),
              SizedBox(height: 10),
              /// App name
              Text(_app.appName,
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold,
                ),textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              /// App slogan
              Text(_app.appShortDescription, style: TextStyle(
                color: Colors.grey, fontSize: 18,
               )),
              SizedBox(height: 15),
              /// App full description
              Text(_app.appFullDescription, style: TextStyle(
                 fontSize: 18,
              ),textAlign: TextAlign.center),
              SizedBox(height: 10),
              /// App version number
              Text(_app.appVersionName, style: TextStyle(
                fontSize: 20, color: Colors.grey
              ),textAlign: TextAlign.center),
              /// Share app button
              SizedBox(height: 10),
              FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                icon: Icon(Icons.share),
                label: Text('Share app',
                    style: TextStyle(color: Colors.white, fontSize: 18,)),
                onPressed: () {
                  /// Share app
                  _app.shareApp();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}