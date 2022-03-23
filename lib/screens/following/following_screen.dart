import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class FollowingScreen extends StatelessWidget {
  static const String screenRoute="following_screen";
  final bool? isMine;
  final UserModel? followingModel;
  const FollowingScreen({Key? key, this.isMine, this.followingModel}) : super(key: key);

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
              cubit.getUserPosts(userID: followingModel!.uId);
            } else {
              cubit.getMyPosts();
            }
            return true;
          },
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Text("following".tr,style: const TextStyle(
                    fontSize: 20
                ),),
                leading: IconButton(
                    onPressed: (){
                      if(isMine==false) {
                        cubit.getUserPosts(userID: followingModel!.uId);
                      } else {
                        cubit.getMyPosts();
                      }
                      Navigator.pop(context);
                    },
                    icon:  const BackIcon(size: 22)
                ),
                actions:  const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(IconBroken.User,size: 22),
                  ),
                ],
              ),
              body: state is! SpiderGetUserPostsLoadingState
                  &&state is! SpiderGetFollowingLoadingState
                  &&state is! SpiderGetFollowersLoadingState
                  ?
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>BuildFollowingItem(
                        userModel:cubit.allUsers[cubit.allUsersID.indexOf(
                            isMine==true?cubit.following[index]:cubit.userFollowing[index]
                        )],
                        index: index,
                        isMine: isMine,
                        followingModel: followingModel,
                      ),
                      separatorBuilder:(context,index)=> const SizedBox(height: 10,),
                      itemCount: isMine==true?cubit.following.length:cubit.userFollowing.length
                  )
              ):const DefaultProgressIndicator(icon: IconBroken.User),
            ),
        );
      },
    );
  }
}

class BuildFollowingItem extends StatelessWidget {
  final UserModel? userModel;
  final int? index;
  final bool? isMine;
  final UserModel? followingModel;
  const BuildFollowingItem({Key? key,@required this.userModel,@required this.index,@required this.isMine, this.followingModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: (){
            if(userModel!.uId==SpiderCubit.get(context).userModel!.uId){
              SpiderCubit.get(context).openMyProfile();
              navigateTo(context: context, widget: const HomeScreen());
            }else{
              SpiderCubit.get(context).getUserPosts(userID: userModel!.uId);
              navigateTo(context: context, widget: UserProfileScreen(
                userModel:userModel,
                followingUserModel: followingModel,
              ));
            }
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  "${userModel!.profileImage}",
                ),
              ),
              const SizedBox(width: 15,),
              Text("${userModel!.name}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15
                ),),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
            onPressed: (){
              userModel!.uId!=uId?
              SpiderCubit.get(context).following.contains(
                  isMine==true?
                  userModel!.uId
                      :SpiderCubit.get(context).userFollowing[index!]
              )?
              SpiderCubit.get(context).unFollow(followerID: userModel!.uId)
                  :
              SpiderCubit.get(context).myRequests.contains(
                  isMine==true?
                  userModel!.uId
                      :SpiderCubit.get(context).userFollowing[index!]
              )?SpiderCubit.get(context).deleteMyFollowRequest(receiverID: userModel!.uId)
                  :SpiderCubit.get(context).sendFollowRequest(receiverID: userModel!.uId)
                  :null;
            },
            child: Text(
              userModel!.uId!=uId?
              SpiderCubit.get(context).following.contains(
                  isMine==true?
                  userModel!.uId
                      :SpiderCubit.get(context).userFollowing[index!]
              )?
              "unfollow".tr
                  :
              SpiderCubit.get(context).myRequests.contains(
                  isMine==true?
                  userModel!.uId
                      :SpiderCubit.get(context).userFollowing[index!]
              )?"requested".tr.toLowerCase():
              "followUser".tr.toUpperCase()
                  :"",
              style: const TextStyle(fontSize: 14),
            )
        )
      ],
    );
  }
}

