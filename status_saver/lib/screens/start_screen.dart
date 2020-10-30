import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/screens/home_screen.dart';


class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  // Variables
  final App _app = new App();
  BannerAd _bannerAd;


  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: _app.adMobAppId);
    /// Load banner Ad
    _bannerAd = _app.createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_app.appName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Colors.grey.withAlpha(70),
          child: Column(
            children: <Widget>[
              /// App logo
              _app.getAppLogo(width: 130, height: 130),
              SizedBox(height: 20),
              Text('Select app to view Status', style: TextStyle(fontSize: 18),),
              SizedBox(height: 15),
              /// Open WhatsApp Messenger
              GestureDetector(
                child: Card(
                  child: ListTile(
                    leading: Image.asset("assets/images/whatsapp_messenger_icon.png"),
                    title: Text("View Status of WhatsApp Messenger",
                      style: TextStyle(fontSize: 20,
                          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Click here to open'),
                  ),
                ),
                onTap: () {
                  // Open WhatsApp Business Messenger
                  goToHomeScreen("WhatsApp");
                },
              ),
              SizedBox(height: 15),
              /// Open WhatsApp Business
              GestureDetector(
                child: Card(
                  child: ListTile(
                    leading: Image.asset("assets/images/whatsapp_business_icon.png"),
                    title: Text("View Status of WhatsApp Business",
                      style: TextStyle(fontSize: 20,
                          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Click here to open'),
                  ),
                ),
                onTap: () {
                  // Open WhatsApp Business Status
                  goToHomeScreen("WhatsApp Business");
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }


  void goToHomeScreen(String app) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> HomeScreen(app: app)));
  }


}
