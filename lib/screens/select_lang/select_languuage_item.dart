import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/screens/login/login_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';


class BuildContinueButton extends StatelessWidget {
  const BuildContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MaterialButton(
          onPressed: () {
            if(!SpiderCubit.get(context).ar&&!SpiderCubit.get(context).en){
              toastBuilder(
                msg: "selectLang".tr,
                color: Colors.grey.shade700,);
              return;
            }
            else{
              navigateAndFinish(context: context, widget: const LoginScreen());
            }
          },
          minWidth: 180,
          height: 45,
          color: Colors.blue.shade500,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          child:Text("continue".tr,
            style: const TextStyle(color: Colors.white,
                fontSize: 18),)
      ),
    );
  }
}