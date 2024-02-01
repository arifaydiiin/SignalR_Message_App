import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_first_project/chat_screen.dart';
import 'package:signalr_first_project/models/users_model.dart';

class ChatMain extends StatefulWidget {
  HubConnection hubConnection;
  String girisYapanUserName;
  ChatMain(
      {super.key,
      required this.hubConnection,
      required this.girisYapanUserName});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  void initState() {
    BaslangictaKullanicilariGetir();
    super.initState();
  }

  List<String> listofUsersNames = [];
  Future BaslangictaKullanicilariGetir() async {
    await widget.hubConnection.invoke("ListUsers");
  }

  TextEditingController usernameController = TextEditingController();
  Future kullaniciekle() async {
    await widget.hubConnection
        .invoke("AddUser", args: [usernameController.text]);
  }

  List<User> userList = [];
  @override
  Widget build(BuildContext context) {
    widget.hubConnection.on('ListUsersToClient', (message) {
      //Server tarafından çağırılan kullanıcılar listeleniyor.
      userList =
          List<User>.from(message![0].map((model) => User.fromJson(model)));
      userList.remove(userList
          .where((element) =>
              element.userName ==
              widget
                  .girisYapanUserName) //Kullanıcının kendisini listeden sildik.
          .first);
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(36, 71, 158, 1),
        title: Text(
          "Giriş Yapan Kullanıcı " + widget.girisYapanUserName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ChatScreen(
                                    hubConnection: widget.hubConnection,
                                    userName: userList[index].userName,
                                    girisYapmisKullanici:
                                        widget.girisYapanUserName))));
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.message, color: Colors.red),
                        ),
                        title: Text(
                          userList[index].userName,
                          style: TextStyle(color: Colors.black),
                        ),
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
