class LastMessageModel {
  String? lastMessage;
  String? senderID;
  String? date;
  bool? unReadMessages;

  LastMessageModel({this.lastMessage, this.senderID,this.date,this.unReadMessages});

  LastMessageModel.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'];
    senderID = json['senderID'];
    date = json['date'];
    unReadMessages = json['unReadMessages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lastMessage'] = lastMessage;
    data['senderID'] = senderID;
    data['date'] = date;
    data['unReadMessages'] = unReadMessages;
    return data;
  }
}