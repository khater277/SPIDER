import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/network/local/cache_helper.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/login/cubit/login_states.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  bool visible=true;
  IconData icon=Icons.visibility;
  void changeIcon(){
    if(visible==false) {
      icon=Icons.visibility;
    }
    if(visible==true) {
      icon=Icons.visibility_off;
    }
    visible=!visible;
    emit(LoginChangeIconState());
  }

  void userLogin(context,{
  @required String? email,
    @required String? password,
}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!
    ).then((value)async {
        uId=value.user!.uid;
        CacheHelper.saveData(key: 'uID', value: value.user!.uid);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenRoute, (route) => false);
        SpiderCubit.get(context).login();
        SpiderCubit.get(context).getUserData();
        SpiderCubit.get(context).getPosts();
        SpiderCubit.get(context).getAllUsers();
        emit(LoginSuccessState());
    }).catchError((error){
      printError("userLogin", error.toString());
      int index=error.toString().indexOf(']');
      toastBuilder(msg: error.toString().substring(index+2,error.toString().length), color: Colors.grey[700]);
      emit(LoginErrorState());
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }


  void googleSignIn(BuildContext context)async{
    emit(GoogleSignInLoadingState());
    await signInWithGoogle().then((value)async{
      var user = value.user;
      String name = formatName(user!.displayName!);
      String? userToken = await FirebaseMessaging.instance.getToken();
      if(SpiderCubit.get(context).allUsersID.contains(user.uid)){
        uId=value.user!.uid;
        CacheHelper.saveData(key: 'uID', value: value.user!.uid);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenRoute, (route) => false);
        SpiderCubit.get(context).login();
        SpiderCubit.get(context).getUserData();
        SpiderCubit.get(context).getPosts();
        SpiderCubit.get(context).getAllUsers();
        emit(LoginSuccessState());
      }else{
        createUser(context,
          uID: user.uid,
          name: name,
          profileImage: user.photoURL,
          email: user.email,
          phone: user.phoneNumber,
          userToken:userToken,
        );
      }
    }).catchError((error){
      emit(GoogleSignInErrorState());
      printError("googleSignIn", error.toString());
    });
  }

  void facebookSignIn(BuildContext context)async{
    emit(FacebookSignInLoadingState());
    await signInWithFacebook().then((value)async{
      var user = value.user;
      String name = formatName(user!.displayName!);
      String? userToken = await FirebaseMessaging.instance.getToken();
      if(SpiderCubit.get(context).allUsersID.contains(user.uid)){
        uId=value.user!.uid;
        CacheHelper.saveData(key: 'uID', value: value.user!.uid);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenRoute, (route) => false);
        SpiderCubit.get(context).login();
        SpiderCubit.get(context).getUserData();
        SpiderCubit.get(context).getPosts();
        SpiderCubit.get(context).getAllUsers();
        emit(LoginSuccessState());
      }else{
        createUser(context,
          uID: user.uid,
          name: name,
          profileImage: user.photoURL,
          email: user.email,
          phone: user.phoneNumber,
          userToken:userToken,
        );
      }
    }).catchError((error){
      emit(FacebookSignInErrorState());
      printError("facebookSignIn", error.toString());
    });
  }

  void createUser(BuildContext context,{
    @required String? userToken,
    @required String? name,
    @required String? email,
    @required String? phone,
    @required String? uID,
    String? profileImage,
  }) {
    UserModel userModel = UserModel(
        userToken: userToken,
        name: name,
        email: email,
        phone: phone??"",
        uId: uID,
        profileImage:profileImage??"https://i.pinimg.com/564x/d9/c3/cf/d9c3cf6c263d181be4b5cbd15038b3a6.jpg",
        bio: "bio...",
        coverImage: "https://blogs.travelportalsolution.com/wp-content/uploads/2019/12/default_cover.jpg"
    );
    emit(CreateUserErrorState());
    FirebaseFirestore.instance.collection('users')
        .doc(uID)
        .set(userModel.toJson()).then((value){
      uId=uID;
      CacheHelper.saveData(key: 'uID', value: uID);
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenRoute, (route) => false);
      SpiderCubit.get(context).posts = [];
      SpiderCubit.get(context).postLikes = [];
      SpiderCubit.get(context).postComments = [];
      SpiderCubit.get(context).postsID = [];
      SpiderCubit.get(context).likesID = [];
      SpiderCubit.get(context).colors = [];
      SpiderCubit.get(context).allUsers = [];
      SpiderCubit.get(context).getUserData();
      SpiderCubit.get(context).getPosts();
      SpiderCubit.get(context).getAllUsers();
      emit(CreateUserSuccessState());
    }).catchError((error){
      printError("create user", error.toString());
      emit(CreateUserErrorState());
    });
  }
}