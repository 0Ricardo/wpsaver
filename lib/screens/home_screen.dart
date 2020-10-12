
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/tabs/saved_status_tab.dart';
import 'package:status_saver/tabs/videos_tab.dart';
import 'package:status_saver/widgets/my_navigation_drawer.dart';
import 'package:status_saver/tabs/photos_tab.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// Variables
  final App _app = new App();
  InterstitialAd _interstitial;
  BannerAd _bannerAd;

  // Tabs list
  final List<Tab> myTabs = <Tab>[
    Tab(child: Row(
      children: <Widget>[
        Icon(Icons.photo_camera),
        SizedBox(width: 3),
        Text('IMAGES'),
      ],
    )),
    Tab(child: Row(
      children: <Widget>[
        Icon(Icons.videocam),
        SizedBox(width: 3),
        Text('VIDEOS'),
      ],
    )),
    Tab(child: Row(
      children: <Widget>[
        Icon(Icons.save_alt),
        SizedBox(width: 3),
        Text('SAVED'),
      ],
    )),
  ];

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
    _interstitial?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }


  // Show interstitial Ad
  void _showInterstitialAd() async {
    _interstitial = _app.createInterstitialAd()
      ..load()
      ..show();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        drawer: Drawer(
          child: MyNavigationDrawer(),
        ),
        appBar: AppBar(
          title: Text(_app.appName),
          bottom: TabBar(
            tabs: myTabs,
            onTap: (tapIndex) {
              /// Show interstitial Ad
              _showInterstitialAd();
            },
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            /// Images tab body
            PhotosTab(),
            /// Videos tab body
            VideosTab(),
            /// Saved Status tab body
            SavedStatusTab(),
          ]
        ),
      ),
    );
  }
}