import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/screens/home/home_screen.dart';
import 'package:spider/screens/notifications/notifications_items.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class NotificationsScreen extends StatefulWidget {
  static const String screenRoute="notification_screen";
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          SpiderCubit.get(context).getFollowRequest();
          return BlocConsumer<SpiderCubit,SpiderStates>(
            listener: (context,state){},
            builder: (context,state){
              SpiderCubit cubit = SpiderCubit.get(context);
              return WillPopScope(
                onWillPop: () async {
                  navigateAndFinish(context: context, widget: const HomeScreen());
                  return true;
                },
                child: Scaffold(
                    appBar: AppBar(
                      titleSpacing: 0,
                      title: Text("notifications".tr,
                        style: const TextStyle(
                            fontSize: 20
                        ),),
                      leading: IconButton(
                        onPressed: (){
                          navigateAndFinish(context: context, widget: const HomeScreen());
                        },
                        icon: const BackIcon(size: 22),
                      ),
                      actions: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(IconBroken.Notification,size: 22),
                        ),
                      ],
                    ),
                    body: cubit.followRequests.isNotEmpty?
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder:(context,index)=> BuildRequestItem(
                          userModel: cubit.allUsers[cubit.allUsersID.indexOf(cubit.followRequests[index])],
                        ),
                        separatorBuilder:(context,index)=> const SizedBox(height: 10,),
                        itemCount: cubit.followRequests.length
                    )
                        :NoItemsFounded(text: "noNotifications".tr, icon: IconBroken.Notification)
                ),
              );
            },
          );
        }
    );
  }
}
