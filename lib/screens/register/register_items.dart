import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/screens/register/cubit/register_cubit.dart';
import 'package:spider/screens/register/cubit/register_state.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';

class BuildRegisterButton extends StatelessWidget {
  final RegisterCubit cubit;
  final RegisterStates state;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const BuildRegisterButton({Key? key, required this.cubit, required this.state,
    required this.formKey, required this.emailController, required this.nameController,
    required this.passwordController, required this.phoneController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          List<String> mails=[
            "@gmail.com", "@yahoo.com", "@outlook.com",];
          int index=emailController.text.indexOf('@');
          if(EmailValidator.validate(emailController.text)&&
              mails.contains(emailController.text.substring(index,emailController.text.length))){
            String upper = nameController.text.toUpperCase();
            if(nameController.text.length>1){
              if(upper[0]==nameController.text[0]) {
                cubit.userRegister(context,
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  phone: phoneController.text,
                );
              }
              else{
                toastBuilder(msg: "${"startUpper".tr} ${upper[0]+nameController.text.substring(0,1)}",
                    color: Colors.grey[700]);
              }
            }
            else{
              toastBuilder(msg: "moreOne".tr,
                  color: Colors.grey[700]);
            }
          } else{
            toastBuilder(msg: "invalidEmail".tr, color: Colors.grey[700]);
          }
        }
      },
      minWidth: double.infinity,
      height: 40,
      color: Colors.blue.shade400,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child:state is! UserRegisterLoadingState? Text(
        'register'.tr,
        style: const TextStyle(
          color: Colors.white,
        ),
      ):
      const Center(
        child: SizedBox(
          width: 20,height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BuildRegisterFields extends StatelessWidget {
  final RegisterCubit cubit;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  const BuildRegisterFields({Key? key, required this.cubit,
    required this.emailController, required this.nameController,
    required this.passwordController, required this.phoneController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextFormFiled(
          validateText: "name".tr,
          controller: nameController,
          inputType: TextInputType.name,
          prefixIcon: IconBroken.Profile,
          label: "name".tr,
          textColor: Colors.grey[700],
          borderColor: Colors.grey,
          preIconColor: Colors.grey[700],
        ),
        const SizedBox(height: 15,),
        DefaultTextFormFiled(
          validateText: "email".tr,
          controller: emailController,
          inputType: TextInputType.emailAddress,
          prefixIcon: IconBroken.Message,
          label: 'email'.tr,
          textColor: Colors.grey[700],
          borderColor: Colors.grey,
          preIconColor: Colors.grey[700],
        ),
        const SizedBox(height: 15,),
        DefaultTextFormFiled(
          validateText: "password".tr,
          controller: passwordController,
          isPassword: cubit.visible,
          inputType: TextInputType.visiblePassword,
          prefixIcon: IconBroken.Lock,
          suffixIcon: cubit.icon,//cubit.icon,
          suffixPressed: () {
            cubit.changeIcon();
          },
          label: 'password'.tr,
          textColor: Colors.grey[700],
          borderColor: Colors.grey,
          preIconColor: Colors.grey[700],
          suffixIconColor: Colors.grey,
        ),
        const SizedBox(height: 15,),
        DefaultTextFormFiled(
          validateText: "phoneNumber".tr,
          controller: phoneController,
          inputType: TextInputType.phone,
          prefixIcon: IconBroken.Call,
          label: "phoneNumber".tr,
          textColor: Colors.grey[700],
          borderColor: Colors.grey,
          preIconColor: Colors.grey[700],
        ),
      ],
    );
  }
}

class BuildRegisterHead extends StatelessWidget {
  const BuildRegisterHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'register'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 15,),
        Text(
          'registerContent'.tr,
          style: const TextStyle(
            //fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}