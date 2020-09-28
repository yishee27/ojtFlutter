import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_graphql/service/AuthService.dart';
import 'package:flutter_graphql/service/GraphqlService.dart';
import 'package:flutter_graphql/graphql/QueryMutation.dart';

class ListPage extends StatefulWidget {
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ListPage> {
  VoidCallback refetchQuery;
  static List<LazyCacheMap> posts;

  String _userId;
  int _corpId;

  @override
  void initState() {
    getUser();
    getCorp();
    super.initState();
  }

  @override
  void dispose() {
    print("dispose() of MainPage");
    super.dispose();
  }

  void getUser() {
    setState(() {
      _userId = GraphqlService.getUserId();
      print(_userId);
    });
  }

  void getCorp() {
    setState(() {
      _corpId = GraphqlService.getCorpId();
      print(_corpId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(39, 50, 56, 1.0),
        title: Text("Flutter"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: new Icon(
              Icons.menu,
              size: 25.0,
            ),
            shape: new CircleBorder(),
          ),
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/newone').then((value) {
            Navigator.pushReplacementNamed(context, '/main');
          });
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Query(
        options: QueryOptions(
          documentNode: gql(QueryMutation.getPosts(_corpId)),
        ),
        builder: (QueryResult result,
            {FetchMore fetchMore, VoidCallback refetch}) {
          refetchQuery = refetch;
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.loading) {
            return Text('Loading');
          }
          posts =
              (result.data['getPosts'] as List<dynamic>).cast<LazyCacheMap>();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              dynamic responseData = posts[index];
              var title = responseData["Title"];
              var userName = responseData.data['UserId'];
              var count = responseData.data['Counter'];
              var date = responseData.data['CreatedDate'];
              //var corpData = {
              //  "corpId": responseData['corpId']['corpId'],
              //  "corpName": responseData['corpId']['corpName'],
              //  "corpContactNumber": responseData['corpId']
              //      ['corpContactNumber'],
              //};
              return ListTile(
                title: Text("$title"),
                subtitle: Text("$userName   |   $date"),
                trailing: Text("조회수 $count"),
                onTap: () {
                  Navigator.pushNamed(context, '/detail',
                      arguments: <String, String>{
                        'postNo': responseData["No"]
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}
