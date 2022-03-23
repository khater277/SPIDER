import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/screens/comments/comment_screen.dart';
import 'package:spider/screens/edit_profile/edit_profile.dart';
import 'package:spider/screens/feeds/feeds_items.dart';
import 'package:spider/screens/followers/followers_screen.dart';
import 'package:spider/screens/following/following_screen.dart';
import 'package:spider/screens/likes/likes_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';
import 'package:transparent_image/transparent_image.dart';

class BuildMyPostsList extends StatelessWidget {
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildMyPostsList({Key? key, required this.cubit,
    required this.state,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index)=>BuildPostItem(cubit: cubit, state: state, index: index),
      separatorBuilder: (context,index)=>const SizedBox(height: 8,),
      itemCount: cubit.myPosts.length,
    );
  }
}

class BuildEditProfileButton extends StatelessWidget {
  const BuildEditProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, EditProfileScreen.screenRoute);
      },
      child: const Icon(
        IconBroken.Edit,
        size: 22,
      ),
    );
  }
}

class BuildAddPhotoButton extends StatelessWidget {
  const BuildAddPhotoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: (){
          FocusScope.of(context).unfocus();
        },
        child: Text(
          "profileAddPic".tr,
          style: const TextStyle(
              color: Colors.blue,
              fontSize: 14
          ),
        ),
      ),
    );
  }
}

class BuildProfileDetails extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildProfileDetails({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Text(
                "${cubit.myPosts.length}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16
                ),
              ),
              Text(
                "posts".tr,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){FocusScope.of(context).unfocus();},
          child: Column(
            children: [
              Text(
                "0",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16
                ),
              ),
              Text(
                "photos".tr,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            FocusScope.of(context).unfocus();
            navigateTo(context: context, widget: const FollowersScreen(isMine: true,));
          },
          child: Column(
            children: [
              Text(
                "${cubit.followers.length}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16
                ),
              ),
              Text(
                "followers".tr,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            navigateTo(context: context, widget: const FollowingScreen(isMine: true,));
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Text(
                "${cubit.following.length}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16
                ),
              ),
              Text(
                "following".tr,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildNameBio extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildNameBio({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${cubit.userModel!.name}",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20
          ),
        ),
        const SizedBox(height: 4,),
        Text(
          cubit.userModel!.bio=="bio..."?"bio".tr:
          "${cubit.userModel!.bio}",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class BuildProfileCoverImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildProfileCoverImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              child:DefaultFadedImage(
                  imgUrl: "${cubit.userModel!.coverImage}",
                  height: 150,
                  width: double.infinity
              )
            ),
          ),
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child:  CircleAvatar(
              radius:55,
              backgroundImage: CachedNetworkImageProvider(
                  cubit.userModel!.profileImage.toString()
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BuildPostItem extends StatefulWidget {
  final int index;
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildPostItem({Key? key, required this.cubit, required this.state, required this.index}) : super(key: key);

  @override
  State<BuildPostItem> createState() => _BuildPostItemState();
}
class _BuildPostItemState extends State<BuildPostItem> {
  final TextEditingController _commentController=TextEditingController();
  final List<String> _list = ["delete"];
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildMyPostInfo(
                index: widget.index,
                cubit: widget.cubit,
                list: _list
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: DefaultDivider()
            ),
            if (widget.cubit.myPosts[widget.index].text != "")
              BuildMyPostText(
                  index: widget.index,
                  cubit: widget.cubit,
              ),
            if (widget.cubit.myPosts[widget.index].postImage != "")
              BuildMyPostImage(
                  index: widget.index,
                  cubit: widget.cubit,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 2),
              child: Row(
                children: [
                  BuildMyPostLikesNumber(
                      index: widget.index,
                      cubit: widget.cubit,
                  ),
                  BuildMyPostCommentsNumber(
                      index: widget.index,
                      cubit: widget.cubit,
                  ),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: DefaultDivider()),
            Row(
              children: [
                BuildMyProfileImage(cubit: widget.cubit),
                const SizedBox(width: 10,),
                Expanded(
                  child: DefaultTextFiled(
                      controller: _commentController,
                      hint: "commentHint".tr,
                      hintSize: 12,
                      height: 5,
                      suffix:  ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _commentController,
                        builder: (context, value, child) {
                          return BuildMyPostAddComment(
                              index: widget.index,
                              cubit: widget.cubit,
                              commentController: _commentController,
                              value: value,
                          );
                        },
                      ),
                      focusBorder: Colors.blue.withOpacity(0.3),
                      border: Colors.grey.withOpacity(0.2)
                  ),
                ),
                const SizedBox(width: 5,),
                BuildMyPostLikeButton(
                    index: widget.index,
                    cubit: widget.cubit,
                    state: widget.state
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuildMyPostLikeButton extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildMyPostLikeButton({Key? key, required this.index, required this.cubit,
    required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if(cubit.myPostsColors[index]==Colors.grey){
          cubit.likePost(myIndex: index,myPostID: cubit.myPostsID[index]);
        }else{
          cubit.dislikePost(myIndex: index,myPostID: cubit.myPostsID[index]);
        }
      },
      child: Row(
        children: [
          (state is SpiderLikePostLoadingState || state is SpiderDisLikePostLoadingState)
              &&cubit.currentID==cubit.myPostsID[index]
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
            color: cubit.myPostsColors[index],
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

class BuildMyPostAddComment extends StatefulWidget {
  final int index;
  final SpiderCubit cubit;
  final TextEditingController  commentController;
  final TextEditingValue value;
  const BuildMyPostAddComment({Key? key, required this.index, required this.cubit,
    required this.commentController, required this.value}) : super(key: key);

  @override
  State<BuildMyPostAddComment> createState() => _BuildMyPostAddCommentState();
}
class _BuildMyPostAddCommentState extends State<BuildMyPostAddComment> {
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
            myIndex: widget.index,
            myPostID: widget.cubit.myPostsID[widget.index],
            comment: widget.commentController.text.substring(0,widget.commentController.text.length-endCnt)
        );
        setState(() {
          widget.commentController.text="";
          //FocusScope.of(context).unfocus();
        });
      } : null,
      icon: const Icon(IconBroken.Send,size: 24),
    );
  }
}

class BuildMyPostCommentsNumber extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  const BuildMyPostCommentsNumber({Key? key, required this.index, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          //print(cubit.postsID.indexOf(cubit.myPostsID[index]));
          FocusScope.of(context).unfocus();
          cubit.getComments(postID: cubit.myPostsID[index]);
          navigateTo(context: context,widget: CommentsScreen(
            myPostIndex: index,
            postID: cubit.myPostsID[index],
            //postIndex: cubit.postsID.indexOf(cubit.myPostsID[index]),
          ));
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
              "${cubit.myPostsComments[index]} ${"comment".tr}",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildMyPostLikesNumber extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  const BuildMyPostLikesNumber({Key? key, required this.index, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          navigateTo(context: context, widget: LikesScreen(likesPostID: cubit.myPostsID[index],));
          cubit.getLikes(cubit.myPostsID[index]);
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
              "${cubit.myPostsLikes[index]} ${"likes".tr}",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildMyPostImage extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  const BuildMyPostImage({Key? key, required this.index, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child:
            Stack(
              children: <Widget>[
                const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: DefaultProgressIndicator(icon: IconBroken.Image)
                ),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "${cubit.myPosts[index].postImage}",
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

class BuildMyPostText extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  const BuildMyPostText({Key? key, required this.index, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,bottom: 3,right: 3,left: 3),
      child: Text(
        "${cubit.myPosts[index].text}",
        style: const TextStyle(height: 1.3, fontSize: 14),
      ),
    );
  }
}

class BuildMyPostInfo extends StatelessWidget {
  final int index;
  final SpiderCubit cubit;
  final List<String> list;
  const BuildMyPostInfo({Key? key, required this.index, required this.cubit,required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
              radius: 26,
              backgroundImage: CachedNetworkImageProvider(
                  "${cubit.myPosts[index].profileImage}"
                //"${cubit.myPosts[index].profileImage}"
              )),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${cubit.myPosts[index].name}",
                    //"${cubit.myPosts[index].name}",
                    style: const TextStyle(height: 1.4,fontSize: 15),
                  ),
                  const SizedBox(width: 5,),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 13,
                  )
                ],
              ),
              Text(
                //"15 Oct 2021 at 9:32 AM",
                "${dateFormat(cubit.myPosts[index].dateTime)!['date']}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(
                    height: 1.6,
                    ),
              )
            ],
          ),
          const Spacer(),
          PopupMenuButton(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 10,
              enabled: true,
              onSelected: (value) {
                cubit.deletePost(index: index);
              },
              itemBuilder:(context) {
                return list.map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Row(
                      children: [
                        Text("delete".tr,style: TextStyle(color: Colors.red.withOpacity(0.8)),),
                        const SizedBox(width: 2,),
                        Icon(IconBroken.Delete,color: Colors.red.withOpacity(0.7),)
                      ],
                    ),
                  );
                }).toList();
              }
          )
        ],
      ),
    );
  }
}