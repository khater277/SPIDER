import 'dart:io';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:spider/models/comment_model.dart';
import 'package:spider/models/last_message_model.dart';
import 'package:spider/models/like_model.dart';
import 'package:spider/models/message_model.dart';
import 'package:spider/models/post_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/network/local/cache_helper.dart';
import 'package:spider/network/reomte/http_helper.dart';
import 'package:spider/screens/chats/chats_screen.dart';
import 'package:spider/screens/chats/send_image_screen.dart';
import 'package:spider/screens/feeds/feeds_screen.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/login/login_screen.dart';
import 'package:spider/screens/post/post_screen.dart';
import 'package:spider/screens/profile/profile_screen.dart';
import 'package:spider/screens/users/users_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';


class SpiderCubit extends Cubit<SpiderStates>{
  SpiderCubit() : super(SpiderInitialState());
  static SpiderCubit get(context)=>BlocProvider.of(context);

  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const PostScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];

  List<String> titles = [
    "homeAppBar",
    "chatAppBar",
    "postAppBar",
    "userAppBar",
    "profileAppBar",
  ];

  int currentIndex = 0;
  void changeNavBar(int index,) {
    if(index==1){
      currentIndex=index;
      getChats();
    }
    else if(index==4){
      currentIndex=index;
      getMyPosts();
    }
    if (index == 2) {
      emit(SpiderAddPostState());
    }
    else {
      currentIndex = index;
      emit(SpiderNavBarState());
    }
  }

  bool ar = false;
  bool en = false;
  Color arColor=Colors.white;
  Color enColor=Colors.white;
  void selectLanguage({@required bool? arabic,@required bool? english}){
    if(arabic==true){
      ar=true;
      en=false;
      arColor=Colors.blue.withOpacity(0.3);
      enColor=enColor=Colors.white;
      changeAppLanguage('ar');
    }else{
      en=true;
      ar=false;
      enColor=Colors.blue.withOpacity(0.3);
      arColor=Colors.white;
      changeAppLanguage('en');
    }
    emit(SelectLanguageState());
  }

  String? selectedValue=lang ?? (defaultLang=='ar'?'ar':'en');
  void changeAppLanguage(String value){
    selectedValue=value;
    CacheHelper.saveData(key: 'lang', value: value)
        .then((v){
      lang=value;
      Get.updateLocale(Locale(value));
      print(lang);
    });
    emit(SpiderChangeLanguageState());
  }

  void openChats(){
    currentIndex=1;
    getChats();
  }

  void openMyProfile(){
    currentIndex = 4;
    getMyPosts();
    emit(SpiderNavBarState());
  }

  void popHome(context){
    currentIndex=0;
    navigateAndFinish(context: context, widget: const HomeScreen());
    emit(SpiderNavBarState());
  }

  void logOut(context){
      FirebaseFirestore.instance.collection('users')
      .doc(uId!)
      .update(UserModel(
        userToken: "",
        name: userModel!.name!,
        email: userModel!.email!,
        phone: userModel!.phone!,
        uId: userModel!.uId!,
        profileImage: userModel!.profileImage!,
        bio: userModel!.bio!,
        coverImage: userModel!.coverImage!,
      ).toJson())
      .then((value){
        CacheHelper.removeData(key: "uID");
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.screenRoute, (route) => false);
        currentIndex=0;
        posts=[];
        postsID=[];
        postLikes=[];
        postComments=[];
        colors=[];
        likesID=[];
        allUsers=[];
        following=[];
        followers=[];
        emit(SpiderLogOutState());
      }).catchError((error){
        printError("logOut", error.toString());
        emit(SpiderLogOutState());
      });
  }

  void login(){
      currentIndex=0;
      posts=[];
      postsID=[];
      postLikes=[];
      postComments=[];
      colors=[];
      likesID=[];
      allUsers=[];
      following=[];
      followers=[];
    emit(SpiderLoginState());
  }

  UserModel? userModel;
  void getUserData(){
    emit(SpiderGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .get()
        .then((value){
      userModel=UserModel.fromJson(value.data()!);
      FirebaseFirestore.instance.collection('users')
      .doc(userModel!.uId)
      .update({
        "uId":userModel!.uId,
        "name":userModel!.name,
        "email":userModel!.email,
        "phone":userModel!.phone,
        "profileImage":userModel!.profileImage,
        "coverImage":userModel!.coverImage,
        "bio":userModel!.bio,
        "userToken":token,
      })
      .then((value){
        getMyRequests();
        getFollowRequest();
        getFollowers();
        getFollowing();
        getLastMessages();
        emit(SpiderGetUserDataSuccessState());
      }).catchError((error){
        printError("getUserData", error.toString());
        emit(SpiderGetUserDataErrorState());
      });
    }).catchError((error){
      printError("getUserData", error.toString());
      emit(SpiderGetUserDataErrorState());
    });
  }

  updateUserData({
    String? name,
    String? bio,
    String? phone,
    String? profileImage,
    String? coverImage,
  }){
    UserModel model = UserModel(
        name:name??userModel!.name,
        bio: bio??userModel!.bio,
        phone: phone??userModel!.phone,
        coverImage:coverImage??userModel!.coverImage,
        profileImage:profileImage??userModel!.profileImage,
        email: userModel!.email,
        uId: userModel!.uId
    );
    emit(SpiderUpdateUserDataLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .update(model.toJson())
        .then((value){
      if(name!=null){
        updateMyPostsName(name: name);
      }
      for(int i=0;i<posts.length;i++){
        if(posts[i].uId==userModel!.uId){
          updatePostProfileImage(i,name: name);
        }
      }
      updateLikesCommentsPicAndName(name: name);
      getUserData();
      if(name!=null){
        posts=[];
        postsID=[];
        postLikes=[];
        postComments=[];
        colors=[];
        likesID=[];
        getPosts();
        getMyPosts();
      }
      emit(SpiderUpdateUserDataSuccessState());
    }).catchError((error){
      printError("updateUserData", error.toString());
      emit(SpiderUpdateUserDataErrorState());
    });
  }

  void updateMyPostsName({@required String? name}){
    //emit(SpiderUpdateMyPostsNameSuccessState());
    for(int i=0;i<myPosts.length;i++){
      PostModel postModel = PostModel(
        name: name,
        uId: myPosts[i].uId,
        dateTime: myPosts[i].dateTime,
        postImage: myPosts[i].postImage,
        profileImage: myPosts[i].profileImage,
        text: myPosts[i].text,
      );
      FirebaseFirestore.instance.collection('users')
          .doc(userModel!.uId)
          .collection('MyPosts')
          .doc(myPostsID[i])
          .update(postModel.toJson())
          .then((value){
        emit(SpiderUpdateMyPostsNameSuccessState());
      }).catchError((error){
        printError("UPDATE NAME IN MY POSTS", error.toString());
        emit(SpiderUpdateMyPostsNameSuccessState());
      });
    }
  }

  ImagePicker picker = ImagePicker();

  File? profileImage;
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SpiderGetProfileImageSuccessState());
    } else {
      emit(SpiderGetProfileImageErrorState());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SpiderGetCoverImageSuccessState());
    } else {
      printError("getCoverImage", "No Image Selected");
      emit(SpiderGetCoverImageErrorState());
    }
  }

  void setProfileImage(){
    emit(SpiderSetProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance.ref(
        "users/${Uri.file(profileImage!.path).pathSegments.last}"
    ).putFile(profileImage!).then((p0){
      p0.ref.getDownloadURL().then((value){
        for(int i=0;i<posts.length;i++) {
          if (posts[i].uId == userModel!.uId) {
            updatePostProfileImage(i, profileImage: value);
            debugPrint("===============>${postsID[i]}");
            updateMyPostsProfileImage(postsID[i],profileImage: value);
          }
        }
        updateLikesCommentsPicAndName(profileImage: value);
        updateUserData(profileImage: value);
        posts=[];
        postsID=[];
        postLikes=[];
        postComments=[];
        colors=[];
        likesID=[];
        getPosts();
        getMyPosts();
        profileImage=null;
        emit(SpiderSetProfileImageSuccessState());
      }).catchError((error){
        printError("setProfileImage", error.toString());
        emit(SpiderSetProfileImageErrorState());
      });

    }).catchError((error){
      printError("setProfileImage", error.toString());
      emit(SpiderSetProfileImageErrorState());
    });
  }

  void updateMyPostsProfileImage(String postID,{
    String? profileImage,
    String? name
  }){
    int index=myPostsID.indexOf(postID);
    PostModel postModel =PostModel(
        name: name??myPosts[index].name,
        uId: myPosts[index].uId,
        dateTime: myPosts[index].dateTime,
        profileImage:profileImage??myPosts[index].profileImage,
        postImage: myPosts[index].postImage,
        text: myPosts[index].text
    );
    emit(SpiderUpdateMyPostsProfileImageLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyPosts')
        .doc(postID)
        .update(postModel.toJson())
        .then((value){
      emit(SpiderUpdateMyPostsProfileImageSuccessState());
    }).catchError((error){
      printError("updateMyPostsProfileImage", error.toString());
      emit(SpiderUpdateMyPostsProfileImageErrorState());
    });
  }

  void updatePostProfileImage(int index,{
    String? profileImage,
    String? name
  }){
    PostModel postModel =PostModel(
        name: name??posts[index].name,
        uId: posts[index].uId,
        dateTime: posts[index].dateTime,
        profileImage:profileImage??posts[index].profileImage,
        postImage: posts[index].postImage,
        text: posts[index].text
    );
    emit(SpiderUpdatePostProfileImageLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postsID[index])
        .update(postModel.toJson())
        .then((value){
      //print("======================>${postsID[index]}");
      emit(SpiderUpdatePostProfileImageSuccessState());
    }).catchError((error){
      printError("updatePostProfileImage", error.toString());
      emit(SpiderUpdatePostProfileImageErrorState());
    });
  }

  void setCoverImage(){
    emit(SpiderSetCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance.ref(
        "users/${Uri.file(coverImage!.path).pathSegments.last}"
    ).putFile(coverImage!).then((p0){
      p0.ref.getDownloadURL().then((value){
        updateUserData(coverImage: value);
        coverImage=null;
        emit(SpiderSetCoverImageSuccessState());
      }).catchError((error){
        printError("setCoverImage", error.toString());
        emit(SpiderSetCoverImageErrorState());
      });
    }).catchError((error){
      printError("setCoverImage", error.toString());
      emit(SpiderSetCoverImageErrorState());
    });
  }

  void createPost({
    @required String? text,
    String? postImage,
  }){
    PostModel postModel=PostModel(
        name: userModel!.name,
        uId: userModel!.uId,
        profileImage: userModel!.profileImage,
        dateTime: DateTime.now().toString(),
        text: text,
        postImage: postImage??""
    );
    emit(SpiderCreatePostLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .add(postModel.toJson())
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(userModel!.uId)
          .collection('MyPosts')
          .doc(value.id)
          .set(postModel.toJson())
          .then((value){
        posts = [];
        postLikes = [];
        postComments = [];
        postsID = [];
        likesID = [];
        colors = [];
        getPosts();
        getMyPosts();
        emit(SpiderCreatePostSuccessState());
      }).catchError((error){
        printError("createPost", error.toString());
        emit(SpiderCreatePostErrorState());
      });
    }).catchError((error){
      printError("createPost", error.toString());
      emit(SpiderCreatePostErrorState());
    });
  }


  void deletePost({@required int? index}){
    emit(SpiderDeletePostLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(myPostsID[index!])
        .delete();
    /////////////////////////////////////////////////
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyPosts')
        .doc(myPostsID[index])
        .delete();
    posts = [];
    postLikes = [];
    postComments = [];
    postsID = [];
    likesID = [];
    colors = [];
    getPosts();
    getMyPosts();
  }

  File? postImage;
  void getPostImage()async{
    final pickedFile=(await picker.pickImage(source: ImageSource.gallery));
    if(pickedFile!=null){
      postImage=File(pickedFile.path);
      emit(SpiderGetPostImageSuccessState());
    }else{
      printError("getPostImage", "No Image Selected");
      emit(SpiderGetPostImageErrorState());
    }
  }

  void setPostImage({@required String? text}){
    emit(SpiderSetPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance.ref(
        "posts/${Uri.file(postImage!.path).pathSegments.last}"
    ).putFile(postImage!).then((p0){
      p0.ref.getDownloadURL().then((value){
        createPost(
            text: text,
            postImage: value
        );
        emit(SpiderSetPostImageSuccessState());
      }).catchError((error){
        printError("setPostImage", error.toString());
        emit(SpiderSetPostImageErrorState());
      });
    }).catchError((error){
      printError("setPostImage", error.toString());
      emit(SpiderSetPostImageErrorState());
    });
  }

  void removePostImage(){
    postImage=null;
    emit(SpiderRemovePostImageSuccessState());
  }


  List<PostModel> posts = [];
  List<int> postLikes = [];
  List<int> postComments = [];
  List<String> postsID = [];
  List<Map<String, List<String>>> likesID = [];
  List<Color> colors = [];
  String? currentID;

  void getPosts() {
    emit(SpiderGetPostsLoadingState());
    FirebaseFirestore.instance.collection("posts").get()
        .then((value) {
      for (var element in value.docs) {
        List<String> likes = [];
        element.reference.collection('likes').get()
            .then((value) {
          element.reference.collection('comments').get()
              .then((v){
            postsID.add(element.id);
            postLikes.add(value.docs.length);
            posts.add(PostModel.fromJson(element.data()));
            likesFormat(value.docs, likes, element.id);
            postComments.add(v.docs.length);
            emit(SpiderGetPostsSuccessState());
          }).catchError((error){
            printError("get comments",error.toString());
            emit(SpiderGetPostsErrorState());
          });
        }).catchError((error) {
          printError("get likes",error.toString());
          emit(SpiderGetPostsErrorState());
        });
      }
    }).catchError((error) {
      printError("getPosts", error.toString());
      emit(SpiderGetPostsErrorState());
    });
  }

  List<PostModel> myPosts=[];
  List<String> myPostsID=[];
  List<int> myPostsLikes=[];
  List<int> myPostsComments=[];
  List<Color> myPostsColors=[];
  List<Map<String, List<String>>> myPostsLikesID = [];
  void getMyPosts(){
    myPosts=[];
    myPostsID=[];
    myPostsLikes=[];
    myPostsColors=[];
    myPostsComments=[];
    myPostsLikesID = [];
    emit(SpiderGetMyPostsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyPosts')
        .orderBy('dateTime')
        .get()
        .then((posts){
      if(posts.docs.isNotEmpty){
        for (var post in posts.docs) {
          List<String> mylikes = [];
          post.reference.collection('likes').get().then((likes) {
            post.reference.collection('comments').get().then((comments) {
              myPostsID.add(post.id);
              myPosts.add(PostModel.fromJson(post.data()));
              myPostsLikes.add(likes.docs.length);
              myPostsComments.add(comments.docs.length);
              myPostsLikesFormat(likes.docs, mylikes, post.id);
              getFollowing();
              getFollowers();
              emit(SpiderGetMyPostsSuccessState());
            }).catchError((error) {
              printError("getMyPosts", error.toString());
              emit(SpiderGetMyPostsErrorState());
            });
          }).catchError((error) {
            printError("getMyPosts", error.toString());
            emit(SpiderGetMyPostsErrorState());
          });
        }
      }else{
        getFollowing();
        getFollowers();
        emit(SpiderGetMyPostsSuccessState());
      }
    }).catchError((error){
      printError("getMyPosts", error.toString());
      emit(SpiderGetMyPostsErrorState());
    });
  }

  List<PostModel> userPosts=[];
  List<String> userPostsID=[];
  List<int> userPostsLikes=[];
  List<int> userPostsComments=[];
  List<Color> userPostsColors=[];
  List<Map<String, List<String>>> userPostsLikesID = [];
  void getUserPosts({
    @required String? userID,
  }){
    userPosts=[];
    userPostsID=[];
    userPostsLikes=[];
    userPostsLikesID = [];
    userPostsComments=[];
    userPostsColors=[];
    userFollowers=[];
    userFollowing=[];
    emit(SpiderGetUserPostsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userID)
        .collection('MyPosts')
        .get()
        .then((posts){
      if(posts.docs.isNotEmpty) {
        for (var post in posts.docs) {
          List<String> userlikes = [];
          post.reference.collection('likes').get().then((likes) {
            post.reference.collection('comments').get().then((comments) {
              userPostsID.add(post.id);
              userPosts.add(PostModel.fromJson(post.data()));
              userPostsLikes.add(likes.docs.length);
              userPostsComments.add(comments.docs.length);
              userPostsLikesFormat(likes.docs, userlikes, post.id);
              getFollowing(userID: userID);
              getFollowers(userID: userID);
              emit(SpiderGetUserPostsSuccessState());
            }).catchError((error) {
              printError("getUserPosts", error.toString());
              emit(SpiderGetUserPostsErrorState());
            });
          }).catchError((error) {
            printError("getUserPosts", error.toString());
            emit(SpiderGetUserPostsErrorState());
          });
        }
      }else{
        getFollowing(userID: userID);
        getFollowers(userID: userID);
        emit(SpiderGetUserPostsSuccessState());
      }
    }).catchError((error){
      printError("getUserPosts", error.toString());
      emit(SpiderGetUserPostsErrorState());
    });
  }

  void likesFormat(List list, List<String> likes, String elementID) {
    if (list.isEmpty) {
      likes.add("");
    } else {
      for (var v in list) {
        likes.add(v.id);
      }
    }
    if (likes.contains(uId)) {
      colors.add(Colors.red);
      likesID.add({
        elementID: likes
      });
    } else {
      colors.add(Colors.grey);
      likesID.add({
        elementID: []
      });
    }
  }

  void myPostsLikesFormat(List list, List<String> likes, String elementID) {
    if (list.isEmpty) {
      likes.add("");
    } else {
      for (var v in list) {
        likes.add(v.id);
      }
    }
    if (likes.contains(uId)) {
      myPostsColors.add(Colors.red);
      myPostsLikesID.add({
        elementID: likes
      });
    } else {
      myPostsColors.add(Colors.grey);
      myPostsLikesID.add({
        elementID: []
      });
    }
  }

  void userPostsLikesFormat(List list, List<String> likes, String elementID) {
    if (list.isEmpty) {
      likes.add("");
    } else {
      for (var v in list) {
        likes.add(v.id);
      }
    }
    if (likes.contains(uId)) {
      userPostsColors.add(Colors.red);
      userPostsLikesID.add({
        elementID: likes
      });
    } else {
      userPostsColors.add(Colors.grey);
      userPostsLikesID.add({
        elementID: []
      });
    }
  }

  void likePost({
    int? index,
    int? myIndex,
    int? userIndex,
    String? postID,
    String? myPostID,
    String? userPostID,
  }) {
    String id="";
    List<PostModel>? L;
    int? i;
    if(index!=null) {
      currentID = postsID[index];
      i=index;
      id=postID!;
      L=posts;
    }else if(myIndex!=null){
      currentID=myPostsID[myIndex];
      i=myIndex;
      id=myPostID!;
      L=myPosts;
    }else{
      currentID=userPostsID[userIndex!];
      i=userIndex;
      id=userPostID!;
      L=userPosts;
    }
    LikeModel likeModel = LikeModel(
      like: true,
      profileImage: userModel!.profileImage,
      name: userModel!.name,
    );
    emit(SpiderLikePostLoadingState());
    FirebaseFirestore.instance.collection("posts").doc(id)
        .collection("likes")
        .doc(uId)
        .set(likeModel.toJson())
        .then((value) {
      FirebaseFirestore.instance.collection('users')
          .doc(L![i!].uId)
          .collection('MyPosts')
          .doc(id)
          .collection("likes")
          .doc(uId)
          .set(likeModel.toJson())
          .then((value){
        if(index!=null){
          postLikes[index]++;
          colors[index] = Colors.red;
        }else if(myIndex!=null){
          myPostsLikes[myIndex]++;
          myPostsColors[myIndex]=Colors.red;
          int dd=postsID.indexOf(myPostsID[myIndex]);
          postLikes[dd]++;
          colors[dd] = Colors.red;
        }else{
          userPostsLikes[userIndex!]++;
          userPostsColors[userIndex]=Colors.red;
          int dd=postsID.indexOf(userPostsID[userIndex]);
          postLikes[dd]++;
          colors[dd] = Colors.red;
        }
        emit(SpiderLikePostSuccessState());
      }).catchError((error){
        emit(SpiderLikePostErrorState());
        printError("likePost", error.toString());
      });
    }).catchError((error) {
      emit(SpiderLikePostErrorState());
      printError("likePost", error.toString());
    });
  }

  void dislikePost({
    int? index,
    int? myIndex,
    int? userIndex,
    String? postID,
    String? myPostID,
    String? userPostID,
  }) {
    String id="";
    List<PostModel>? L;
    int i;
    if(index!=null) {
      currentID = postsID[index];
      i=index;
      id=postID!;
      L=posts;
    }else if(myIndex!=null){
      currentID=myPostsID[myIndex];
      i=myIndex;
      id=myPostID!;
      L=myPosts;
    }else{
      currentID=userPostsID[userIndex!];
      i=userIndex;
      id=userPostID!;
      L=userPosts;
    }
    emit(SpiderDisLikePostLoadingState());
    FirebaseFirestore.instance.collection("posts").doc(id)
        .collection("likes")
        .doc(uId)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection('users')
          .doc(L![i].uId)
          .collection('MyPosts')
          .doc(id)
          .collection("likes")
          .doc(uId)
          .delete()
          .then((value){
        if(index!=null){
          postLikes[index]--;
          colors[index] = Colors.grey;
        }else if(myIndex!=null){
          myPostsLikes[myIndex]--;
          myPostsColors[myIndex]=Colors.grey;
          int dd=postsID.indexOf(myPostsID[myIndex]);
          postLikes[dd]--;
          colors[dd] = Colors.grey;
        }else{
          userPostsLikes[userIndex!]--;
          userPostsColors[userIndex]=Colors.grey;
          int dd=postsID.indexOf(userPostsID[userIndex]);
          postLikes[dd]--;
          colors[dd] = Colors.grey;
        }
        emit(SpiderDisLikePostSuccessState());
      }).catchError((error){
        emit(SpiderDisLikePostErrorState());
        printError("likePost", error.toString());
      });
    }).catchError((error) {
      emit(SpiderDisLikePostErrorState());
      printError("likePost", error.toString());
    });
  }

  List<LikeModel> likedBy=[];
  List<String> likedByID=[];
  void getLikes(String? postID){
    likedBy=[];
    likedByID=[];
    emit(SpiderGetLikesLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postID)
        .collection('likes')
        .get()
        .then((value){
      for (var element in value.docs) {
        likedByID.add(element.id);
        likedBy.add(LikeModel.fromJson(element.data()));
      }
      emit(SpiderGetLikesSuccessState());
    }).catchError((error){
      emit(SpiderGetLikesErrorState());
      printError("getLikes", error.toString());
    });
  }

  void updateLikeImage(String postID,{
    String? name,
    String? profileImage,
  }){
    LikeModel likeModel = LikeModel(
      like: true,
      name: name??userModel!.name,
      profileImage: profileImage??userModel!.profileImage,
    );
    emit(SpiderUpdateLikeImageLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(userModel!.uId)
        .update(likeModel.toJson())
        .then((value){
      emit(SpiderUpdateLikeImageSuccessState());
    }).catchError((error){
      emit(SpiderUpdateLikeImageErrorState());
      printError("updateLikeImage", error.toString());
    });
  }

  void addComment({
    @required String? comment,
    int? index,
    int? myIndex,
    int? userIndex,
    String? postID,
    String? myPostID,
    String? userPostID,
  }
      ){
    String id="";
    List<PostModel>? L;
    int i;
    if(index!=null) {
      currentID = postsID[index];
      i=index;
      id=postID!;
      L=posts;
    }else if(myIndex!=null){
      currentID=myPostsID[myIndex];
      i=myIndex;
      id=myPostID!;
      L=myPosts;
    }else{
      currentID=userPostsID[userIndex!];
      i=userIndex;
      id=userPostID!;
      L=userPosts;
    }
    CommentModel commentModel = CommentModel(
        userID: userModel!.uId,
        name: userModel!.name,
        profileImage: userModel!.profileImage,
        date: DateTime.now().toString(),
        comment: comment
    );
    emit(SpiderAddCommentLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(id)
        .collection('comments')
        .add(commentModel.toJson())
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(L![i].uId)
          .collection('MyPosts')
          .doc(id)
          .collection("comments")
          .doc(value.id)
          .set(commentModel.toJson())
          .then((value){
        if(index!=null){
          postComments[i]++;
          getComments(postID: id);
        }else if(myIndex!=null){
          myPostsComments[i]++;
          getComments(postID: id);
          int dd=postsID.indexOf(myPostsID[myIndex]);
          postComments[dd]++;
        }else{
          userPostsComments[i]++;
          getComments(postID: id);
          int dd=postsID.indexOf(userPostsID[userIndex!]);
          postComments[dd]++;
        }
        emit(SpiderAddCommentSuccessState());
      }).catchError((error){
        printError("addComment", error.toString());
        emit(SpiderAddCommentErrorState());
      });
    }).catchError((error){
      printError("addComment", error.toString());
      emit(SpiderAddCommentErrorState());
    });
  }

  List<CommentModel> comments=[];
  List<String> commentsID=[];
  void getComments({@required String? postID}){
    comments=[];
    commentsID=[];
    emit(SpiderGetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postID)
        .collection('comments')
        .orderBy('date')
        .get()
        .then((value){
      for(int i=value.docs.length-1;i>=0;i--){
        commentsID.add(value.docs[i].id);
        comments.add(CommentModel.fromJson(value.docs[i].data()));
      }
      emit(SpiderGetCommentsSuccessState());
    }).catchError((error){
      printError("getComments", error.toString());
      emit(SpiderGetCommentsErrorState());
    });
  }

  void deleteComment({
    int? index,
    int? myIndex,
    int? userIndex,
    String? postID,
    String? myPostID,
    String? userPostID,
    @required String? commentID
  }
      ){
    String id="";
    List<PostModel>? L;
    int i;
    if(index!=null) {
      currentID = postsID[index];
      i=index;
      id=postID!;
      L=posts;
    }else if(myIndex!=null){
      currentID=myPostsID[myIndex];
      i=myIndex;
      id=myPostID!;
      L=myPosts;
    }else{
      currentID=userPostsID[userIndex!];
      i=userIndex;
      id=userPostID!;
      L=userPosts;
    }
    emit(SpiderDeleteCommentLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(id)
        .collection('comments')
        .doc(commentID)
        .delete()
        .then((value) {
      //getComments(postID: postID);
      FirebaseFirestore.instance.collection('users')
          .doc(L![i].uId)
          .collection('MyPosts')
          .doc(id)
          .collection("comments")
          .doc(commentID)
          .delete()
          .then((value){
        if(index!=null){
          postComments[i]--;
          getComments(postID: id);
        }else if(myIndex!=null){
          myPostsComments[i]--;
          getComments(postID: id);
          int dd=postsID.indexOf(myPostsID[myIndex]);
          postComments[dd]--;
        }else{
          userPostsComments[i]--;
          getComments(postID: id);
          int dd=postsID.indexOf(userPostsID[userIndex!]);
          postComments[dd]--;
        }
        emit(SpiderDeleteCommentSuccessState());
      }).catchError((error){
        printError("deleteComment 111111", error.toString());
        emit(SpiderDeleteCommentErrorState());
      });
    }).catchError((error){
      printError("deleteComment", error.toString());
      emit(SpiderDeleteCommentErrorState());
    });
  }

  void updateCommentImage({
    @required String? postID,
    @required String? commentID,
    @required String? comment,
    @required String? date,
    String? name,
    String? profileImage,
  }){
    CommentModel commentModel = CommentModel(
      userID: userModel!.uId,
      name: name??userModel!.name,
      profileImage: profileImage??userModel!.profileImage,
      comment: comment,
      date: date,
    );
    emit(SpiderUpdateCommentImageLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postID)
        .collection('comments')
        .doc(commentID)
        .update(commentModel.toJson())
        .then((value){
      debugPrint("UPDATED");
      emit(SpiderUpdateCommentImageSuccessState());
    }).catchError((error){
      printError("updateCommentImage", error.toString());
      emit(SpiderUpdateCommentImageErrorState());
    });
  }

  //UPDATE PROFILE IMAGE AND NAME IN LIKES AND COMMENTS SCREEN//
  void updateLikesCommentsPicAndName({
    String? profileImage,
    String? name,
  }){
    emit(SpiderUpdateLikesCommentsPicAndNameLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .get()
        .then((value){
      for(int i=0;i<value.docs.length;i++){
        String id=value.docs[i].id;
        value.docs[i].reference.collection('likes')
            .get()
            .then((vLikes) {
          value.docs[i].reference.collection('comments')
              .get()
              .then((vComments){
            if(vLikes.docs.isNotEmpty) {
              for (var element in vLikes.docs) {
                if(element.id==userModel!.uId){
                  updateLikeImage(id,profileImage: profileImage,name: name);
                  break;
                }
              }
            }
            if(vComments.docs.isNotEmpty){
              for (var element in vComments.docs) {
                String commentID=element.id;
                if(element.data()['userID']==userModel!.uId){
                  String comment=element.data()['comment'];
                  String date=element.data()['date'];
                  updateCommentImage(
                    postID: id,
                    commentID: commentID,
                    comment: comment,
                    date: date,
                    profileImage: profileImage,
                    name: name,
                  );
                }
              }
            }
            emit(SpiderUpdateLikesCommentsPicAndNameSuccessState());
          }).catchError((error){
            printError("updateLikesCommentsPicAndName",error.toString());
            emit(SpiderUpdateLikesCommentsPicAndNameErrorState());
          });
        }).catchError((error){
          printError("updateLikesCommentsPicAndName",error.toString());
          emit(SpiderUpdateLikesCommentsPicAndNameErrorState());
        });
      }
    }).catchError((error){
      printError("updateLikesCommentsPicAndName",error.toString());
      emit(SpiderUpdateLikesCommentsPicAndNameErrorState());
    });
  }

List<UserModel> searchList=[];
  void searchAllUsers(String value){
    searchList=[];
    emit(SpiderSearchLoadingState());
    for (var element in allUsers) {
      String name = element.name!;
      if(name.startsWith(value)&&element.uId!=uId) {
        searchList.add(UserModel.fromJson(element.toJson()));
      }
    }
    emit(SpiderSearchSuccessState());
  }
  
  List<UserModel> allUsers=[];
  List<String> allUsersID=[];
  void getAllUsers(){
    if(allUsers.isEmpty) {
      emit(SpiderGetAllUsersLoadingState());
      FirebaseFirestore.instance.collection('users')
          .get()
          .then((value){
        for (var element in value.docs) {
          //if(element.id!=userModel!.uId) {
          allUsers.add(UserModel.fromJson(element.data()));
          allUsersID.add(element.id);
          //}
        }
        emit(SpiderGetAllUsersSuccessState());
      }).catchError((error){
        printError("getAllUsers", error.toString());
        emit(SpiderGetAllUsersErrorState());
      });
    }
  }

  void sendMessage({
    @required String? receiverID,
    @required String? fcmToken,
    String? text,
    String? image,
  }){
    MessageModel senderModel = MessageModel(
      date: DateTime.now().toString(),
      senderID: userModel!.uId,
      receiverID: receiverID,
      text: text??"",
      image: image??"",
      isRead: true,
    );
    MessageModel receiverModel = MessageModel(
      date: DateTime.now().toString(),
      senderID: userModel!.uId,
      receiverID: receiverID,
      text: text??"",
      image: image??"",
      isRead: false,
    );
    emit(SpiderSendMessageLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .add(senderModel.toJson())
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(receiverID)
          .collection('chats')
          .doc(userModel!.uId)
          .collection('messages')
          .add(receiverModel.toJson())
          .then((value){
        setLastMessage(message: text??"", receiverID: receiverID);
        if(userModel!.userToken!=""){
          SendNotification.sendFcm(
              "New Message",
              "${userModel!.name} sent you new message",
              fcmToken!,
              "1",
             senderID: "${userModel?.uId}",
             message:text??""
          );
        }
        debugPrint("MESSAGE SENT SUCCESSFULLY");
        emit(SpiderSendMessageSuccessState());
      }).catchError((error){
        printError("sendMessage", error.toString());
        emit(SpiderSendMessageErrorState());
      });
    }).catchError((error){
      printError("sendMessage", error.toString());
      emit(SpiderSendMessageErrorState());
    });
  }

  void setLastMessage({@required String? message,@required String? receiverID}){
    LastMessageModel senderLastMessage = LastMessageModel(
      lastMessage: message,
      senderID: userModel!.uId,
      date: DateTime.now().toString(),
      unReadMessages: false,
    );
    LastMessageModel receiverLastMessage = LastMessageModel(
      lastMessage: message,
      senderID: userModel!.uId,
      date: DateTime.now().toString(),
      unReadMessages: true,
    );
    emit(SpiderSetLastMessageLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .set(senderLastMessage.toJson())
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(receiverID)
          .collection('chats')
          .doc(userModel!.uId)
          .set(receiverLastMessage.toJson())
          .then((value){
        emit(SpiderSetLastMessageSuccessState());
      }).catchError((error){
        printError("setLastMessage", error.toString());
        emit(SpiderSetLastMessageErrorState());
      });
    }).catchError((error){
      printError("setLastMessage", error.toString());
      emit(SpiderSetLastMessageErrorState());
    });
  }

  List<MessageModel> messages=[];
  void getMessages({@required String? receiverID,@required LastMessageModel? lastMessage}){
    readMessages(receiverID: receiverID, last: lastMessage);
    emit(SpiderGetMessagesLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      messages=[];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SpiderGetMessagesSuccessState());
    });
  }

  List<LastMessageModel> lastMessages=[];
  List<String> lastMessagesID=[];
  List<bool> newMSGs=[];
  void getLastMessages(){
    emit(SpiderGetLastMessagesLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      lastMessages=[];
      lastMessagesID=[];
      newMSGs=[];
      for(int i=event.size-1;i>=0;i--){
        lastMessagesID.add(event.docs[i].id);
        lastMessages.add(LastMessageModel.fromJson(event.docs[i].data()));
        if(event.docs[i].data()['unReadMessages']==true){
          newMSGs.add(true);
        }
      }
      emit(SpiderGetLastMessagesSuccessState());
    });
  }

  void readMessages({@required String? receiverID,@required LastMessageModel? last}){
    LastMessageModel lastMessageModel = LastMessageModel(
      lastMessage: last!.lastMessage,
      senderID: last.senderID,
      date: last.date,
      unReadMessages: false,
    );
    emit(SpiderReadMessagesLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverID)
        .update(lastMessageModel.toJson())
        .then((value) {
      emit(SpiderReadMessagesSuccessState());
    }).catchError((error){
      printError("readMessages", error.toString());
      emit(SpiderReadMessagesErrorState());
    });
  }

  File? messageImage;
  void getMessageImage(context,String? receiverID,String? fcmToken)async{
    emit(SpiderGetMessageImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      messageImage = File(pickedFile.path);
      navigateTo(context: context, widget: SendImageScreen(
        messageImage: messageImage, receiverID: receiverID,fcmToken: fcmToken,)
      );
      emit(SpiderGetMessageImageSuccessState());
    }else{
      debugPrint("ERROR IN==========> getMessageImage");
      emit(SpiderGetMessageImageErrorState());
    }
  }

  void sendMessageImage(context,{
    @required String? receiverID,
    @required String? fcmToken,
  }){
    emit(SpiderSendMessageImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref("messages/${Uri.file(messageImage!.path).pathSegments.last}")
        .putFile(messageImage!)
        .then((p0){
      p0.ref.getDownloadURL().then((value){
        sendMessage(receiverID: receiverID,image: value,fcmToken: fcmToken);
        emit(SpiderSendMessageImageSuccessState());
      }).catchError((error){
        emit(SpiderSendMessageImageErrorState());
        printError("sendMessageImage", error.toString());
      });
    }).catchError((error){
      emit(SpiderSendMessageImageErrorState());
      printError("sendMessageImage", error.toString());
    });
  }

  void saveImage(String? url,context) async {
    emit(SpiderSaveImageImageLoadingState());
    var status=await Permission.storage.request();
    if(status.isGranted){
      var response = await Dio().get(
          url!,
          options: Options(responseType: ResponseType.bytes)
      ).then((value) async {
        int lst=url.indexOf('?');
        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(value.data),
            quality: 60,
            name: url.substring(lst-35,lst-4)
        );
        buildFlushBar(
          icon: IconBroken.Image,
          context: context,
          message: "imageDownloaded".tr,
          color: Colors.blue,
          duration: 3,
          position: FlushbarPosition.TOP,
          messageColor: Colors.white,
        );
        emit(SpiderSaveImageImageSuccessState());
      }).catchError((error){
        buildFlushBar(
          icon: IconBroken.Image,
          context: context,
          message: "can't download image",
          color: Colors.blue,
          duration: 3,
          position: FlushbarPosition.TOP,
          messageColor: Colors.white,
        );
        emit(SpiderSaveImageImageErrorState());
      });
    }
  }


  void sendFollowRequest({@required String? receiverID}){
    emit(SpiderSendFollowRequestLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyRequests')
        .doc(receiverID!)
        .set({'request':true})
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(receiverID)
          .collection('FollowRequests')
          .doc(userModel!.uId)
          .set({'request':true})
          .then((v){
        debugPrint("SENT REQUEST");
        getMyRequests();
        getFollowRequest();
        UserModel receiver=allUsers.firstWhere((element) => element.uId==receiverID);
        if(userModel!.userToken!=receiver.userToken){
          SendNotification.sendFcm(
            "Follow Request",
            "${userModel!.name} send you follow request",
            receiver.userToken!,
            "2",
          );
        }
        emit(SpiderSendFollowRequestSuccessState());
      }).catchError((error){
        printError("sendFollowRequest", error.toString());
        emit(SpiderSendFollowRequestErrorState());
      });
      // debugPrint("SENT REQUEST");
      // emit(SpiderSendFollowRequestSuccessState());
    }).catchError((error){
      printError("sendFollowRequest", error.toString());
      emit(SpiderSendFollowRequestErrorState());
    });
  }

  void deleteMyFollowRequest({@required String? receiverID}){
    emit(SpiderDeleteMyFollowRequestLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyRequests')
        .doc(receiverID!)
        .delete()
        .then((value){
      emit(SpiderDeleteMyFollowRequestSuccessState());
    }).catchError((error){
      printError("deleteFollowRequest", error.toString());
      emit(SpiderDeleteMyFollowRequestErrorState());
    });
    //////////////////////////////////////////////////////
    FirebaseFirestore.instance.collection('users')
        .doc(receiverID)
        .collection('FollowRequests')
        .doc(userModel!.uId)
        .delete()
        .then((value){
      getMyRequests();
      emit(SpiderDeleteMyFollowRequestSuccessState());
    }).catchError((error){
      printError("deleteFollowRequest", error.toString());
      emit(SpiderDeleteMyFollowRequestErrorState());
    });
  }

  List<String> myRequests=[];
  void getMyRequests(){
    emit(SpiderGetMyRequestsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('MyRequests')
        .get()
        .then((value){
      myRequests=[];
      for (var element in value.docs) {
        myRequests.add(element.id);
      }
      emit(SpiderGetMyRequestsSuccessState());
    }).catchError((error){
      printError("getMyRequests", error.toString());
      emit(SpiderGetMyRequestsErrorState());
    });
  }

  List<String> followRequests=[];
  void getFollowRequest(){
    emit(SpiderGetFollowRequestsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('FollowRequests')
        .snapshots()
        .listen((event) {
      followRequests=[];
      for (var element in event.docs) {
        followRequests.add(element.id);
      }
      emit(SpiderGetFollowRequestsSuccessState());
    });
  }

  void confirmFollowRequest({@required String? followerID}){
    emit(SpiderConfirmFollowRequestsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('followers')
        .doc(followerID!)
        .set({'follow':true})
        .then((value){
      emit(SpiderConfirmFollowRequestsSuccessState());
    }).catchError((error){
      printError("confirmFollowRequest", error.toString());
      emit(SpiderConfirmFollowRequestsErrorState());
    });
    //////////////////////////////////////////////////////////
    FirebaseFirestore.instance.collection('users')
        .doc(followerID)
        .collection('following')
        .doc(userModel!.uId)
        .set({'follow':true})
        .then((value){
      deleteFollowRequest(followerID: followerID);
      emit(SpiderConfirmFollowRequestsSuccessState());
    }).catchError((error){
      printError("confirmFollowRequest", error.toString());
      emit(SpiderConfirmFollowRequestsErrorState());
    });
  }

  void deleteFollowRequest({@required String? followerID}){
    emit(SpiderDeleteFollowRequestLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('FollowRequests')
        .doc(followerID!)
        .delete()
        .then((value){
      emit(SpiderDeleteFollowRequestSuccessState());
    }).catchError((error){
      printError("deleteFollowRequest", error.toString());
      emit(SpiderDeleteFollowRequestErrorState());
    });
    /////////////////////////////////////////////////////////
    FirebaseFirestore.instance.collection('users')
        .doc(followerID)
        .collection('MyRequests')
        .doc(userModel!.uId)
        .delete()
        .then((value){
      //getMyRequests();
      getFollowRequest();
      emit(SpiderDeleteFollowRequestSuccessState());
    }).catchError((error){
      printError("deleteFollowRequest", error.toString());
      emit(SpiderDeleteFollowRequestErrorState());
    });
  }

  List<String> following=[];
  List<String> userFollowing=[];
  void getFollowing({String? userID}){
    emit(SpiderGetFollowingLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userID??userModel!.uId)
        .collection('following')
        .get()
        .then((value){
      if(userID==null){
        following=[];
        for (var element in value.docs) {
          following.add(element.id);
        }
        emit(SpiderGetFollowingSuccessState());
      }else{
        userFollowing=[];
        for (var element in value.docs) {
          userFollowing.add(element.id);
        }
        emit(SpiderGetFollowingSuccessState());
      }
    }).catchError((error){
      printError("getFollowing", error.toString());
      emit(SpiderGetFollowingErrorState());
    });
  }

  List<String> followers=[];
  List<String> userFollowers=[];
  void getFollowers({String? userID}){
    emit(SpiderGetFollowersLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userID??userModel!.uId)
        .collection('followers')
        .get()
        .then((value){
      if(userID==null){
        followers=[];
        for (var element in value.docs) {
          followers.add(element.id);
        }
        emit(SpiderGetFollowersSuccessState());
      }else{
        userFollowers=[];
        for (var element in value.docs) {
          userFollowers.add(element.id);
        }
        emit(SpiderGetFollowersSuccessState());
      }
    }).catchError((error){
      printError("getFollowers", error.toString());
      emit(SpiderGetFollowersErrorState());
    });
  }

  void unFollow({@required String? followerID}){
    emit(SpiderUnFollowLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('following')
        .doc(followerID!)
        .delete()
        .then((value) {
      emit(SpiderUnFollowSuccessState());
    }).catchError((error){
      printError("unFollow", error.toString());
      emit(SpiderUnFollowErrorState());
    });
    ///////////////////////////////////////////////
    FirebaseFirestore.instance.collection('users')
        .doc(followerID)
        .collection('followers')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
      getFollowing();
      getFollowers(userID:followerID);
      emit(SpiderUnFollowSuccessState());
    }).catchError((error){
      printError("unFollow", error.toString());
      emit(SpiderUnFollowErrorState());
    });
  }

  List<String> chats=[];
  void getChats(){
    emit(SpiderGetChatsLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('chats')
    .orderBy('date')
    .snapshots()
    .listen((event) {
      chats=[];
      for (int i=event.size-1;i>=0;i--) {
        chats.add(event.docs[i].id);
      }
      emit(SpiderGetChatsSuccessState());
    });
    //     .get()
    //     .then((value){
    //   chats=[];
    //   for (var element in value.docs) {
    //     chats.add(element.id);
    //   }
    //   emit(SpiderGetChatsSuccessState());
    // }).catchError((error){
    //   printError("getChats", error.toString());
    //   emit(SpiderGetChatsErrorState());
    // });
  }

  void removeFollower({@required String? followerID}){
    emit(SpiderRemoveFollowerLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .collection('followers')
        .doc(followerID!)
        .delete()
        .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(followerID)
          .collection('following')
          .doc(userModel!.uId)
          .delete()
          .then((value){
        getFollowers();
        emit(SpiderRemoveFollowerSuccessState());
      }).catchError((error){
        printError("removeFollower", error.toString());
        emit(SpiderRemoveFollowerErrorState());
      });
    }).catchError((error){
      printError("removeFollower", error.toString());
      emit(SpiderRemoveFollowerErrorState());
    });
  }
}