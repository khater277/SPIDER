import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import '../../shared/constants.dart';
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
              "followUser".tr.toLowerCase()
                  :"",
              style: const TextStyle(fontSize: 14),
            )
        )
      ],
    );
  }
}