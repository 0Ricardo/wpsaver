import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/screens/about_us_screen.dart';
import 'package:status_saver/screens/guide_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyNavigationDrawer extends StatelessWidget {

  // Variables
  final _menutextcolor = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight:FontWeight.w500,
  );
  final _iconcolor = new IconThemeData(
    color: Color(0xff757575),
    
  );

  final App _app = new App();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        /// DrawerHeader
        _drawerHeader(),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: Icon(Icons.help_outline),
          ),
          title: Text("How it works?",style: _menutextcolor),
          onTap: () {
            // Go to guide page
            Navigator.push(context,
                new MaterialPageRoute(
                builder: (context) => GuideScreen()
            ));
          },
        ),
        ListTile(
          leading: IconTheme(
              data: _iconcolor,
              child: Icon(Icons.info),
          ),
          title: Text("About us",style: _menutextcolor),
          onTap: () {
            // Go to privacy policy
            Navigator.push(context,
              new MaterialPageRoute(
                  builder: (context) => AboutScreen()
              ));
          },
        ),
        ListTile(
          leading: IconTheme(
              data: _iconcolor,
              child: Icon(Icons.share),
          ),
          title: Text("Share with friends",style: _menutextcolor),
          onTap: () {
            /// Share app
            _app.shareApp();
          },
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
          ),
          title: Text("Like our page",style: _menutextcolor),
          subtitle: Text('@'+_app.facebookPageUsername, style: TextStyle(fontSize: 16),),
          onTap: () {
            /// Share app
            _app.openFacebook();
          },
        ),
        ListTile(
          leading: IconTheme(
              data: _iconcolor,
              child: Icon(Icons.rate_review),
          ),
          title: Text("Rate on Play Store",style: _menutextcolor),
          onTap: () async {
            /// Go to play store
            _app.goToPlayStore();
          },
        ),
        ListTile(
          leading: IconTheme(
              data: _iconcolor,
              child: Icon(Icons.security),
          ),
          title: Text("Privacy Policy",style: _menutextcolor),
          onTap: () async {
             // Go to privacy policy page
            _app.openPrivacyPage();
          },
        ),
        Container(height: 65),
       ], 
    );
  }

  /// DrawerHeader
  Widget _drawerHeader() {
    return SafeArea(
      child: Container(
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: _app.getAppLogo(width: 80, height: 80)),
            SizedBox(height: 5),
            Text(_app.appName,
                style: TextStyle(fontSize:18, color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(_app.appShortDescription,
                style: TextStyle(fontSize:18, color: Colors.white70), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

}