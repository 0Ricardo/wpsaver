import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/screens/view_status_screen.dart';

class VideosTab extends StatefulWidget {
  // Variables
  final String app;

  VideosTab({@required this.app});

  @override
  VideosTabState createState() {
    return new VideosTabState();
  }
}

class VideosTabState extends State<VideosTab> {
  // Variables
  final App _app = new App();
  List _videoList;

  @override
  void initState() {
    super.initState();

    // Get Statuses path
    _app.getStatusesPath(widget.app).then((path) {
      // Check statuses dir
      if (Directory(path).existsSync()) {
        //  print('yes dir exists');
        if (mounted)
          setState(() {
            _videoList = Directory(path)
                .listSync()
                .map((item) => item.path)
                .where((item) => item.endsWith(".mp4"))
                .toList();
          });
      } else {
        //  print('Dir does not exists');
        setState(() => _videoList = []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showVideoStatuses();
  }

  /// Show video statuses
  Widget _showVideoStatuses() {
    /// Check list
    if (_videoList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_videoList.isNotEmpty) {
      /// Show video list
      return _videoCard();
    } else {
      return Center(
          child: Text(
        "No video found.",
        style: TextStyle(fontSize: 18.0),
      ));
    }
  }

  /// Create Video Card
  Widget _videoCard() {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 65.0),
        itemCount: _videoList.length,
        itemBuilder: (context, index) {
          /// Get thumbnail from video
          return FutureBuilder<String>(
              future: _app.getVideoThumbnail(_videoList[index]),
              builder: (context, snapshot) {
                /// Check result
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  /// Show video thumbnail
                  return GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            shape: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            elevation: 8.0,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(File(snapshot.data),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned.fill(
                            child: Center(
                                child: Icon(Icons.play_circle_outline,
                                    color: Colors.white, size: 50))),
                      ],
                    ),
                    onTap: () {
                      /// Go to play video screen
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ViewStatusScreen(
                                    savedStatus: false,
                                    fileExt: '.mp4',
                                    filePath: _videoList[index],
                                  )));
                    },
                  );
                } else {
                  /// Loading video placeholder
                  return Card(
                    margin: const EdgeInsets.all(5.0),
                    shape: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    elevation: 8.0,
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset("assets/images/video_loader.gif",
                            fit: BoxFit.cover)),
                  );
                }
              });
        });
  }
}
