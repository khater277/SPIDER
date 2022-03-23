import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/shared/constants.dart';

class BuildRequestItem extends StatelessWidget {
  final UserModel? userModel;
  const BuildRequestItem({Key? key,@required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildRequestInfo(userModel: userModel!),
          const Spacer(),
          Row(
            children: [
              BuildConfirmButton(userModel: userModel!),
              const SizedBox(width: 5,),
              BuildDeleteButton(userModel: userModel!),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildDeleteButton extends StatelessWidget {
  final UserModel userModel;
  const BuildDeleteButton({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){
        SpiderCubit.get(context).deleteFollowRequest(followerID: userModel.uId);
      },
      child: Text(
        "delete".tr,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
    );
  }
}

class BuildConfirmButton extends StatelessWidget {
  final UserModel userModel;
  const BuildConfirmButton({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){
        SpiderCubit.get(context).confirmFollowRequest(followerID: userModel.uId);
      },
      child:
      Text(
        "confirm".tr,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
    );
  }
}

class BuildRequestInfo extends StatelessWidget {
  final UserModel userModel;
  const BuildRequestInfo({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(userModel.uId==SpiderCubit.get(context).userModel!.uId){
          SpiderCubit.get(context).openMyProfile();
          navigateTo(context: context, widget: const HomeScreen());
        }else{
          SpiderCubit.get(context).getUserPosts(userID: userModel.uId);
          navigateTo(context: context, widget: UserProfileScreen(
              userModel:userModel
          ));
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(
                "${userModel.profileImage}"
            ),
          ),
          const SizedBox(width: 8,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${userModel.name}",
                style: const TextStyle(
                    fontSize: 15
                ),
                overflow: TextOverflow.ellipsis,),
              Text("${userModel.bio}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    height: 1.3
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}