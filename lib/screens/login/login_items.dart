import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/screens/register/register_screen.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class BuildRegisterButton extends StatelessWidget {
  const BuildRegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "noAccount".tr,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w100
          ),
        ),
        const SizedBox(width: 8,),
        TextButton(
          onPressed: (){
            Navigator.pushNamed(context, RegisterScreen.screenRoute);
          },
          child: Text(
            "register".tr,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.blue.shade300
            ),
          ),
        )
      ],
    );
  }
}

class BuildLoginButton extends StatelessWidget {
  final LoginCubit cubit;
  final LoginStates state;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const BuildLoginButton({Key? key, required this.cubit,
    required this.state, required this.formKey, required this.emailController, required this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          cubit.userLogin(
              context,
              email: emailController.text,
              password: passwordController.text
          );
        }
      },
      minWidth: double.infinity,
      height: 45,
      color: Colors.blue.shade400,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child:state is! LoginLoadingState? Text(
        'login'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15
        ),
      ): const Center(
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

class BuildEmailAndPassword extends StatelessWidget {
  final LoginCubit cubit;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const BuildEmailAndPassword({Key? key, required this.cubit, required this.emailController,
    required this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextFormFiled(
          validateText: "email".tr,
          controller: emailController,
          inputType: TextInputType.emailAddress,
          prefixIcon: IconBroken.Message,
          label: "email".tr,
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
          label: "password".tr,
          textColor: Colors.grey[700],
          borderColor: Colors.grey,
          preIconColor: Colors.grey[700],
          suffixIconColor: Colors.grey,
        ),
      ],
    );
  }
}

class BuildLoginHead extends StatelessWidget {
  const BuildLoginHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'login'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 15,),
        Text(
          'loginContent'.tr,
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

class BuildOrDivider extends StatelessWidget {
  const BuildOrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Expanded(child: DefaultDivider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("or".tr,style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),),
          ),
          const Expanded(child: DefaultDivider()),
        ],
      ),
    );
  }
}

class BuildSocialButton extends StatelessWidget {
  final String image;
  final String text;
  final Function onPressed;
  const BuildSocialButton({Key? key, required this.image,
    required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: ()=>onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            languageFun(
                en: Row(
                  children: [
                    Image.asset(
                      'assets/images/$image',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                ar: const SizedBox()
            ),
            Text(
                text,
            style:Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15
            )),
            languageFun(
                ar: Row(
                  children: [
                    const SizedBox(width: 10,),
                    Image.asset(
                      'assets/images/$image',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                en: const SizedBox()
            ),
          ],
        ),
      ),
    );
  }
}

