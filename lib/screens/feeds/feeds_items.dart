import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/comments/comment_screen.dart';
import 'package:spider/screens/likes/likes_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/styles/icons_broken.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../shared/constants.dart';
import '../../shared/default_widgets.dart';

class BuildLikeButton extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  final SpiderStates state;

  const BuildLikeButton({Key? key, required this.cubit, required this.index,
    required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if(cubit.colors[index]==Colors.grey){
          cubit.likePost(index: index,postID: cubit.postsID[index]);
        }else{
          cubit.dislikePost(index: index,postID: cubit.postsID[index]);
        }
      },
      child: Row(
        children: [
          (state is SpiderLikePostLoadingState || state is SpiderDisLikePostLoadingState)
              &&cubit.currentID==cubit.postsID[index]
              ?
          SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.red.shade500,
              )
          ):
          Icon(
            IconBroken.Heart,
            color: cubit.colors[index],
            size: 20,
          ),
        const SizedBox(width: 5,),
          Text(
            "like".tr,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}

class BuildAddComment extends StatefulWidget {
  final TextEditingValue value;
  final SpiderCubit cubit;
  final int index;
  final TextEditingController commentController;
  const BuildAddComment({Key? key, required this.value, required this.cubit,
    required this.index, required this.commentController}) : super(key: key);

  @override
  State<BuildAddComment> createState() => _BuildAddCommentState();
}
class _BuildAddCommentState extends State<BuildAddComment> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.value.text.isNotEmpty ? () {
        int endCnt=0;
        if(widget.value.text.endsWith(" ")){
          for(int i=widget.value.text.length-1;i>=0;i--){
            if(widget.value.text[i]==" "){
              endCnt++;
            }else{
              break;
            }
          }
        }
        widget.cubit.addComment(
            index: widget.index,
            postID: widget.cubit.postsID[widget.index],
            comment: widget.commentController.text.substring(0,widget.commentController.text.length-endCnt)
        );
        setState(() {widget.commentController.clear();});
      } : null,
      icon: const Icon(IconBroken.Send,size: 24),
    );
  }
}

class BuildMyProfileImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildMyProfileImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundImage: CachedNetworkImageProvider(
          '${cubit.userModel!.profileImage}'
      ),
    );
  }
}

class BuildCommentsNumber extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;

  const BuildCommentsNumber({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          cubit.getComments(postID: cubit.postsID[index]);
          navigateTo(context: context,
              widget: CommentsScreen(postIndex: index,
                postID: cubit.postsID[index],));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              IconBroken.Chat,
              color: Colors.amberAccent,
              size: 20,
            ),
            const SizedBox(width: 4,),
            Text(
              "${cubit.postComments[index]} ${"comment".tr}",
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}

class BuildLikesNumber extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildLikesNumber({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          cubit.getLikes(cubit.postsID[index]);
          navigateTo(context: context,
              widget: LikesScreen(likesPostID: cubit.postsID[index],));
        },
        child: Row(
          children: [
            const Icon(
              IconBroken.Heart,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 5,),
            Text(
              "${cubit.postLikes[index]} ${"likes".tr}",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPostImage extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;

  const BuildPostImage({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child:Stack(
              children: [
                const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: DefaultProgressIndicator(icon: IconBroken.Image)
                ),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "${cubit.posts[index].postImage}",
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context,s,d)=>
                        const ErrorImage(width: double.infinity, height: 250),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}

class BuildPostText extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildPostText({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 6,bottom: 3,right: 3,left: 3),
      child: SelectableText(
        "${cubit.posts[index].text}",
        style: const TextStyle(
            height: 1.3,
            fontSize: 14
        ),
      ),
    );
  }
}

class BuildPostOwnerInfo extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  final UserModel userModel;
  const BuildPostOwnerInfo({Key? key, required this.cubit,
    required this.index, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap:(){
              if(userModel.uId==cubit.userModel!.uId){
                cubit.openMyProfile();
              }
              else {
                cubit.getUserPosts(userID: userModel.uId);
                navigateTo(context: context, widget: UserProfileScreen(
                    userModel:userModel
                ));
              }
            },
            child: CircleAvatar(
                radius: 26,
                backgroundImage: CachedNetworkImageProvider(
                    "${cubit.posts[index].profileImage}"
                  //"${cubit.posts[index].profileImage}"
                )
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      if(userModel.uId==cubit.userModel!.uId){
                        cubit.openMyProfile();
                      }else {
                        cubit.getUserPosts(userID: userModel.uId);
                        navigateTo(context: context, widget: UserProfileScreen(
                            userModel:userModel
                        ));
                      }
                    },
                    child: Text(
                      "${cubit.posts[index].name}",
                      //"${cubit.posts[index].name}",
                      style: const TextStyle(
                          height: 1.4,
                          fontSize: 15
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 13
                  )
                ],
              ),
              Text(
                //"23 نوفمبر 1:52 ص",
                "${dateFormat(cubit.posts[index].dateTime)!['date']}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(height:1.6,),
              )
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey[700],
                size: 20,
              )
          )
        ],
      ),
    );
  }
}