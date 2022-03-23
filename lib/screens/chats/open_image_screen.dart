import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/models/message_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';


class OpenImageScreen extends StatelessWidget {
  final MessageModel? messageModel;
  final UserModel? userModel;
  const OpenImageScreen({Key? key, required this.messageModel, this.userModel}) : super(key: key);

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
            actions:[
              if(messageModel!.senderID!=cubit.userModel!.uId)
                IconButton(
                  onPressed: (){
                    cubit.saveImage(messageModel!.image, context);
                  },
                  icon:state is! SpiderSaveImageImageLoadingState?
                  const Icon(IconBroken.Download,size: 22,):
                  const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue
                      )
                  ),
                )

            ],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messageModel!.senderID==cubit.userModel!.uId?
                "you".tr:
                "${userModel!.name}",
                  style: const TextStyle(color: Colors.black,fontSize: 15),),
                Text(
                  "${dateFormat(messageModel!.date)!['date']}",
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 11.5
                  ),
                )
              ],
            ),
            leading: IconButton(
              icon: const BackIcon(size: 22,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body:  Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: CachedNetworkImage(
                  imageUrl: "${messageModel!.image}",
                  placeholder:(context,s)=> const FailedImage(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
