import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/chats/chat_items.dart';
import 'package:spider/styles/icons_broken.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Builder(
            builder: (context){
              SpiderCubit.get(context).getLastMessages();
              SpiderCubit.get(context).getFollowRequest();
              SpiderCubit.get(context).getChats();
              SpiderCubit.get(context).getLastMessages();
              return BlocConsumer<SpiderCubit,SpiderStates>(
                listener: (context,state){},
                builder: (context,state){
                  // clickNotification(context);
                  // receiveNotification(context);
                  SpiderCubit cubit =SpiderCubit.get(context);
                  return Scaffold(
                    body: state is! SpiderGetLastMessagesLoadingState &&
                        state is! SpiderGetChatsLoadingState?(
                        cubit.chats.isNotEmpty?
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index)=> BuildChatItem(cubit: cubit, index: index,
                              userModel: cubit.allUsers[cubit.allUsersID.indexOf(cubit.chats[index])],),
                            itemCount: cubit.chats.length,
                            separatorBuilder: (context,index)=>const DefaultSeparator(),

                          ),
                        ):NoItemsFounded(
                            text:"noChats".tr,
                            icon:IconBroken.Message
                        )
                    ) :
                    const DefaultProgressIndicator(icon: IconBroken.Message),
                  );
                },
              );
            }),
        onWillPop: ()async{
          SpiderCubit.get(context).popHome(context);
          return true;
        }
    );
  }
}

