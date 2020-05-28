import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
      title: 'Flutter Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController theWebViewController;
  TextEditingController theController = new TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            "http://",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      Expanded(
                        flex: 5,
                        child: TextField(
                          autocorrect: false,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                    width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                    width: 2),
                              )),
                          controller: theController,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                String finalURL = theController.text;
                                if (!finalURL.startsWith("https://")) {
                                  finalURL = "https://" + finalURL;
                                } else {
                                  finalURL = finalURL;
                                }
                                if (theWebViewController != null) {
                                  updateLoading(true);
                                  theWebViewController
                                      .loadUrl(finalURL)
                                      .then((onValue) {})
                                      .catchError((e) {
                                    updateLoading(false);
                                  });
                                }
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 12,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      initialUrl: 'http://google.com',
                      onPageFinished: (data) {
                        updateLoading(false);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (webViewController) {
                        theWebViewController = webViewController;
                      },
                    ),
                    (showLoading)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
