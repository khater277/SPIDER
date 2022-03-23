import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/comments/comments_items.dart';
import 'package:spider/styles/icons_broken.dart';

//ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  static const String screenRoute="comments_screen";
  int? postIndex;
  int? myPostIndex;
  int? userPostIndex;
  final String? postID;
  CommentsScreen({Key? key, this.postIndex,this.myPostIndex,this.userPostIndex, this.postID,}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final TextEditingController _commentController=TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){},
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit = SpiderCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('comments'.tr,
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            titleSpacing: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {Navigator.pop(context);},
                icon:const BackIcon(size: 22)
            ),
          ),
          body:state is! SpiderGetCommentsLoadingState?
          OfflineWidget(
              onlineWidget:(state is! SpiderGetCommentsLoadingState
                  //&&state is! SpiderGetCommentsSuccessState
                  &&state is! SpiderAddCommentLoadingState
                  &&state is! SpiderDeleteCommentLoadingState
                  &&state is! SpiderAddCommentSuccessState
                  &&state is! SpiderDeleteCommentSuccessState
              )
                  ?
              Column(
                children: [
                  Expanded(
                      child: cubit.comments.isNotEmpty?
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context,index)=>Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: BuildCommentItem(
                                  cubit: cubit,
                                  index: index,
                                  postIndex: widget.postIndex,
                                  myPostIndex: widget.myPostIndex,
                                  userPostIndex: widget.userPostIndex,
                                ),
                              ),
                            ],
                          ),
                          separatorBuilder: (context,index)=>const DefaultSeparator(),
                          itemCount:cubit.postComments[cubit.postsID.indexOf(widget.postID!)]
                      ):NoItemsFounded(
                          text:"noComments".tr,
                          icon:IconBroken.Chat
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DefaultTextFiled(
                        controller: _commentController,
                        hint: "commentHint".tr,
                        hintSize: 12,
                        height: 5,
                        suffix: AddCommentButton(
                          cubit: cubit,
                          commentController: _commentController,
                          postIndex: widget.postIndex,
                          myPostIndex: widget.myPostIndex,
                          userPostIndex: widget.userPostIndex,
                        ),
                        focusBorder: Colors.blue.withOpacity(0.4),
                        border: Colors.grey.withOpacity(0.6)
                    ),
                  ),
                ],
              )
                  :
              const DefaultProgressIndicator(icon: IconBroken.Chat)
          ):const DefaultProgressIndicator(icon: IconBroken.Chat),
        );
      },
    );
  }
}
