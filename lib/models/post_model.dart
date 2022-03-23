class PostModel {
  String? name;
  String? uId;
  String? dateTime;
  String? profileImage;
  String? postImage;
  String? text;

  PostModel(
      {this.name,
        this.uId,
        this.dateTime,
        this.profileImage,
        this.postImage,
        this.text});

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    profileImage = json['profileImage'];
    postImage = json['postImage'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uId'] = uId;
    data['dateTime'] = dateTime;
    data['profileImage'] = profileImage;
    data['postImage'] = postImage;
    data['text'] = text;
    return data;
  }
}