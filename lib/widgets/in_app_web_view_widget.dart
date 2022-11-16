import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sd_app/providers/clients_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // runApp(MultiProvider(
  //   providers: [ChangeNotifierProvider(create: (context) => ServerProvider())],
  //   child: const MaterialApp(home: InAppWebViewWidget()),
  // ));
  runApp(const MaterialApp(home: InAppWebViewWidget()));
}

class InAppWebViewWidget extends StatefulWidget {
  const InAppWebViewWidget({Key? key}) : super(key: key);

  @override
  _InAppWebViewWidgetState createState() => _InAppWebViewWidgetState();
}

class _InAppWebViewWidgetState extends State<InAppWebViewWidget> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  bool lock = false;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //String serverData = context.watch<RobotStatusProvider>().getStreamConnection;
    String serverData = context.watch<ClientsProvider>().getStreamConnection;
    if (serverData.contains("On") && !lock) {
      print("ITS HERE");
      //var url = Uri.parse("http://192.168.1.139:5000");
      setState(() {
        var url = Uri.parse("http://192.168.1.139:5000");
        webViewController?.loadUrl(urlRequest: URLRequest(url: url));
      });
      lock = true;
    }
    return InAppWebView(
      key: webViewKey,
      // initialUrlRequest:
      //     URLRequest(url: Uri.parse("http://192.168.1.139:5003")),
      initialOptions: options,
      // contextMenu: contextMenu,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          this.url = url.toString();
          urlController.text = this.url;
        });
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController.endRefreshing();
        setState(() {
          this.url = url.toString();
          urlController.text = this.url;
        });
      },
      onLoadError: (controller, url, code, message) {
        pullToRefreshController.endRefreshing();
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController.endRefreshing();
        }
        setState(() {
          this.progress = progress / 100;
          urlController.text = this.url;
        });
      },
    );
  }
}
