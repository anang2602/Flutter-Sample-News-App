import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:sample_news_app/models/news.dart';
import 'dart:async';
import 'dart:convert';

//aplikasi di jalankan di main
void main() => runApp(MyApp());

//widget yang pertama kali dijalankan karena di deklarasikan di run(MyApp())
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //material app digunakan untuk menentukan tema, color, routes di seluruh aplikasi
    return MaterialApp(
      title: 'Sample News',
      //theme data merupakan tema aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home merupakan tampilan yang pertama kali di jalankan
      //pada program ini yang pertama kali di jalankan adalah MyHomePage
      routes:{
         '/': (context) => MyHomePage(),
      },
      initialRoute: '/',
    );
  }
}

//kelas MyHomePage yang merupakan stateful widget
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  _MyHomePageState createState() => _MyHomePageState();
}

//stateful widget memerlukan state
//ini merupakan state dari MyHomePage
class _MyHomePageState extends State<MyHomePage> {

  //endpoint webservice
  final String apiUrl = "https://newsapi.org/v2/top-headlines?country=id&apiKey=API_kEY";

  //mengambil dataa dari webservice
  Future<News> getNews() async {
    final response = await http.Client().get(apiUrl);
    if(response.statusCode != 200) {
      throw Exception();
    }
    final responseJson = jsonDecode(response.body);
    return News.fromJson(responseJson);
  }
  //init State di jalankan ketika widget pertama kali di inisialisasikan
  @override
  void initState() {
    super.initState();
  }

  //build merupakan tampilan yang di bangun pada widget ini
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'News',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0
          )
        ),
      ),
      //future builder ini berfungsi untuk menjalankan future function
      //ketika future function berhasil mendapatkan hasil
      //maka baru menjalankan builder function yang akan membangun tampilan widget
      body: FutureBuilder<News>(
        future: getNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                    itemCount: snapshot.data.articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebView(url: snapshot.data.articles[index].url,)
                              )
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 170,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                                  child: Image.network(
                                    snapshot.data.articles[index].urlToImage,
                                    fit: BoxFit.fill,
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data.articles[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      'Source : ${snapshot.data.articles[index].source.name}'
                                    ),
                                    Text(
                                      'Author : ${snapshot.data.articles[index].author}'
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
            );
          } else {
            return Center(child: Text(snapshot.error));
          }
        }
      ),
    );
  }
}

class WebView extends StatefulWidget {
  //parameter
  final String url;
  const WebView({Key key, this.url}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

//halaman webview
class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        routes: {
          "/": (_) => new WebviewScaffold(
           appBar: AppBar(
             title: Text('Detail'),
           ),
           hidden: true,
           url: widget.url,
            initialChild: Container(
              color: Colors.white,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),
          )
        },
      )
    );
  }
}
