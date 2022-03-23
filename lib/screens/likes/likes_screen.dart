import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

import 'likes_items.dart';

class LikesScreen extends StatelessWidget {
  static const String screenRoute="likes_screen";
  final String? likesPostID;
  final bool? fromUserProfile;
  final String? userID;
  const LikesScreen({Key? key, this.likesPostID, this.fromUserProfile, this.userID}) : super(key: key);

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
              if(fromUserProfile==true){
                cubit.getUserPosts(userID: userID);
              }
              return true;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text('likes'.tr,
                    style: const TextStyle(
                        fontSize: 20
                    ),),
                  titleSpacing: 0,
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () {
                        if(fromUserProfile==true){
                          cubit.getUserPosts(userID: userID);
                        }
                        Navigator.pop(context);
                      },
                      icon: const BackIcon(size: 22)
                  ),
                ),
                body:state is! SpiderGetLikesLoadingState?
                OfflineWidget(
                    onlineWidget:state is! SpiderGetLikesLoadingState?
                    cubit.likedBy.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder:(context,index)=>BuildLikeItem(
                            cubit: cubit,
                            index: index,
                            likesPostID: likesPostID!
                        ),
                        separatorBuilder: (BuildContext context, int index)=>const DefaultSeparator(),
                        itemCount: cubit.likedBy.length,
                      ),
                    ):
                    NoItemsFounded(
                        text: "noLikes".tr,
                        icon: IconBroken.Heart
                    ):const DefaultProgressIndicator(icon:IconBroken.Heart)
                ):const DefaultProgressIndicator(icon: IconBroken.Heart)
            ),
        );
      },
    );
  }
}
