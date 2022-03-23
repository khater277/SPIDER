import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';

import '../../shared/constants.dart';

class BuildFollowersItem extends StatelessWidget {
  final UserModel? userModel;
  final int? index;
  final bool? isMine;
  final UserModel? followersModel;
  const BuildFollowersItem({Key? key,@required this.userModel,@required this.index,@required this.isMine, this.followersModel}) : super(key: key);

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
                followersUserModel: followersModel,
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
              const SizedBox(width: 10,),
              Text("${userModel!.name}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
            onPressed: (){
              isMine==true?
              SpiderCubit.get(context).removeFollower(followerID: userModel!.uId)
                  :userModel!.uId!=uId?
              SpiderCubit.get(context).following.contains(SpiderCubit.get(context).userFollowers[index!])?
              SpiderCubit.get(context).unFollow(followerID: userModel!.uId)
                  :SpiderCubit.get(context).myRequests.contains(SpiderCubit.get(context).userFollowers[index!])?
              SpiderCubit.get(context).deleteMyFollowRequest(receiverID: userModel!.uId)
                  :SpiderCubit.get(context).sendFollowRequest(receiverID: userModel!.uId)
                  :null;
            },
            child: Text(
              isMine==true?
              "remove".tr :
              userModel!.uId!=uId?
              SpiderCubit.get(context).following.contains(SpiderCubit.get(context).userFollowers[index!])?
              "unfollow".tr:
              SpiderCubit.get(context).myRequests.contains(SpiderCubit.get(context).userFollowers[index!])?
              "requested".tr.toLowerCase()
                  : "followUser".tr.toUpperCase()
                  :"",
              style: const TextStyle(
                  fontSize: 14
              ),
            )
        )
      ],
    );
  }
}
