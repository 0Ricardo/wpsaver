import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/app/app.dart';
import 'package:status_saver/widgets/play_video.dart';

class ViewStatusScreen extends StatefulWidget {

  final String fileExt;
  final String filePath;
  final bool savedStatus;
  
  ViewStatusScreen({
    @required this.filePath,
    @required this.fileExt,
    @required this.savedStatus,
  });
 
  @override
  _ViewStatusScreenState createState() => _ViewStatusScreenState();
}

class _ViewStatusScreenState extends State<ViewStatusScreen> {

  // Variables
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _app = new App();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          widget.savedStatus
          ? _savedStatusesButton()
          : FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.file_download), //`Icon` to display
            label: Text('SAVE', style: TextStyle(
                fontSize:20.0
            )), //`Text` to display
            onPressed: () async{
              /// Save image
              _app.saveFileInGallery(
                  context: context,
                  scaffoldKey: _scaffoldKey,
                  filePath: widget.filePath,
                  fileExt: widget.fileExt
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 65),
        child:
        widget.fileExt == '.mp4'
        ? PlayVideo(videoSrc: widget.filePath)
        : Hero(
          tag: widget.filePath,
          child: Image.file(File(widget.filePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  Widget _savedStatusesButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              /// Delete status
              File(widget.filePath).deleteSync();
              Navigator.pop(context, widget.filePath);
            },
          ),
          SizedBox(width: 15),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
                /// Share status
                try {

                  final String fileName = widget.filePath.split('${_app.appName}\/')[1];
                  String mimeType;

                  // Check file extension
                  switch (widget.fileExt) {
                    case '.jpg':
                      mimeType = 'image/jpg';
                      break;
                    case '.gif':
                      mimeType = 'image/gif';
                      break;
                    case '.mp4':
                      mimeType = 'video/mp4';
                      break;
                  }

                  print('Share file -> mimeType: $mimeType, fileName:  $fileName');

                  final Uint8List bytes = File(widget.filePath).readAsBytesSync();

                  await Share.file(
                    'Share', fileName, bytes.buffer.asUint8List(), mimeType
                  );

                } catch (error) {
                  print('Error while sharing status: $error');
                  // Show message
                  _app.showDialogInfo(
                    context: context,
                    message: 'Oops! Error while sharing this status\n'
                        'Solution: Go to File Manager of your phone: '
                        'Open -> ${_app.appName} folder '
                        'and try to share it there!',
                  );
                }

            },
          ),
        ],
      ),
    );

  }


}