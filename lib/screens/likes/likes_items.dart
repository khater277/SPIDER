import 'package:flutter/material.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/styles/icons_broken.dart';

class BuildLikeItem extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  final String likesPostID;
  const BuildLikeItem({Key? key, required this.cubit, required this.index, required this.likesPostID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        UserModel userModel = cubit.allUsers.firstWhere((element) => element.uId==cubit.likedByID[index]);
        if(userModel.uId==cubit.userModel!.uId) {
          cubit.openMyProfile();
          navigateTo(context: context, widget: const HomeScreen());
        }else {
          cubit.getUserPosts(userID: userModel.uId);
          navigateTo(context: context, widget: UserProfileScreen(
            userModel:userModel,
            likesPostID: likesPostID,
          ));
        }
      },
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  "${cubit.likedBy[index].profileImage}",
                ),
              ),
              CircleAvatar(
                  radius: 11.5,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child:const Icon(
                    IconBroken.Heart,
                    color: Colors.red,
                    size: 20,
                  )
              ),
            ],
          ),
          const SizedBox(width: 15,),
          Text("${cubit.likedBy[index].name}",style: const TextStyle(
            fontSize: 15,
          ),)
        ],
      ),
    );
  }
}