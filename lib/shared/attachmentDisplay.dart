import 'package:expense_tracker/services/db.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ShowAttachment extends StatefulWidget {
  final String id;
  ShowAttachment({Key key, this.id}) : super(key: key);

  @override
  _ShowAttachmentState createState() => _ShowAttachmentState();
}

class _ShowAttachmentState extends State<ShowAttachment> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attachment'),
        ),
        body: Center(
            child: FutureBuilder(
          future: db.getUrl(widget.id),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              return PinchZoom(
                image: Image.network(
                  snapshot.data,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: (loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes: null).toString()
                            ,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                zoomedBackgroundColor: Colors.black.withOpacity(0.5),
                resetDuration: const Duration(milliseconds: 100),
                maxScale: 2.5,
              );
            }
          },
        )),
      ),
    );
  }
}
