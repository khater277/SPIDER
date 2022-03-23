import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/last_message_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/userProfile/user_profile_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/chats/messages_items.dart';
import 'package:spider/styles/icons_broken.dart';

//ignore: must_be_immutable
class MessagesScreen extends StatefulWidget {
  static const String screenRoute = "messages_screen";
  UserModel? userModel;
  LastMessageModel? lastMessage;
  bool? fromNotification;
  MessagesScreen({Key? key, this.userModel,this.lastMessage,this.fromNotification}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {

  final TextEditingController _messageController=TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context){
          SpiderCubit.get(context).getMessages(receiverID: widget.userModel!.uId,lastMessage: widget.lastMessage);
          return BlocConsumer<SpiderCubit,SpiderStates>(
            listener: (context,state){},
            builder: (context,state){
              clickNotification(context);
              receiveNotification(context);
              SpiderCubit cubit = SpiderCubit.get(context);
              return WillPopScope(
                onWillPop: () async {
                  SpiderCubit.get(context).getLastMessages();
                  int index = SpiderCubit.get(context).lastMessagesID.indexOf(widget.userModel!.uId!);
                  LastMessageModel last = SpiderCubit.get(context).lastMessages[index];
                  SpiderCubit.get(context).readMessages(receiverID: widget.userModel!.uId, last: last);
                  navigateAndFinish(context: context, widget: const HomeScreen());
                  return true;
                },
                child: Scaffold(
                  appBar: AppBar(
                      titleSpacing: 0,
                      title: InkWell(
                        onTap: (){
                          if(widget.userModel!.uId==cubit.userModel!.uId){
                            cubit.openMyProfile();
                            navigateAndFinish(context: context, widget: const HomeScreen());
                          }else{
                            cubit.getUserPosts(userID: widget.userModel!.uId);
                            navigateTo(context: context, widget: UserProfileScreen(
                                userModel:widget.userModel
                            ));
                          }
                        },
                        child: Row(
                          children:  [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                "${widget.userModel!.profileImage}",
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              "${widget.userModel!.name}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: IconButton(
                        icon: const BackIcon(size: 22),
                        onPressed: (){
                          cubit.getLastMessages();
                          int index = cubit.lastMessagesID.indexOf(widget.userModel!.uId!);
                          LastMessageModel last = cubit.lastMessages[index];
                          cubit.readMessages(receiverID: widget.userModel!.uId, last: last);
                          navigateAndFinish(context: context, widget: const HomeScreen());
                        },
                      )
                  ),
                  body:
                  state is! SpiderGetMessagesLoadingState?
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              controller: scrollController,
                              itemBuilder: (context,index)
                              =>cubit.userModel!.uId==cubit.messages[index].senderID?
                              BuildMyMessage(
                                message: cubit.messages[index].text,
                                image:cubit.messages[index].image,
                                messageModel: cubit.messages[index],
                              )
                                  :BuildFriendMessage(
                                message: cubit.messages[index].text,
                                image:cubit.messages[index].image,
                                userModel: widget.userModel,
                                messageModel: cubit.messages[index],
                              ),
                              separatorBuilder: (context,index)=>const SizedBox(height: 10,),
                              itemCount: cubit.messages.length
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                                child:DefaultTextFiled(
                                    controller: _messageController,
                                    hint: "messageHint".tr,
                                    hintSize: 14,
                                    height: 10,
                                    suffix: IconButton(
                                      onPressed: (){
                                        cubit.getMessageImage(context,widget.userModel!.uId,widget.userModel!.userToken);
                                      },
                                      icon: const Icon(IconBroken.Image,
                                        size: 24,
                                      ),
                                    ),
                                    focusBorder: Colors.blue.withOpacity(0.3),
                                    border: Colors.grey.withOpacity(0.4)
                                )
                            ),
                            const SizedBox(width: 5,),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _messageController,
                              builder: (context, value, child) {
                                return BuildSentButton(
                                  value: value,
                                  cubit: cubit,
                                  messageController: _messageController,
                                  receiverID: widget.userModel!.uId,
                                  fcmToken: widget.userModel!.userToken,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                      :const DefaultProgressIndicator(icon: IconBroken.Message),
                ),
              );
            },
          );
        });
  }
}