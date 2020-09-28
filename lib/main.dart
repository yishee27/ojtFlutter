import 'package:flutter/material.dart';
import 'package:flutter_graphql/page/LoginPage.dart';
import 'package:flutter_graphql/page/JoinPage.dart';
import 'package:flutter_graphql/page/ListPage.dart';
import 'package:flutter_graphql/page/DetailPage.dart';
import 'package:flutter_graphql/page/NewonePage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_graphql/service/GraphqlService.dart';

GraphqlService graphqlService = GraphqlService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GraphQLProvider(
      client: GraphqlService.client(),
      child: CacheProvider(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
        routes: {
          '/home': (context) => LoginPage(),
          '/join': (context) => JoinPage(),
          '/main': (context) => ListPage(),
          '/detail': (context) => DetailPage(),
          '/newone': (context) => NewonePage()
        });
  }
}

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
