import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_graphql/service/GraphqlService.dart';
import 'package:flutter_graphql/graphql/QueryMutation.dart';

class DetailPage extends StatefulWidget {
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<DetailPage> {
  TextEditingController replyController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

  String _postId;
  String _userId;
  int _corpId;

  var userId;

  VoidCallback refetchQuery;
  static List<LazyCacheMap> post;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;

    setState(() {
      _postId = args['postNo'];
      _userId = GraphqlService.getUserId();
      _corpId = GraphqlService.getCorpId();
      print(_postId);
    });

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(39, 50, 56, 1.0),
          title: Text("Flutter"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.arrow_back,
                size: 25.0,
              ),
              shape: new CircleBorder(),
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Query(
                    options: QueryOptions(
                      documentNode: gql(QueryMutation.readPosts(_postId)),
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
                      post = (result.data['readPosts'] as List<dynamic>)
                          .cast<LazyCacheMap>();

                      userId = post[0]["UserId"];

                      return Column(children: <Widget>[
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text(
                              "제목 : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text(
                              post[0]["Title"],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text(
                              "작성자 : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 40),
                            child: Text(
                              post[0]["UserId"],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Container(
                            width: 340,
                            margin: EdgeInsets.only(top: 25),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                )),
                            child: Text(
                              post[0]["Contents"],
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          Container(
                            child: button(),
                          ),
                        ]),
                      ]);
                    }),
                createReply(),
                showReply(),
              ],
            )));
  }

  Widget createReply() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: replyController,
                decoration:
                    new InputDecoration.collapsed(hintText: "댓글을 입력해주세요."),
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  GraphqlService.createReplyService(
                      replyController.text, _userId, _postId, _corpId);
                  Navigator.pushNamed(context, '/detail',
                      arguments: <String, String>{'postNo': _postId});
                },
              ),
            )
          ],
        ));
  }

  Widget showReply() {
    return Expanded(
        child: Query(
            options: QueryOptions(
              documentNode: gql(QueryMutation.getReply(_postId)),
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
              post = (result.data['getReply'] as List<dynamic>)
                  .cast<LazyCacheMap>();

              return ListView.builder(
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    dynamic responseData = post[index];
                    var writer1 = responseData.data['UserId'];
                    var contents1 = responseData.data['Contents'];
                    //var date = new DateTime.fromMicrosecondsSinceEpoch(
                    //1000 * int.parse(responseData['CreatedDate']),
                    return ListTile(
                      title: Text("$writer1 | $contents1"),
                    );
                  });
            }));
  }

  Widget button() {
    if (userId == _userId) {
      return ButtonBar(mainAxisSize: MainAxisSize.min, children: <Widget>[
        RaisedButton(
            color: Color.fromRGBO(39, 50, 56, 1.0),
            child: Text(
              "수정",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              _updatePostDialog();
            }),
        RaisedButton(
            color: Colors.grey,
            child: Text("삭제"),
            onPressed: () {
              _deletePostDialog();
            }),
      ]);
    } else {
      return null;
    }
  }

  void _updatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("수정"),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "제목"),
                    controller: titleController,
                  ),
                  TextField(
                    maxLines: 10,
                    decoration: InputDecoration(labelText: "내용"),
                    controller: contentsController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    print(post[0]);
                    if (titleController.text.isNotEmpty &&
                        contentsController.text.isNotEmpty) {
                      GraphqlService.updatePostService(_postId,
                          titleController.text, contentsController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Update")),
              FlatButton(
                  onPressed: () {
                    titleController.clear();
                    contentsController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ]);
      },
    );
  }

  void _deletePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("삭제"),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[Text("삭제하시겠습니까?")],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    GraphqlService.deletePostService(_postId);

                    Navigator.pop(context);
                  },
                  child: Text("Delete")),
              FlatButton(
                  onPressed: () {
                    titleController.clear();
                    contentsController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ]);
      },
    );
  }
}
