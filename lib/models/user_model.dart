class UserModel {
  String? userToken;
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? profileImage;
  String? coverImage;
  String? bio;


  UserModel({this.userToken,this.name, this.email, this.phone, this.uId, this.profileImage, this.bio, this.coverImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    userToken = json['userToken'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userToken'] = userToken;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['uId'] = uId;
    data['profileImage'] = profileImage;
    data['coverImage'] = coverImage;
    data['bio'] = bio;
    return data;
  }
}