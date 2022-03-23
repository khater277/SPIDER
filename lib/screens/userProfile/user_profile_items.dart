import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/comments/comment_screen.dart';
import 'package:spider/screens/feeds/feeds_items.dart';
import 'package:spider/screens/followers/followers_screen.dart';
import 'package:spider/screens/following/following_screen.dart';
import 'package:spider/screens/likes/likes_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/chats/messages_items.dart';
import 'package:spider/styles/icons_broken.dart';
import 'package:transparent_image/transparent_image.dart';


class BuildUserPostsList extends StatelessWidget {
  final UserModel userModel;
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildUserPostsList({Key? key, required this.cubit, required this.state, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context,index)=>BuildPostItem(
          index: index,
          cubit: cubit,
          state: state,
          userModel: userModel
      ),
      separatorBuilder: (context,index)=>const SizedBox(height: 8,),
      itemCount: cubit.userPosts.length,
    );
  }
}

class BuildUserProfileDetails extends StatelessWidget {
  final SpiderCubit cubit;
  final UserModel userModel;
  const BuildUserProfileDetails({Key? key, required this.cubit, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Text(
                  "${cubit.userPosts.length}",
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
                  style: Theme.of(context).textTheme.caption)
              ],
            ),
          ),
          InkWell(
            onTap: (){
              FocusScope.of(context).unfocus();
              navigateTo(context: context,
                  widget: FollowersScreen(isMine: false,followersModel: userModel,));
            },
            child: Column(
              children: [
                Text(
                  "${cubit.userFollowers.length}",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16
                  ),
                ),
                Text(
                  "followers".tr,
                  style:Theme.of(context).textTheme.caption
                )
              ],
            ),
          ),
          InkWell(
            onTap: (){
              FocusScope.of(context).unfocus();
              navigateTo(context: context,
                  widget: FollowingScreen(isMine: false,followingModel: userModel,));
            },
            child: Column(
              children: [
                Text(
                  "${cubit.userFollowing.length}",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16
                  ),
                ),
                Text(
                    "following".tr,
                    style: Theme.of(context).textTheme.caption
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildUserMessageButton extends StatelessWidget {
  final SpiderCubit cubit;
  final UserModel userModel;
  final TextEditingController messageController;
  const BuildUserMessageButton({Key? key, required this.cubit, required this.userModel,
    required this.messageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: OutlinedButton(
        onPressed: (){
          FocusScope.of(context).unfocus();
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 400,
                color: Colors.white,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              inputFormatters: [NoLeadingSpaceFormatter()],
                              cursorColor: Colors.blue.withOpacity(0.2),
                              controller: messageController,
                              decoration:  InputDecoration(
                                hintText: "messageHint".tr,
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    cubit.getMessageImage(context,userModel.uId,userModel.userToken);
                                  },
                                  icon: const Icon(IconBroken.Image,size: 24,),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.4),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.blue.withOpacity(0.3),
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: messageController,
                            builder: (context, value, child) {
                              return BuildSentButton(
                                value: value,
                                cubit: cubit,
                                messageController: messageController,
                                receiverID: userModel.uId,
                                fcmToken: userModel.userToken,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(IconBroken.Message),
            const SizedBox(width: 5,),
            Text(
              "message".tr,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildUserFollowButton extends StatelessWidget {
  final SpiderCubit cubit;
  final UserModel userModel;
  const BuildUserFollowButton({Key? key, required this.cubit, required this.userModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: (){
          FocusScope.of(context).unfocus();
          cubit.following.contains(userModel.uId)?
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("unfollow".tr),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(10.0))),
                content: Builder(
                  builder: (context) {
                    return SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: BuildUnfollowAlertDetails(
                          userModel: userModel,
                          cubit: cubit
                      ),
                    );
                  },
                ),
              )
          ) :
          cubit.myRequests.contains(userModel.uId)?
          cubit.deleteMyFollowRequest(receiverID: userModel.uId):
          cubit.sendFollowRequest(receiverID: userModel.uId);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cubit.userFollowers.contains(uId)?
            IconBroken.User
                :
            cubit.myRequests.contains(userModel.uId)?
            Icons.more_horiz:IconBroken.Add_User
            ),
            const SizedBox(width: 5,),
            Text(cubit.userFollowers.contains(uId)?
            "followingUser".tr
                :
            cubit.myRequests.contains(userModel.uId)?
            "requested".tr:"followUser".tr,
              style:const TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildUnfollowAlertDetails extends StatelessWidget {
  final UserModel userModel;
  final SpiderCubit cubit;
  const BuildUnfollowAlertDetails({Key? key, required this.userModel, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Text("${"unFollowDetails".tr} ${userModel.name}${languageFun(ar:'؟',en:'?')}",
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: (){
                      cubit.unFollow(followerID: userModel.uId);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "yes".tr,
                      style: const TextStyle(
                          fontSize: 17
                      ),
                    )
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel".tr,
                    style: const TextStyle(
                        fontSize: 17
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BuildUserBioName extends StatelessWidget {
  final UserModel userModel;
  const BuildUserBioName({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${userModel.name}",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20
          ),
        ),
        const SizedBox(height: 4,),
        Text(userModel.bio=="bio..."?"bio".tr:
          "${userModel.bio}",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class BuildUserCoverProfile extends StatelessWidget {
  final UserModel userModel;
  const BuildUserCoverProfile({Key? key, required this.userModel}) : super(key: key);

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
              child:
              CachedNetworkImage(
                imageUrl: "${userModel.coverImage}",
                placeholder: (context,url)=>const DefaultProgressIndicator(icon: IconBroken.Image),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child:  CircleAvatar(
              radius: 55,
              backgroundImage: CachedNetworkImageProvider(
                  userModel.profileImage.toString()
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
  final UserModel userModel;
  const BuildPostItem({Key? key, required this.index, required this.cubit, required this.state, required this.userModel}) : super(key: key);

  @override
  State<BuildPostItem> createState() => _BuildPostItemState();
}
class _BuildPostItemState extends State<BuildPostItem> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _commentController=TextEditingController();
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildUserPostDetails(cubit: widget.cubit, index: widget.index),
            const Padding(
                padding: EdgeInsets.symmetric( vertical: 5),
                child: DefaultDivider()),
            if (widget.cubit.userPosts[widget.index].text != "")
              BuildUserPostText(cubit: widget.cubit, index: widget.index),
            if (widget.cubit.userPosts[widget.index].postImage != "")
              BuildUserPostImage(cubit: widget.cubit, index: widget.index),
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 12, horizontal: 2),
              child: Row(
                children: [
                  BuildUserPostLikesNumber(
                      cubit: widget.cubit,
                      index: widget.index,
                      userModel: widget.userModel
                  ),
                  BuildUserPostCommentsNumber(cubit: widget.cubit, index: widget.index),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only( top: 10),
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
                        return IconButton(
                          onPressed: value.text.isNotEmpty ? () {
                            int endCnt=0;
                            if(value.text.endsWith(" ")){
                              for(int i=value.text.length-1;i>=0;i--){
                                if(value.text[i]==" "){
                                  endCnt++;
                                }else{
                                  break;
                                }
                              }
                            }
                            widget.cubit.addComment(
                                userIndex: widget.index,
                                userPostID: widget.cubit.userPostsID[widget.index],
                                comment: _commentController.text.substring(0,_commentController.text.length-endCnt)
                            );
                            setState(() {
                              _commentController.clear();
                              FocusScope.of(context).unfocus();
                            });
                          } : null,
                          icon: const Icon(IconBroken.Send,size: 24),
                        );
                      },
                    ),
                    focusBorder: Colors.grey.withOpacity(0.3),
                    border: Colors.grey.withOpacity(0.2),
                    onSubmitted: (value){
                      setState(() {
                        _commentController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 5,),
                BuildUserPostLikeButton(
                    cubit: widget.cubit,
                    index: widget.index,
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

class BuildUserPostLikeButton extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  final SpiderStates state;

  const BuildUserPostLikeButton({Key? key, required this.cubit, required this.index, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if(cubit.userPostsColors[index]==Colors.grey){
          cubit.likePost(userIndex: index,userPostID: cubit.userPostsID[index]);
        }else{
          cubit.dislikePost(userIndex: index,userPostID: cubit.userPostsID[index]);
        }
      },
      child: Row(
        children: [
          (state is SpiderLikePostLoadingState || state is SpiderDisLikePostLoadingState)
              &&cubit.currentID==cubit.userPostsID[index]
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
            color: cubit.userPostsColors[index],
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

class BuildUserPostCommentsNumber extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildUserPostCommentsNumber({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          cubit.getComments(postID: cubit.userPostsID[index]);
          navigateTo(
              context: context,
              widget: CommentsScreen(userPostIndex: index,postID: cubit.userPostsID[index],));
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
              "${cubit.userPostsComments[index]} ${"comment".tr}",
              // "${cubit.userPostsComments[index]} comment",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildUserPostLikesNumber extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  final UserModel userModel;
  const BuildUserPostLikesNumber({Key? key, required this.cubit, required this.index, required this.userModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          cubit.getLikes(cubit.userPostsID[index]);
          navigateTo(
              context: context,
              widget: LikesScreen(
                likesPostID: cubit.userPostsID[index],
                fromUserProfile: true,
                userID: userModel.uId,
              ));
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
              "${cubit.userPostsLikes[index]} ${"likes".tr}",
              // "${cubit.userPostsLikes[index]} Like",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildUserPostImage extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildUserPostImage({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: DefaultProgressIndicator(icon: IconBroken.Image)
                ),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "${cubit.userPosts[index].postImage}",
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

class BuildUserPostText extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildUserPostText({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 6,bottom: 3,left: 3,right: 3
      ),
      child: Text(
        "${cubit.userPosts[index].text}",
        style: const TextStyle(height: 1.3, fontSize: 14),
      ),
    );
  }
}

class BuildUserPostDetails extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const BuildUserPostDetails({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
              radius: 26,
              backgroundImage: CachedNetworkImageProvider(
                  "${cubit.userPosts[index].profileImage}"
                //"${cubit.userPosts[index].profileImage}"
              )),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${cubit.userPosts[index].name}",
                    //"${cubit.userPosts[index].name}",
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
                "${dateFormat(cubit.userPosts[index].dateTime)!['date']}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(height: 1.6,),
              )
            ],
          ),
        ],
      ),
    );
  }
}