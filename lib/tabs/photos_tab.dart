import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/screens/view_status_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class PhotosTab extends StatefulWidget {
  @override
  _PhotosTabState createState() {
    return new _PhotosTabState();
  }
}

class _PhotosTabState extends State<PhotosTab> {

  // Variables
  final App _app = new App();
  List _imageList;


  @override
  void initState() {
    super.initState();

      // Get Statuses path
      _app.getStatusesPath().then((path) {
          // Check statuses dir
          if (Directory(path).existsSync()) {
            print('yes dir exists');
            if (mounted)
              setState(() {
                _imageList = Directory(path).listSync().map((item) => item.path)
                    .where((item) => item.endsWith(".jpg") || item.endsWith(".gif")).toList();
              });
        }
      });

  }

  @override
  Widget build(BuildContext context) {
      return  _showPhotoStatuses();
  }

  Widget _showPhotoStatuses() {
    /// Check list
    if (_imageList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );

    } else if (_imageList.isNotEmpty) {

      return Container(
        padding: EdgeInsets.only(bottom: 65.0),
        child: StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: _imageList.length,
          itemBuilder: (context, index) {
            String imgPath = _imageList[index];
            return Material(
              elevation: 8.0,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: GestureDetector(
                onTap: () {
                    final fileExt = imgPath.endsWith(".jpg") ? '.jpg' : '.gif';
                    /// Go to view status page
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new ViewStatusScreen(
                          savedStatus: false,
                          fileExt: fileExt,
                          filePath: imgPath,
                        )
                    ));
                },
                child: Hero(
                  tag: imgPath,
                  child: Image.file(
                    File(imgPath),
                    fit: BoxFit.cover,
                  ),
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
          child: Text("No image found", style: TextStyle(
              fontSize: 18.0
          ),),
        ),
      );

    }
  }

}