import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/feeds/feeds_items.dart';
import 'package:spider/styles/icons_broken.dart';


class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context){
          SpiderCubit.get(context).getFollowRequest();
          SpiderCubit.get(context).getLastMessages();
          return BlocConsumer<SpiderCubit, SpiderStates>(
            listener: (context, state) {
              if(state is SpiderAddCommentSuccessState){
                toastBuilder(msg: 'commentSubmitted'.tr, color: Colors.grey[800]);
              }
              if(state is SpiderDeleteCommentSuccessState){
                toastBuilder(msg: "commentDeleted".tr, color: Colors.grey[800]);
              }
            },
            builder: (context, state) {
              clickNotification(context);
              receiveNotification(context);
              SpiderCubit cubit = SpiderCubit.get(context);
              return
                (cubit.posts.isNotEmpty&&state is! SpiderGetPostsLoadingState
                    &&state is! SpiderGetUserDataLoadingState)?
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(width: 10,),
                      const BuildPinnedImage(),
                      const SizedBox(width: 10,),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)=>BuildPostItem(
                            context: context, index: index, cubit: cubit, state: state),
                        separatorBuilder: (context,index)=>const SizedBox(width: 10,),
                        itemCount: cubit.posts.length,
                      ),
                    ],
                  ),
                )
                    :const DefaultProgressIndicator(icon: IconBroken.Home);
            },
          );
        });
  }
}


class BuildPinnedImage extends StatelessWidget {
  const BuildPinnedImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Card(
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CachedNetworkImage(
              matchTextDirection: true,
              imageUrl:"https://img.freepik.com/free-photo/indoor-shot-attractive-curly-haired-woman-points-upper-right-corner-demonstrates-nice-advertisement-blank-space-wears-neat-yellow-jumper_273609-39332.jpg?size=626&ext=jpg",
              width: double.infinity,
              height:250,
              fit: BoxFit.cover,
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "pinnedPic".tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800,
                fontSize: 15
            ),
          ),
        ),
      ],
    );
  }
}


/////////////////////////////////////////////
class BuildPostItem extends StatefulWidget {
  final BuildContext? context;
  final int? index;
  final SpiderCubit? cubit;
  final state;
  const BuildPostItem({Key? key,@required this.context,
    @required this.index,@required this.cubit,@required this.state}) : super(key: key);

  @override
  State<BuildPostItem> createState() => _BuildPostItemState();
}

class _BuildPostItemState extends State<BuildPostItem> {
  TextEditingController commentController=TextEditingController();
  UserModel? userModel;
  @override
  void initState() {
    userModel = widget.cubit!.allUsers.firstWhere((element) =>
    element.uId==widget.cubit!.posts[widget.index!].uId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildPostOwnerInfo(
                cubit: widget.cubit!,
                index: widget.index!,
                userModel: userModel!),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: DefaultDivider(),
            ),
            if (widget.cubit!.posts[widget.index!].text != "")
              BuildPostText(
                  cubit: widget.cubit!,
                  index: widget.index!,
                  ),
            if (widget.cubit!.posts[widget.index!].postImage != "")
              BuildPostImage(
                cubit: widget.cubit!,
                index: widget.index!,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 2),
              child: Row(
                children: [
                  BuildLikesNumber(
                    cubit: widget.cubit!,
                    index: widget.index!,
                  ),
                  BuildCommentsNumber(
                      cubit: widget.cubit!,
                      index: widget.index!,
                  ),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: DefaultDivider()),
            Row(
              children: [
                BuildMyProfileImage(cubit: widget.cubit!),
                const SizedBox(width: 10,),
                Expanded(
                  child: DefaultTextFiled(
                    controller: commentController,
                    hint: "commentHint".tr,
                    hintSize: 12,
                    height: 5,
                    suffix: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: commentController,
                      builder: (context, value, child) {
                        return BuildAddComment(
                            value: value,
                            cubit: widget.cubit!,
                            index: widget.index!,
                            commentController: commentController
                        );
                      },
                    ),
                    focusBorder: Colors.blue.withOpacity(0.3),
                    border: Colors.grey.withOpacity(0.2),
                    onSubmitted: (value){
                      setState(() {
                        commentController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 5,),
                BuildLikeButton(
                  cubit: widget.cubit!,
                  index: widget.index!,
                  state: widget.state,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}