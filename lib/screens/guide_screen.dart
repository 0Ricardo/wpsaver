import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {

  // Variables
  final App _app = new App();
  final _guideStyle = TextStyle(fontSize: 18.0);
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
        title: Text('Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.help_outline, size: 100, color: Theme.of(context).primaryColor,),
                  Text("How does ${_app.appName} works?",style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold,
                  ))
                ],
              ),
            ),
            SizedBox(height: 20),
            // Number 1 - required to do
            _guideNumber('1*', 'View your WhatsApp Status'),
            // Instructions
            Text("First open your WhatsApp messenger and view all status "
                "you want to save. as shown on image below.",
                style: _guideStyle),
            Divider(thickness: 1),
            Center(
              child: Image.asset('assets/images/status_guide.jpg')
            ),
            Divider(thickness: 1),
            //Number 2 - required to do
            _guideNumber('2*', 'Save WhatsApp Status'),
            Text('Go back to ${_app.appName} and click on "IMAGES/VIDEOS" to '
                'view all status of your WhatsApp contacts and then click on '
                '"SAVE" button to permanently download the status on your mobile.',
                style: _guideStyle),
            Divider(thickness: 1),
            // Number 3
            _guideNumber('3', 'Saved Status'),
            Text('To view all the statuses saved on your phone, '
                'open the ${_app.appName} and click on "SAVED" and there '
                'you can share the status with your friends on any social '
                'network or post again on your WhatsApp.',
                style: _guideStyle),
            Divider(thickness: 1),
            // The END
            Center(
              child: Text('*** END GUIDE ***',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),),
            )
          ],
        ),
      ),
    );
  }

  Widget _guideNumber(String number, String title) {
    final style =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal);
    return Row(
      children: <Widget>[
        Text('( $number )', style: style),
        SizedBox(width: 5),
        Text(title, style: style)
      ],
    );
  }
}
