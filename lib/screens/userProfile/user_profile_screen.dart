import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

import 'user_profile_items.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final UserModel? followingUserModel;
  final UserModel? followersUserModel;
  final String? likesPostID;
  const UserProfileScreen({
    Key? key, required this.userModel, this.followingUserModel, this.followersUserModel,
    this.likesPostID}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){
        if(state is SpiderSendMessageSuccessState){
          Navigator.pop(context);
          toastBuilder(msg: "messageSent".tr, color: Colors.grey.shade800);
        }
      },
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit = SpiderCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            if(widget.followingUserModel!=null) {
              cubit.getUserPosts(userID: widget.followingUserModel!.uId);
            }else if(widget.followersUserModel!=null){
              cubit.getUserPosts(userID: widget.followersUserModel!.uId);
            }else if(widget.likesPostID!=null){
              cubit.getLikes(widget.likesPostID);
            }
            Navigator.pop(context);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("${widget.userModel!.name}",style: const TextStyle(
                  fontSize: 20
              ),),
              leading: IconButton(
                onPressed: (){
                  if(widget.followingUserModel!=null) {
                    cubit.getUserPosts(userID: widget.followingUserModel!.uId);
                  }else if(widget.followersUserModel!=null){
                    cubit.getUserPosts(userID: widget.followersUserModel!.uId);
                  }else if(widget.likesPostID!=null){
                    cubit.getLikes(widget.likesPostID);
                  }
                  Navigator.pop(context);
                },
                icon: const BackIcon(size: 22),
              ),
            ),
            body: state is! SpiderGetUserPostsLoadingState
                &&state is! SpiderGetFollowingLoadingState
                &&state is! SpiderGetFollowersLoadingState
            //&&state is! SpiderGetUserPostsSuccessState
            //&&state is! SpiderGetFollowingSuccessState
                ?
            Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    BuildUserCoverProfile(userModel: widget.userModel!),
                    BuildUserBioName(userModel: widget.userModel!),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildUserFollowButton(cubit: cubit, userModel: widget.userModel!,),
                        const SizedBox(width: 5,),
                        BuildUserMessageButton(cubit: cubit,userModel: widget.userModel!,messageController: _messageController
                        ),
                      ],
                    ),
                    BuildUserProfileDetails(
                        cubit: cubit,
                        userModel: widget.userModel!
                    ),
                    BuildUserPostsList(
                        cubit: cubit,
                        state: state,
                        userModel: widget.userModel!
                    )
                  ],
                ),
              ),
            )
                :
            const DefaultProgressIndicator(icon: IconBroken.Profile),
          ),
        );
      },
    );
  }
}

