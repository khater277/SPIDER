class MessageModel {
  String? text;
  String? image;
  String? date;
  String? senderID;
  String? receiverID;
  bool? isRead;

  MessageModel({this.text,this.image, this.date, this.senderID, this.receiverID,this.isRead});

  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    image = json['image'];
    date = json['date'];
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['image'] = image;
    data['date'] = date;
    data['senderID'] = senderID;
    data['receiverID'] = receiverID;
    data['isRead'] = isRead;
    return data;
  }
}