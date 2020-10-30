import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:url_launcher/url_launcher.dart';

class App {
  /// ************** Required App info ************ ///
  final String appPackageName = "com.xamarindo.wpstatusaver";
  final int appVersionNumber = 3;
  final String appVersionName = "Version: 1.0.3";
  final String appName = "WhatStatus Thieffer";
  final String appShortDescription = "Save WhatsApp Status Easily";
  final String appFullDescription =
      "Wp Pic & Video Status Saver is an application that helps "
      "you to permanently save the status of your WhatsApp contacts on your mobile phone.";

  /// Optional Facebook info
  // If you don't want facebook page visit -> go to widgets/my_navigation_drawer.dart
  // and comment "Like our page" ListTile.
  final String facebookPageUsername = "praysoft";

  /// ************ Required Admob info ******************** ///

  final String adMobAppId = "ca-app-pub-8521044456540023~3652646925";

  /// Create banner Ad
  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: "ca-app-pub-8521044456540023/1533750040",
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print('BannerAd MobileAdEvent: $event');
        });
  }

  /// Create Interstitial Ad
  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-8521044456540023/5391914639",
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print('InterstitialAd MobileAdEvent: $event');
        });
  }

  /// Return App Logo
  Widget getAppLogo({double width, double height}) {
    return Image.asset('assets/images/app_logo.png',
        width: width ?? 120, height: height ?? 120);
  }

  /// Setup admob info
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    childDirected: false,
  );

  /// Get thumbnail from video
  Future<String> getVideoThumbnail(videoPathUrl) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl,
        imageType: ThumbFormat.PNG, // this image will be stored in cache folder
        quality: 10);
    return thumb;
  }

  /// Share app
  Future<void> shareApp() async {
    Share.text(
        'Share',
        '$appShortDescription \n'
            'Get $appName on Google Play Store: '
            'https://play.google.com/store/apps/details?id=$appPackageName\n'
            'Install it now!',
        'text/plain');
  }

  /// Go to play store app page
  Future goToPlayStore() async {
    final String url =
        "https://play.google.com/store/apps/details?id=$appPackageName";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  /// Open facebook page in app/browser
  Future<void> openFacebook() async {
    final facebookUrl = 'https://facebook.com/$facebookPageUsername';
    try {
      await launch(facebookUrl);
    } catch (error) {
      throw 'Could not launch $error';
    }
  }

  /// Open privacy policy page
  Future<void> openPrivacyPage() async {
    const url =
        'http://www.sgermosen.com/2020/08/privacy-policy-for-xamarindo.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Check storage permission
  Future<void> checkStoragePermission(
      {@required VoidCallback onGranted}) async {
    final permission = await Permission.storage.request();

    print(permission);

    // Check result
    if (permission.isGranted) {
      print('permission.isGranted: true');
      onGranted();
    } else if (permission.isPermanentlyDenied) {
      print('permission.isPermanentlyDenied: true -> openAppSettings');
      openAppSettings();
    }
  }

  /// Get WhatsApp Statuses path
  Future<String> getStatusesPath(String app) async {
    final Directory absoluteDir = await getExternalStorageDirectory();
    final String externalDirPath =
        absoluteDir.path.replaceFirst('Android/data/$appPackageName/files', '');
    final statusesPath = "$externalDirPath/$app/Media/.Statuses";
    print('getStatusesPath() -> $statusesPath');
    return statusesPath;
  }

  /// Get Saved Statuses path
  Future<String> getSavedStatusesPath() async {
    final Directory absoluteDir = await getExternalStorageDirectory();
    final String externalDirPath =
        absoluteDir.path.replaceFirst('Android/data/$appPackageName/files', '');
    final statusesPath = "$externalDirPath/$appName";
    print('getSavedStatusesPath() -> $statusesPath');
    return statusesPath;
  }

  /// Save File in Gallery
  Future<void> saveFileInGallery(
      {@required BuildContext context,
      @required GlobalKey<ScaffoldState> scaffoldKey,
      @required String filePath,
      @required String fileExt}) async {
    // show loading dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
            content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 15),
            Text("Saving...\nPlease wait!", style: TextStyle(fontSize: 18))
          ],
        )));

    /// Get absolute external app directory
    final Directory absoluteDir = await getExternalStorageDirectory();
    final String dirPath =
        absoluteDir.path.replaceFirst('Android/data/$appPackageName/files', '');

    String statusDir = dirPath + '$appName';

    // Check directory
    if (!Directory(statusDir).existsSync()) {
      // Create Status dir
      Directory(statusDir).createSync();
      print('$appName dir created!');
    } else {
      print('$appName dir exists!');
    }

    // Copy status to new path
    File(filePath).copySync(
        '$statusDir/Status-${DateTime.now().millisecondsSinceEpoch.toString()}' +
            fileExt);
    print('Status saved sucessfuly!');

    // Close dialog
    Navigator.of(context).pop();

    // Show message
    showDialogInfo(
      context: context,
      message: 'Status saved successfully!',
    );
  }

  /// Dialog to show information
  void showDialogInfo({
    @required BuildContext context,
    @required String message,
    Color color,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.check_circle,
                  size: 65, color: color ?? Theme.of(context).primaryColor),
              SizedBox(width: 15),
              Text(message,
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));
  }
}
