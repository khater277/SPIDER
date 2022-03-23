import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/post/post_items.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class PostScreen extends StatefulWidget {
  static const String screenRoute="post_screen";
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postController=TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){
        if(state is SpiderCreatePostSuccessState || state is SpiderSetPostImageSuccessState){
          SpiderCubit.get(context).currentIndex=0;
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenRoute, (route) => false);
          _postController.text="";
          SpiderCubit.get(context).postImage=null;
          buildFlushBar(
            icon: IconBroken.Document,
              color: Colors.blue,
              message: "postUploaded".tr,
              messageColor: Colors.white,
              duration: 3,
              context: context,
              position: FlushbarPosition.TOP
          );
        }
      },
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit = SpiderCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:  Text(
              "postAppBar".tr,
              style: const TextStyle(
                  fontSize: 20
              ),),
            titleSpacing: 0,
            leading: const BackButton(),
            actions: [
              BuildPostButton(
                  cubit: cubit,
                  postController: _postController
              )
            ],
          ),
          body: Builder(builder: (context) {
            return OfflineWidget(
                onlineWidget: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (state is SpiderCreatePostLoadingState || state is SpiderSetPostImageLoadingState)
                          const DefaultLinerIndicator(),
                        BuildCreatePostNameAndProfilePic(cubit: cubit),
                        TextFormField(
                          controller: _postController,
                          minLines: 1,
                          maxLines: 7,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "createPostHint".tr,
                              hintStyle: const TextStyle(
                                  fontSize: 15
                              )),
                        ),
                        if (cubit.postImage != null)
                          BuildCreatePostImage(cubit: cubit),
                        Row(
                          children: [
                            BuildAddPhotoButton(cubit: cubit),
                            const BuildTagsButton(),
                          ],
                        )
                      ],
                    ),
                  ),
                )
            );
          }),
        );
      },
    );
  }
}
