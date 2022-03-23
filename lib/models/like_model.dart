class LikeModel {
  bool? like;
  String? name;
  String? profileImage;

  LikeModel({this.like, this.name, this.profileImage});

  LikeModel.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['like'] = like;
    data['name'] = name;
    data['profileImage'] = profileImage;
    return data;
  }
}