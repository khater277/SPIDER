class CommentModel {
  String? userID;
  String? name;
  String? profileImage;
  String? comment;
  String? date;


  CommentModel({this.userID,this.name, this.profileImage, this.comment, this.date});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    profileImage = json['profileImage'];
    comment = json['comment'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['comment'] = comment;
    data['date'] = date;
    return data;
  }
}