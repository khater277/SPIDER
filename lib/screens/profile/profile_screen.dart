import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

import 'profile_items.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}



class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SpiderCubit.get(context).popHome(context);
        return true;
      },
      child:Builder(
        builder: (context){
          SpiderCubit.get(context).getFollowRequest();
          SpiderCubit.get(context).getLastMessages();
          return BlocConsumer<SpiderCubit,SpiderStates>(
            listener: (context,state){
              if(state is SpiderAddCommentSuccessState){
                toastBuilder(msg: "commentSubmitted".tr, color: Colors.grey[800]);
              }
              if(state is SpiderDeleteCommentSuccessState){
                toastBuilder(msg: "commentDeleted".tr, color: Colors.grey[800]);
              }
            },
            builder: (context,state){
              SpiderCubit cubit=SpiderCubit.get(context);
              return state is! SpiderGetMyPostsLoadingState
                  &&state is! SpiderGetPostsLoadingState
                  &&state is! SpiderGetFollowingLoadingState
                  &&state is! SpiderGetFollowersLoadingState
                  &&state is! SpiderNavBarState
                  &&state is! SpiderDeletePostLoadingState
                  &&state is! SpiderDeletePostSuccessState?
              Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      BuildProfileCoverImage(cubit: cubit,),
                      BuildNameBio(cubit: cubit,),
                      const SizedBox(height: 15,),
                      BuildProfileDetails( cubit: cubit),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                        child: Row(
                          children: const [
                            BuildAddPhotoButton(),
                            SizedBox(width: 5,),
                            BuildEditProfileButton(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      BuildMyPostsList(cubit: cubit, state: state)
                    ],
                  ),
                ),
              )
                  :const DefaultProgressIndicator(icon: IconBroken.Document);
            },
          );
        },
      ),
    );
  }
}