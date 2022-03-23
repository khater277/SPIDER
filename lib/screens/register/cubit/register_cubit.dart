import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/network/local/cache_helper.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/register/cubit/register_state.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context)=>BlocProvider.of(context);

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
    emit(RegisterChangeIconState());
  }

  void userRegister(context,
  {
    @required String? email,
    @required String? password,
    @required String? name,
    @required String? phone,
  }){
    emit(UserRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!
    ).then((value)async{
      String? userToken = await FirebaseMessaging.instance.getToken();
      createUser(
          userToken: userToken,
          name: name,
          email: email,
          phone: phone,
          uID: value.user!.uid
      );
      uId=value.user!.uid;
      CacheHelper.saveData(key: 'uID', value: value.user!.uid);
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
      emit(UserRegisterSuccessState());
    }).catchError((error){
      toastBuilder(msg: "invalidPassword".tr, color: Colors.grey[700]);
      emit(UserRegisterErrorState());
    });
  }

  void createUser({
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
      emit(CreateUserSuccessState());
    }).catchError((error){
      printError("create user", error.toString());
      emit(CreateUserErrorState());
    });
  }
}