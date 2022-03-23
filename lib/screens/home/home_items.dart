import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/screens/notifications/notifications_screen.dart';
import 'package:spider/screens/search/search_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/styles/icons_broken.dart';

class BuildBottomNavBar extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildBottomNavBar({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: cubit.currentIndex,
      onTap: (index) {
        cubit.changeNavBar(index);
      },
      items: [
        BottomNavigationBarItem(
          label: "homeNav".tr,
          icon: const Icon(IconBroken.Home),
        ),
        BottomNavigationBarItem(
          label: "chatsNav".tr,
          icon: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              const Icon(IconBroken.Message),
              if(cubit.newMSGs.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.7),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        BottomNavigationBarItem(
          label: "postNav".tr,
          icon: const Icon(IconBroken.Paper_Upload),
        ),
        BottomNavigationBarItem(
          label: "usersNav".tr,
          icon: const Icon(IconBroken.Location),
        ),
        BottomNavigationBarItem(
          label: "profileNav".tr,
          icon: const Icon(IconBroken.Profile),
        ),
      ],
    );
  }
}

class BuildLogOutButton extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildLogOutButton({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("logOut".tr,style: const TextStyle(
                    fontSize: 20
                ),),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(10.0))),
                content: Builder(
                  builder: (context) {
                    return SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("logOutContent".tr,
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                      onPressed: (){
                                        cubit.logOut(context);
                                      },
                                      child:Text(
                                        "yes".tr,
                                        style: const TextStyle(
                                            fontSize: 16
                                        ),
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child:Text(
                                      "no".tr,
                                      style: const TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
          );
        },
        icon: const Icon(IconBroken.Logout,size: 22)
    );
  }
}

class BuildSearchButton extends StatelessWidget {
  const BuildSearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          navigateTo(context: context, widget: const SearchScreen());
        },
        icon: const Icon(IconBroken.Search,size: 22)
    );
  }
}

class BuildNotificationsButton extends StatelessWidget {
  const BuildNotificationsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SpiderCubit cubit = SpiderCubit.get(context);
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, NotificationsScreen.screenRoute);
        },
        icon: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            const Icon(IconBroken.Notification,size: 22),
            if(cubit.followRequests.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5,horizontal: 2),
                child: CircleAvatar(
                  radius: 4.5,
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        )
    );
  }
}
