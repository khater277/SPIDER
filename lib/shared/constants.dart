import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/models/last_message_model.dart';
import 'package:spider/models/user_model.dart';
import 'package:spider/screens/chats/messages_screen.dart';
import 'package:spider/screens/notifications/notifications_screen.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

const double h=0.00146;
const double w=0.0024304;

String? lang;
String? defaultLang;

final ScrollController scrollController = ScrollController();

void scrollDown()async{
  await Future.delayed(const Duration(milliseconds: 300));
  SchedulerBinding.instance?.addPostFrameCallback((_) {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  });
}

void receiveNotification(context){
  FirebaseMessaging.onMessage.listen((event) {
    UserModel? uModel=SpiderCubit.get(context).allUsers
        .firstWhere((element) => element.uId==event.data['senderID']);
    if(event.data['id']=="1"){
      buildFlushBar(
        icon: IconBroken.Message,
          color: Colors.blue,
          message: "${uModel.name} sent you new message",
          messageColor: Colors.white,
          duration: 3,
          context: context,
          position: FlushbarPosition.TOP,
      );
    }else{
        buildFlushBar(
          icon: IconBroken.User,
          color: Colors.blue,
          message: "${uModel.name} sent you follow request",
          messageColor: Colors.white,
          duration: 3,
          context: context,
          position: FlushbarPosition.TOP,
        );
  }});
}

void clickNotification(context){
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if(event.data['id']=="1"){
        UserModel? uModel=SpiderCubit.get(context).allUsers
            .firstWhere((element) => element.uId==event.data['senderID']);
        LastMessageModel? lastMessageModel=LastMessageModel.fromJson({
          "lastMessage":event.data['lastMessage'],
          "senderID":event.data['senderID'],
          "unReadMessages":false
        });
        navigateTo(context: context, widget: MessagesScreen(userModel: uModel,lastMessage: lastMessageModel,fromNotification: true,));
      }else{
        navigateTo(context: context, widget: const NotificationsScreen());
      }
    });
}

String? validateEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  } else {
    return "asd";
  }
}
GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();


String? uId="";
String? token="";
Color indicatorColor=Colors.red.withOpacity(0.7);

void printError(String? funName,String? error){
  debugPrint("error in $funName ====> $error");
}

void navigateTo({
  @required BuildContext? context,
  @required Widget? widget,
}) {
  Navigator.push(
    context!,
    MaterialPageRoute(builder: (context)=>widget!),
  );
}

void navigateAndFinish({
  @required BuildContext? context,
  @required Widget? widget,
}){
  Navigator.pushAndRemoveUntil(
      context!,
      MaterialPageRoute(builder: (context)=>widget!),
          (route) => false
  );
}

Map<String,String> cal={
  '01':'Jan', '02':'Feb',
  '03':'Mar', '04':'Apr',
  '05':'May','06':'Jun',
  '07':'Jul','08':'Aug',
  '09':'Sep','10':'Oct',
  '11':'Nov','12':'Dec',
};

Map<String,String> calAr={
  '01':'يناير', '02':'فبراير',
  '03':'مارس', '04':'ابريل',
  '05':'مايو','06':'يونيو',
  '07':'يونيه','08':'اغسطس',
  '09':'سبتمبر','10':'اكتوبر',
  '11':'نوفمبر','12':'ديسمبر',
};

Map<String,String> period={
  '00':'12', '01':'1', '02':'2', '03':'3',
  '04':'4','05':'5', '06':'6','07':'7',
  '08':'8','09':'9', '10':'10','11':'11',
  '12':'12', '13':'1', '14':'2', '15':'3',
  '16':'4','17':'5', '18':'6','19':'7',
  '20':'8','21':'9', '22':'10','23':'11',
};

Map<String,String>? dateFormat(String? dateTime){
  String? day=dateTime!.substring(8,10);
  if(day[0]=='0'){
    day=day[1];
  }
  String? month=dateTime.substring(5,7);
  String? year=dateTime.substring(0,4);
  String? hour=dateTime.substring(11,13);
  String? min=dateTime.substring(14,16);
  String x="";
  if(hour.startsWith('0')||hour=="10"||hour=="11"){
    x=languageFun(ar: 'ص',en: "AM");
  }else{
    x=languageFun(ar: 'م',en: "PM");
  }
  return {
    'date':languageFun(
        ar: "$day ${calAr[month]} $year في ${period[hour]}:$min $x",
        en: "$day ${cal[month]} $year at ${period[hour]}:$min $x"
    ),
    'year':year
  };
}

dynamic languageFun({
  @required ar,
  @required en,
}){
 return lang!=null?
  lang=='ar'?ar:en
      :(defaultLang=='ar'?ar:en);
}






String lastMessageDate(cubit,index){
  int firstIndex=0;
  int lastIndex=0;
  if(lang=='ar'){
    lastIndex = dateFormat(cubit.lastMessages[index].date)!['date']!.
    indexOf('في')+2;
    firstIndex = dateFormat(cubit.lastMessages[index].date)!['date']!.
    indexOf('في')-5;
  }
  return languageFun(
      // ar:dateFormat(cubit.lastMessages[index].date)!['date']!.contains('في')?
      // dateFormat(cubit.lastMessages[index].date)!['date']!.
      // replaceRange(firstIndex,lastIndex, ',')+checkYear(cubit, index)
      //     :dateFormat(cubit.lastMessages[index].date)!['date'],
    ar: "asd",
      en: dateFormat(cubit.lastMessages[index].date)!['date']!.
      replaceRange(7, 15, ",")+checkYear(cubit, index)
  );
}

String checkYear(SpiderCubit cubit, int index){
  return (dateFormat(DateTime.now().toString())!['year']!)==
          dateFormat(cubit.lastMessages[index].date)!['year']?"":
      " ${dateFormat(cubit.lastMessages[index].date)!['year']}";
}

String formatName(String name){
  List<int> capitalLettersIndex=[];
  for(int i=0;i<name.length;i++){
    if(name[i]==" "){
      capitalLettersIndex.add(i);
    }
  }
  for(int i=0;i<capitalLettersIndex.length;i++){
    String smallLetter = name.substring(
        capitalLettersIndex[i],capitalLettersIndex[i]+2);
    String capitalLetter = smallLetter.toUpperCase();
    name = name.replaceRange(
        capitalLettersIndex[i],
        capitalLettersIndex[i]+2,
        capitalLetter
    );
  }
  String firstLetter = name[0];
  name = name.replaceFirst(firstLetter, firstLetter.toUpperCase());
  return name;
}