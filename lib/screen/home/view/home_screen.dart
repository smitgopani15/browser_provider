import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? homeProvidertrue;
  HomeProvider? homeProviderfalse;
  TextEditingController searchc = TextEditingController();
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.white,
        backgroundColor: Colors.black,
      ),
      onRefresh: () {
        homeProvidertrue!.inAppWebViewController!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    homeProvidertrue = Provider.of<HomeProvider>(context, listen: true);
    homeProviderfalse = Provider.of<HomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      homeProvidertrue!.inAppWebViewController!.goBack();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      homeProvidertrue!.inAppWebViewController!.goForward();
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      homeProvidertrue!.inAppWebViewController!.reload();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      searchc.clear();
                      homeProvidertrue!.inAppWebViewController!
                        ..loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse(
                              "https://www.google.com/",
                            ),
                          ),
                        );
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  var search = searchc.text;
                                  homeProvidertrue!.inAppWebViewController!
                                      .loadUrl(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(
                                        "https://www.google.com/search?q=$search",
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchc,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search URL",
                                  iconColor: Colors.black,
                                  prefixIconColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            LinearProgressIndicator(
              value: homeProvidertrue!.progressbar,
              color: Colors.black,
              backgroundColor: Colors.white,
              minHeight: 8,
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://www.google.com/"),
                ),
                pullToRefreshController: pullToRefreshController!,
                onWebViewCreated: (controller) {
                  homeProvidertrue!.inAppWebViewController = controller;
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController!.endRefreshing();
                  homeProvidertrue!.inAppWebViewController = controller;
                },
                onLoadStart: (controller, url) {
                  homeProvidertrue!.inAppWebViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController!.endRefreshing();

                  homeProvidertrue!.inAppWebViewController = controller;
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController!.endRefreshing();
                  }
                  homeProviderfalse!.changeprogressbar(progress / 100);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
