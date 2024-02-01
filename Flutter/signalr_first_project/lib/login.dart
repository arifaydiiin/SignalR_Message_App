import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_first_project/chat_main_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final hubConnection = HubConnectionBuilder()
      .withUrl('http://10.0.2.2:5000/FlutterHub')
      .withAutomaticReconnect()
      .build();

  @override
  void initState() {
    super.initState();
    hubConnection.start();
  }

  TextEditingController usernameController = TextEditingController();

  Future kullaniciekle() async {
    await hubConnection.invoke("AddUser", args: [usernameController.text]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(),
                                  child: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Kullanıcı Adı",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: GestureDetector(
                              onTap: () async {
                                await kullaniciekle();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ChatMain(
                                            hubConnection: hubConnection,
                                            girisYapanUserName:
                                                usernameController.text))));
                              },
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
