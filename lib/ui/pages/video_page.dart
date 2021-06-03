import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:rumbero/logic/entity/model_reponses/video_model_response.dart';

class VideoPage extends StatefulWidget {
  final VideoModelResponse video;
  VideoPage({Key key, this.video}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int _stackToView;

  @override
  void initState() {
    super.initState();
    _stackToView = 1;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double h = screenSize.height;
    double w = screenSize.width;

    String iframe = widget.video.url;

    iframe = iframe.replaceAllMapped(new RegExp(r'(?<=height=")(\d*)(?=")'),
        (match) {
      return h.toString();
    });

    iframe =
        iframe.replaceAllMapped(new RegExp(r'(?<=width=")(\d*)(?=")'), (match) {
      return w.toString();
    });

    return IndexedStack(
      index: _stackToView,
      children: [
        Column(
          children: <Widget>[
            Expanded(
                child: WebView(
              initialUrl:
                  Uri.dataFromString(iframe, mimeType: 'text/html').toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _stackToView = 0;
                });
              },
              onWebResourceError: (webviewerrr) {
                print(webviewerrr);
              },
            )),
          ],
        ),
        Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
