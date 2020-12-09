import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/home/Screens/postCreation.dart';
import 'package:not_whatsapp/home/Screens/profile.dart';
import 'package:not_whatsapp/services/auth.dart';
import 'package:not_whatsapp/shared/const.dart';
import 'package:not_whatsapp/shared/postCard.dart';

import '../shared/const.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 245, 206, 1.0),
          title: Text(
            "Vertical Y",
            style: TextStyle(
              fontSize: 29,
              color: Color.fromRGBO(101, 97, 125, 1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreatePost(
                              FirebaseFirestore.instance.collection('news'))));
                },
                icon: Icon(
                  Icons.local_post_office,
                  color: Color.fromRGBO(101, 97, 125, 1.0),
                ),
                label: Text("New Post",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(101, 97, 125, 1.0),
                    ))),
            IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 20,
                  color: Color.fromRGBO(101, 97, 125, 1.0),
                ),
                onPressed: () {
                  signout(context);
                })
          ],
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(101, 97, 125, 1.0),
            tabs: [
              Tab(
                text: "News",
                icon: Icon(Icons.rss_feed,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
              ),
              Tab(
                text: "Chat",
                icon:
                    Icon(Icons.chat, color: Color.fromRGBO(101, 97, 125, 1.0)),
              ),
              Tab(
                icon: Icon(Icons.notifications,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
                text: "Notifys",
              ),
              Tab(
                icon: Icon(Icons.account_circle,
                    color: Color.fromRGBO(101, 97, 125, 1.0)),
                text: "Profile",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [Feeds(), Message(), Notifications(), Profile()],
        ),
      ),
    );
  }
}

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  final TextEditingController title = TextEditingController();
  final TextEditingController des = TextEditingController();

  CollectionReference newsRefs = FirebaseFirestore.instance.collection('news');

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    des.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(213, 210, 221, 0.1),
      body: StreamBuilder<QuerySnapshot>(
          stream: newsRefs.orderBy('order', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length != 0 &&
                  snapshot.data.docs != null) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      // used to get indexes of all documents present in collections
                      dspostid = snapshot.data.docs[
                          index]; //used to get indexes of all documents present in collections
                      print(snapshot.data.docs[index].id);
                      return Post(
                          ds: dspostid,
                          newsrefs: newsRefs,
                          uid: snapshot.data.docs[index]['uid']);
                      // used to get indexes of all documents present in collections
                    });
              } else {
                return Center(
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Text(
                      "Yay 🙌 You Have The Chance To become out first Person To Post Don't Miss this Opportunity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500]),
                    ),
                  ),
                );
              }
            } else {
              return Container(
                child: Text(
                  "I was Feeling bored. So, I just posted it blank",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[200]),
                ),
              );
            }
          }),
    );
  }
}

// ignore: must_be_immutable

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController searchbyname = TextEditingController();

  QuerySnapshot snap;

  getUseName() {
    FirebaseFirestore.instance
        .collection('profile')
        .where('name', isEqualTo: searchbyname.text)
        .get()
        .then((value) {
      setState(() {
        snap = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUseName();
  }

  Widget searchList() {
    return snap != null
        ? ListView.builder(
            itemCount: snap.docs.length,
            itemBuilder: (context, index) {
              return Container(
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(snap.docs[0]['name']),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "Message",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {}),
                  ],
                ),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchbyname,
                )),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getUseName();
                    })
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width / 1.2,
            child: searchList(),
          )
        ],
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
