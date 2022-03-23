import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/last_message_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/chats/messages_screen.dart';
import 'package:spider/styles/icons_broken.dart';
import '../../shared/constants.dart';

class BuildChatItem extends StatelessWidget {
  final SpiderCubit cubit;
  final UserModel? userModel;
  final int index;
  const BuildChatItem({Key? key, required this.cubit, required this.index, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    ///last message
    LastMessageModel lastMessage = cubit.lastMessages[cubit.lastMessagesID
        .indexOf(cubit.allUsers[cubit.allUsersID.indexOf(cubit.chats[index])].uId!)];

    ///chat user
    UserModel chatUser = cubit.allUsers[cubit.allUsersID.indexOf(cubit.chats[index])];

    ///user index in chats
    int userIndex = cubit.lastMessagesID.indexOf(chatUser.uId!);

    return InkWell(
      onTap: () async {
        navigateTo(context: context, widget: MessagesScreen(
          userModel: chatUser,
          lastMessage: lastMessage,
        ));
        scrollDown();
        print(chatUser.name);
        print(lastMessage.lastMessage);
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ChatUserImage(chatUser: chatUser),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatNameDate(index: index, userModel: userModel!, cubit: cubit),
                        if(lastMessage.unReadMessages==true)
                          const SizedBox(height: 2,),
                        if(cubit.lastMessagesID.contains(chatUser.uId))
                          Row(
                            children: [
                              ///if i was the receiver
                              (lastMessage.senderID!=cubit.userModel!.uId)?
                              Row(
                                children: [
                                  ChatUserName(
                                      chatUser: chatUser,
                                      userIndex: userIndex,
                                      context: context,
                                      cubit: cubit
                                  ),
                                  ///if last message is text not image
                                  cubit.lastMessages[userIndex].lastMessage!=""?
                                  Row(
                                    children: [
                                      ChatUserLastMessage(
                                          userIndex: userIndex,
                                          cubit: cubit
                                      ),
                                      ///if last message is unread
                                      if(cubit.lastMessages[userIndex].unReadMessages==true)
                                        const UnReadLastMessage()
                                    ],
                                  )
                                  ///if last message is image
                                      :ChatUserImageMessage(
                                      userIndex: userIndex,
                                      context: context,
                                      cubit: cubit
                                  ),
                                ],
                              ):
                              cubit.lastMessages[userIndex].lastMessage!=""?
                              MyLastMessage(
                                  userIndex: userIndex,
                                  cubit: cubit,

                              ):
                              const MyLastMessageImage(),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnReadLastMessage extends StatelessWidget {
  const UnReadLastMessage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: const [
          Icon(IconBroken.Message,
            color: Colors.blue,
            size: 22,),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUserLastMessage extends StatelessWidget {

  final int userIndex;
  final SpiderCubit cubit;

  const ChatUserLastMessage({Key? key, required this.userIndex,  required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool unRead = cubit.lastMessages[userIndex].unReadMessages!;
    double width = 0.0;
    if (unRead) {
      width = MediaQuery.of(context).size.width - 172;
    } else {
      width = MediaQuery.of(context).size.width - 145;
    }
    return SizedBox(
      width: width,
      child: Text("${cubit.lastMessages[userIndex].lastMessage}",
        style:cubit.lastMessages[userIndex].unReadMessages==false?
        Theme.of(context).textTheme.caption?.copyWith(
            overflow: TextOverflow.ellipsis,
            fontSize: 11.5
        )
            :
        const TextStyle(
            color: Colors.blue,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis
        ),
      ),
    );
  }
}

class MyLastMessageImage extends StatelessWidget {
  const MyLastMessageImage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5,left: 2),
      child: Row(
        children: [
          const Icon(
            IconBroken.Image,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 3,),
          Text("image",style: Theme.of(context).textTheme.caption!.copyWith(
              fontSize: 11.5
          ),),
        ],
      ),
    );
  }
}

class MyLastMessage extends StatelessWidget {

  final int userIndex;
  final SpiderCubit cubit;

  const MyLastMessage({Key? key, required this.userIndex,  required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-120,
      child: Text("${cubit.lastMessages[userIndex].lastMessage}",
        style: Theme.of(context).textTheme.caption!.copyWith(
            overflow: TextOverflow.ellipsis,
            fontSize: 11.5
        ),
      ),
    );
  }
}

class ChatUserImageMessage extends StatelessWidget {

  final int userIndex;
  final BuildContext context;
  final SpiderCubit cubit;

  const ChatUserImageMessage({Key? key, required this.userIndex,
    required this.context, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          IconBroken.Image,
          color:cubit.lastMessages[userIndex].unReadMessages==false?Colors.grey
              :Colors.blue,
          size: 20,
        ),
        const SizedBox(width: 3,),
        Text("image",style: cubit.lastMessages[userIndex].unReadMessages==false?
        Theme.of(context).textTheme.caption!.copyWith(
          fontSize: 11.5,
        )
            :
        const TextStyle(
            color: Colors.blue,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis
        ),),
      ],
    );
  }
}

class ChatUserName extends StatelessWidget {

  final UserModel chatUser;
  final int userIndex;
  final BuildContext context;
  final SpiderCubit cubit;

  const ChatUserName({Key? key, required this.chatUser, required this.userIndex, required this.context,
     required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        chatUser.name!.contains(" ")?
        "${chatUser.name!.substring(0,chatUser.name!.indexOf(" "))} : "
            :"${chatUser.name} : ",
        style:cubit.lastMessages[userIndex].unReadMessages==false?
        Theme.of(context).textTheme.caption!.copyWith(
            overflow: TextOverflow.ellipsis,
            fontSize: 11.5+1
        )
            : const TextStyle(
            color: Colors.blue,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis
        )
    );
  }
}

class ChatNameDate extends StatelessWidget {

  final int index;
  final UserModel userModel;
  final SpiderCubit cubit;

  const ChatNameDate({Key? key,
    required this.index, required this.userModel, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${userModel.name}",
          style: const TextStyle(height: 1.4,fontSize: 15),
        ),
        const Spacer(),
        Text(
          //"asd",
            lastMessageDate(cubit, index),
           //dateFormat("${cubit.lastMessages[index].date}")!['date']!,
            style:Theme.of(context).textTheme.caption
        ),
      ],
    );
  }
}

class ChatUserImage extends StatelessWidget {

  final UserModel chatUser;

  const ChatUserImage({Key? key,  required this.chatUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(
          "${chatUser.profileImage}",
        ));
  }
}