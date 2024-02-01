class Chats {
  String? connectionId;
  String? aliciUserName;
  String? vericiUserName;
  String? message;

  Chats({ this.connectionId, this.aliciUserName,this.vericiUserName, this.message});

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      connectionId: json['connectionId'],
      aliciUserName: json['aliciUserName'],
      vericiUserName:json['vericiUserName'],
      message:json['message']
    );
  }
}