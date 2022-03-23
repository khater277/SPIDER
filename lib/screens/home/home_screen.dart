import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/screens/home/home_items.dart';
import 'package:spider/screens/post/post_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class HomeScreen extends StatefulWidget {
  static const String screenRoute="home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){
        if(state is SpiderAddPostState){
          Navigator.pushNamed(context, PostScreen.screenRoute);
        }
      },
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit = SpiderCubit.get(context);
        return cubit.userModel!=null?
        Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex].tr,style: const TextStyle(
                fontSize: 20
            ),),
            leading: Navigator.canPop(context)&&cubit.currentIndex!=0?
            IconButton(
                onPressed: (){
                  Navigator.canPop(context)?
                  Navigator.pop(context):cubit.popHome(context);
                },
                icon: const BackIcon(size: 22)
            ):null,
            actions: [
              const BuildNotificationsButton(),
              const BuildSearchButton(),
              BuildLogOutButton(cubit: cubit),
            ],
          ),
          body: state is! SpiderGetUserDataLoadingState||
              state is! SpiderGetPostsLoadingState?
          OfflineWidget(onlineWidget: cubit.screens[cubit.currentIndex],)
              :const DefaultProgressIndicator(icon: IconBroken.Home)
          ,
          bottomNavigationBar: BuildBottomNavBar(cubit: cubit),
        ) :
        const Scaffold(
          body: DefaultProgressIndicator(icon: IconBroken.Home),
        );
      },
    );
  }


}