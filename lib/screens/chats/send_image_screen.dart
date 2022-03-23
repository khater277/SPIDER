import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class SendImageScreen extends StatelessWidget {
  static const String screenRoute="send_image_screen";
  final String? receiverID;
  final String? fcmToken;
  final File? messageImage;
  const SendImageScreen({Key? key,@required this.messageImage,@required this.receiverID,@required this.fcmToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){
        if(state is SpiderSendMessageImageSuccessState){
          Navigator.pop(context);
          buildFlushBar(
            icon: IconBroken.Image,
              color: Colors.blue,
              message: "sendImageDone".tr,
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
            titleSpacing: 0,
            title: Text(
              "sendImage".tr,
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            leading: IconButton(
              icon: const BackIcon(size: 22),
              onPressed: (){Navigator.pop(context);},
            ),
            actions: [
              IconButton(
                icon:  const Icon(IconBroken.Send,color: Colors.blue,size: 22),
                onPressed: (){
                  cubit.sendMessageImage(context,receiverID: receiverID,fcmToken: fcmToken);
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if(state is SpiderSendMessageImageLoadingState)
                    const DefaultLinerIndicator(),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(messageImage!)
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

