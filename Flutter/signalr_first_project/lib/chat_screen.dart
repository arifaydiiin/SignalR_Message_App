import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_first_project/models/chat_model.dart';
import 'package:signalr_first_project/models/users_model.dart';

class ChatScreen extends StatefulWidget {
  String userName;
  HubConnection hubConnection;
  String girisYapmisKullanici;
  ChatScreen(
      {Key? key,
      required this.userName,
      required this.hubConnection,
      required this.girisYapmisKullanici})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    tumMesajlariAl();
    super.initState();
  }

  List<Chats> listofchat = [];
  TextEditingController textEditingController = TextEditingController();
  Future tumMesajlariAl() async {
    await widget.hubConnection.invoke("TumMesajlariAl",
        args: [widget.girisYapmisKullanici, widget.userName]);
  }

  Future MesajGonder() async {
    await widget.hubConnection.invoke("MesajGonder",
        args: [widget.userName, textEditingController.text]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.hubConnection.on("MesajlariAl", (message) {
      listofchat =
          List<Chats>.from(message![0].map((model) => Chats.fromJson(model)));
      setState(() {});
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: const Color(0xFF007AFF),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Align(
                  alignment: Alignment.topRight,
                  child: ListView.builder(
                    itemCount: listofchat.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: listofchat[index].vericiUserName ==
                                widget.girisYapmisKullanici
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 5.0, right: 8.0, top: 8.0, bottom: 2.0),
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xFF87D4E6),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Text(
                            listofchat[index].message!,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),
          SafeArea(
            bottom: true,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E5EA),
                  ),
                ),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        right: 42,
                        left: 16,
                        top: 18,
                      ),
                      hintText: 'message',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  // custom suffix btn
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        await MesajGonder();
                        textEditingController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
