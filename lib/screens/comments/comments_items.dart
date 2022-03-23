import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/styles/icons_broken.dart';
import '../../shared/constants.dart';


class BuildCommentItem extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  int? postIndex;
  int? myPostIndex;
  int? userPostIndex;
  BuildCommentItem({Key? key,required this.cubit, required this.index,this.postIndex,
    this.myPostIndex, this.userPostIndex,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        if(cubit.comments[index].userID==cubit.userModel!.uId)
          DeleteComment(
            cubit: cubit,
            index: index,
            postIndex: postIndex,
            myPostIndex: myPostIndex,
            userPostIndex: userPostIndex,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ProfileImage(cubit: cubit, index: index),
                      const SizedBox(
                        width: 10,
                      ),
                      CommentNameDate(cubit: cubit, index: index),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            CommentText(cubit: cubit, index: index)
          ],
        ),
      ],
    );
  }
}

class AddCommentButton extends StatefulWidget {
  final SpiderCubit cubit;
  final TextEditingController commentController;
   int? postIndex;
   int? myPostIndex;
   int? userPostIndex;
   AddCommentButton({Key? key, required this.cubit,
    required this.commentController, this.postIndex,
    this.myPostIndex, this.userPostIndex}) : super(key: key);

  @override
  State<AddCommentButton> createState() => _AddCommentButtonState();
}
class _AddCommentButtonState extends State<AddCommentButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.commentController,
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
            widget.postIndex!=null?
            widget.cubit.addComment(
                index: widget.postIndex,
                postID: widget.cubit.postsID[widget.postIndex!],
                comment: widget.commentController.text.substring(0,widget.commentController.text.length-endCnt)
            ) :widget.myPostIndex!=null?
            widget.cubit.addComment(
                myIndex: widget.myPostIndex,
                myPostID: widget.cubit.myPostsID[widget.myPostIndex!],
                comment: widget.commentController.text.substring(0,widget.commentController.text.length-endCnt)
            ):widget.cubit.addComment(
                userIndex: widget.userPostIndex,
                userPostID: widget.cubit.userPostsID[widget.userPostIndex!],
                comment: widget.commentController.text.substring(0,widget.commentController.text.length-endCnt)
            );
            setState(() {
              FocusScope.of(context).unfocus();
              widget.commentController.clear();
            });
          } : null,
          icon: const Icon(IconBroken.Send,size: 24),
        );
      },
    );
  }
}

class CommentText extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const CommentText({Key? key, required this.cubit, required this.index, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: HexColor('#f5f5f5'),
        elevation: 0,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: SelectableText(
            "${cubit.comments[index].comment}",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class CommentNameDate extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const CommentNameDate({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${cubit.comments[index].name}",
          style: const TextStyle(
              fontSize: 15
          ),
        ),
        Text(
          "${dateFormat(cubit.comments[index].date)!['date']}",
          style: Theme.of(context).textTheme.caption!.copyWith(
              height: 1.6,
          ),
        )
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  const ProfileImage({Key? key, required this.cubit, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment:  const Alignment(0,-0.08),
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: Colors.grey.withOpacity(0.5),
        ),
        CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              "${cubit.comments[index].profileImage}",
            )),
      ],
    );
  }
}

class DeleteComment extends StatelessWidget {
  final SpiderCubit cubit;
  final int index;
  int? postIndex;
  int? myPostIndex;
  int? userPostIndex;
  DeleteComment({Key? key, required this.cubit, required this.index,
   this.postIndex, this.myPostIndex, this.userPostIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          postIndex!=null?
          cubit.deleteComment(
            index: postIndex,
            postID: cubit.postsID[postIndex!],
            commentID: cubit.commentsID[index],
          ):myPostIndex!=null?
          cubit.deleteComment(
            myIndex: myPostIndex,
            myPostID: cubit.myPostsID[myPostIndex!],
            commentID: cubit.commentsID[index],
          ):cubit.deleteComment(
            userIndex: userPostIndex,
            userPostID: cubit.userPostsID[userPostIndex!],
            commentID: cubit.commentsID[index],
          );
        },
        icon: Icon(
          IconBroken.Delete,
          color: Colors.red.withOpacity(0.5),
          size: 22,
        ));
  }
}