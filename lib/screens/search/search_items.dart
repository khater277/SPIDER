import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/styles/icons_broken.dart';

class BuildUsersList extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildUsersList({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListView.separated(
          itemBuilder: (context,index)=>BuildSearchItem(
            cubit: cubit,
            index: index,
          ),
          separatorBuilder: (context,index)=>const SizedBox(height: 10,),
          itemCount: cubit.searchList.length
      ),
    );
  }
}

class BuildSearchItem extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildSearchItem({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        UserModel userModel = cubit.allUsers.firstWhere((element) =>
        element.uId==cubit.searchList[index].uId);
        cubit.getUserPosts(userID: userModel.uId);
        navigateTo(
            context: context,
            widget: UserProfileScreen(
                userModel: userModel
            )
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(
              "${cubit.searchList[index].profileImage}",
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${cubit.searchList[index].name}",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                cubit.myRequests.contains(cubit.searchList[index].uId)?"requested".tr.toLowerCase()
                    :cubit.following.contains(cubit.searchList[index].uId)?"followingUser".tr.toLowerCase():"",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotMatchingItem extends StatelessWidget {

  const NotMatchingItem({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconBroken.Close_Square,size: 200,
              color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 10,),
          Text("noSearch".tr,style: TextStyle(
              fontSize: 25,
              color: Colors.grey.withOpacity(0.5)
          ),)
        ],
      ),
    );
  }
}

class SearchNowItem extends StatelessWidget {
  const SearchNowItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconBroken.Search,size: 200,
              color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 10,),
          Text("canSearch".tr,style: TextStyle(
              fontSize: 25,
              color: Colors.grey.withOpacity(0.5)
          ),)
        ],
      ),
    );
  }
}