import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/message_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/chats/open_image_screen.dart';
import 'package:spider/styles/icons_broken.dart';
import '../../shared/constants.dart';
import '../../shared/default_widgets.dart';

class BuildSentButton extends StatelessWidget {
  final TextEditingValue value;
  final SpiderCubit cubit;
  final TextEditingController messageController;
  final String? receiverID;
  final String? fcmToken;
  const BuildSentButton({Key? key,
    required this.value,
    required this.cubit,
    required this.messageController, required this.receiverID,required this.fcmToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 23.5,
      backgroundColor: value.text.isNotEmpty ? Colors.blue.withOpacity(0.5)
          :Colors.grey.shade200,
      child: IconButton(
        onPressed: value.text.isNotEmpty ? ()  async {
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
          cubit.sendMessage(
              receiverID: receiverID,
              text: messageController.text.substring(0,messageController.text.length-endCnt),
              fcmToken: fcmToken
          );
          messageController.clear();
          scrollDown();
        } : null,
        icon:  Icon(
          IconBroken.Send,size: 25,
          color:value.text.isNotEmpty ? Colors.white:Colors.black26,
        ),
      ),
    );
  }
}

class BuildMyMessage extends StatelessWidget {
  final String? message;
  final String? image;
  final MessageModel? messageModel;
  const BuildMyMessage({Key? key, this.message, this.image, this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: languageFun(
                    ar: const Radius.circular(0),
                    en: const Radius.circular(20)
                ),
                bottomRight: languageFun(
                    ar: const Radius.circular(20),
                    en: const Radius.circular(0)
                ),
              )
          ),
          child:
          message!=""?
          Padding(
            padding:const EdgeInsets.only(
                top: 8,bottom: 8,right: 12,left: 12),
            child: SelectableText(message!,
              style: const TextStyle(
                  fontSize: 14
              ),),
          )
              :
          Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: (){
                navigateTo(
                    context: context,
                    widget: OpenImageScreen(messageModel: messageModel,)
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: CachedNetworkImage(
                      imageUrl: image!,
                      placeholder:(context,s)=> const FailedImage(),
                      fit: BoxFit.cover,
                      errorWidget:(context,s,d)=>ErrorImage(width: 200,
                          height: 300)
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}

class BuildFriendMessage extends StatelessWidget {
  final String? message;
  final String? image;
  final UserModel? userModel;
  final MessageModel? messageModel;
  const BuildFriendMessage({Key? key, this.message, this.image, this.userModel, this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: languageFun(
                    ar: const Radius.circular(20),
                    en: const Radius.circular(0)
                ),
                bottomRight: languageFun(
                    ar: const Radius.circular(0),
                    en: const Radius.circular(20)
                ),
              )
          ),
          child:
          message!=""?
          Padding(
            padding:const EdgeInsets.only(
                top: 8,bottom: 8,right: 12,left: 12),
            child: SelectableText(message!,
              style: const TextStyle(
                  fontSize: 14
              ),),
          )
              :
          Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: (){
                navigateTo(
                    context: context,
                    widget: OpenImageScreen(messageModel: messageModel,userModel: userModel,)
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: CachedNetworkImage(
                      imageUrl: image!,
                      placeholder:(context,s)=> const FailedImage(),
                      fit: BoxFit.cover,
                      errorWidget:(context,s,d)=>const ErrorImage(width: 200, height: 300)
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
