import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/network/local/cache_helper.dart';
import 'package:spider/network/reomte/dio_helper.dart';
import 'package:spider/screens/chats/messages_screen.dart';
import 'package:spider/screens/edit_profile/edit_profile.dart';
import 'package:spider/screens/likes/likes_screen.dart';
import 'package:spider/screens/login/login_screen.dart';
import 'package:spider/screens/notifications/notifications_screen.dart';
import 'package:spider/screens/post/post_screen.dart';
import 'package:spider/screens/register/register_screen.dart';
import 'package:spider/screens/select_lang/select_lang_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/styles/themes.dart';
import 'package:spider/translations/translation.dart';
import 'cubit/bloc_observer.dart';
import 'screens/home/home_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //toastBuilder(msg: "Background Message", color: Colors.grey.shade700);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  DioHelper.init();
  token = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await CacheHelper.init();
  uId=CacheHelper.getData(key: 'uID');
  lang = CacheHelper.getData(key: 'lang');

  /// get device language
  final String defaultLocale = Platform.localeName.substring(0,2);
  defaultLang = defaultLocale;
  Widget homeWidget;
  if(lang==null){
    homeWidget=const SelectLanguageScreen();
  }else{
    if(uId==null||uId!.isEmpty){
      homeWidget=const LoginScreen();
    }
    else {
      homeWidget= const HomeScreen();
    }
  }
  debugPrint("token============> $token");
  runApp(
      MyApp(homeWidget: homeWidget,)
      // DevicePreview(
      //     enabled: !kReleaseMode,
      //     builder: (context) =>MyApp(homeWidget: homeWidget,)
      // ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homeWidget;
  const MyApp({Key? key, required this.homeWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context)=>SpiderCubit()..getUserData()..getPosts()..getAllUsers()
        ),
      ],
      child: BlocConsumer<SpiderCubit,SpiderStates>(
        listener: (context,state){},
        builder: (context,state){
              return GetMaterialApp(
                useInheritedMediaQuery: true,
                debugShowCheckedModeBanner: false,
                home: Directionality(
                    textDirection:languageFun(
                        ar: ui.TextDirection.rtl,
                        en: ui.TextDirection.ltr
                    ),
                    child: homeWidget,
                ),
                routes: {
                  LoginScreen.screenRoute:(context)=>const LoginScreen(),
                  RegisterScreen.screenRoute:(context)=>const RegisterScreen(),
                  HomeScreen.screenRoute:(context)=>const HomeScreen(),
                  PostScreen.screenRoute:(context)=>const PostScreen(),
                  EditProfileScreen.screenRoute:(context)=>const EditProfileScreen(),
                  LikesScreen.screenRoute:(context)=>const LikesScreen(),
                  MessagesScreen.screenRoute:(context)=> MessagesScreen(),
                  NotificationsScreen.screenRoute:(context)=>const NotificationsScreen(),
                },

                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.light,
                translations: Translation(),
                locale: Locale(
                  languageFun(ar: 'ar', en: 'en')
                ),
                fallbackLocale: const Locale('en'),
                builder: (context, widget) => ResponsiveWrapper.builder(
                  ClampingScrollWrapper.builder(context, widget!),
                    maxWidth: 1200,
                    minWidth: 400,
                    defaultScale: true,
                    breakpoints: [
                      const ResponsiveBreakpoint.resize(400, name: MOBILE),
                      const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                      const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                    ],
                ),
              );
        },
      ),
    );
  }
}
