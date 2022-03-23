import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/followers/followers_items.dart';
import 'package:spider/styles/icons_broken.dart';

class FollowersScreen extends StatelessWidget {
  final bool? isMine;
  final UserModel? followersModel;
  const FollowersScreen({Key? key, @required this.isMine, this.followersModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){},
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit = SpiderCubit.get(context);
        return WillPopScope(
          onWillPop: ()async{
            if(isMine==false) {
              cubit.getUserPosts(userID: followersModel!.uId);
            } else {
              cubit.getMyPosts();
            }
            return true;
          },
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Text("followers".tr,style: const TextStyle(
                    fontSize: 20
                ),),
                leading: IconButton(
                    onPressed: (){
                      if(isMine==false) {
                        cubit.getUserPosts(userID: followersModel!.uId);
                      } else {
                        cubit.getMyPosts();
                      }
                      Navigator.pop(context);
                    },
                    icon: const BackIcon(size: 22)
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(IconBroken.User,size: 22,),
                  ),
                ],
              ),
              body:state is! SpiderGetUserPostsLoadingState
                  &&state is! SpiderGetFollowingLoadingState
                  &&state is! SpiderGetFollowersLoadingState
                  ?
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>BuildFollowersItem(
                        userModel:cubit.allUsers[cubit.allUsersID.indexOf(
                            isMine==true?cubit.followers[index]:cubit.userFollowers[index]
                        )],
                        index: index,
                        isMine: isMine,
                        followersModel: followersModel,
                      ),
                      separatorBuilder:(context,index)=> const SizedBox(height: 10,),
                      itemCount: isMine==true?cubit.followers.length:cubit.userFollowers.length
                  )
              ):const DefaultProgressIndicator(icon: IconBroken.User),
            ),
        );
      },
    );
  }
}
