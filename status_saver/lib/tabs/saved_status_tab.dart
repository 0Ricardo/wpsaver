import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:status_saver/screens/view_status_screen.dart';


class SavedStatusTab extends StatefulWidget {
  @override
  _SavedStatusTabState createState() {
    return new _SavedStatusTabState();
  }
}

class _SavedStatusTabState extends State<SavedStatusTab> {

  // Variables
  final App _app = new App();
  List _savedStatusList;


  @override
  void initState() {
    super.initState();

    /// Get Saved Statuses path
    _app.getSavedStatusesPath().then((path) async {
      // Check dir
      if (await Directory(path).exists()) {
        print('yes dir exists');
        if (mounted)
          setState(() {
            _savedStatusList = Directory(path).listSync().map((item) =>
            item.path).toList();
          });
      } else {
        print("dir doesn't exists");
        setState(() {
          _savedStatusList = [];
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return _showSavedStatuses();
  }

  Widget _showSavedStatuses() {
    /// Check list
    if (_savedStatusList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );

    } else if (_savedStatusList.isNotEmpty) {

      return Container(
        padding: EdgeInsets.only(bottom: 65.0),
        child: StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: _savedStatusList.length,
          itemBuilder: (context, index) {
            String statusPath = _savedStatusList[index];
            return Material(
              elevation: 8.0,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: GestureDetector(
                onTap: () async {

                 String fileExt;

                 // Check file extension
                 if (statusPath.endsWith('.jpg')) {
                   fileExt = '.jpg';
                 } else if (statusPath.endsWith('.gif')) {
                   fileExt = '.gif';
                 } else if (statusPath.endsWith('.mp4')) {
                   fileExt = '.mp4';
                 }

                 /// Go to view status page and return result
                 final result = await Navigator.push(context, new
                 MaterialPageRoute(
                    builder: (context) => new ViewStatusScreen(
                      savedStatus: true,
                      fileExt: fileExt,
                      filePath: statusPath,
                    )
                  ));

                 // Check result
                 if (result != null) {
                   // Update user interface
                   setState(() {
                     _savedStatusList.remove(result);
                   });

                   // Show message
                   _app.showDialogInfo(
                     context: context,
                     message: 'Status successfully deleted!',
                     color: Colors.red,
                   );
                 }

                },
                child: statusPath.endsWith('.jpg') || statusPath.endsWith('.gif')
                /// Show image or gif
                ? Hero(
                  tag: statusPath,
                  child: Image.file(File(statusPath), fit: BoxFit.cover),
                )
                /// Show video thumbnail
               : FutureBuilder<String>(
                  future: _app.getVideoThumbnail(statusPath),
                  builder: (context, snapshot) {
                    /// Check result
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return Hero(
                        tag: snapshot.data,
                        child: Stack(
                          children: <Widget>[
                            Image.file(
                                File(snapshot.data),
                                width: 500, height: 500, fit: BoxFit.cover),
                            Positioned.fill(
                              child: Center(
                                  child: Icon(Icons.play_circle_outline,
                                      color: Colors.white, size: 50)
                              )
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
              ),
            );
          },
          staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven ? 2 : 3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      );
    } else {
      return Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 60.0),
          child: Text("No saved status found", style: TextStyle(
              fontSize: 18.0
          ),),
        ),
      );

    }
  }

}