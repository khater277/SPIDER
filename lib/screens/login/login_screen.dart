import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/screens/login/cubit/login_cubit.dart';
import 'package:spider/screens/login/cubit/login_states.dart';
import 'package:spider/screens/login/login_items.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/styles/icons_broken.dart';


class LoginScreen extends StatefulWidget {
  static const String screenRoute="login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey=GlobalKey<FormState>();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
    child: BlocConsumer<LoginCubit,LoginStates>(
      listener: (context,state){},
      builder: (context,state){
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
            appBar: AppBar(),
            body: state is! GoogleSignInLoadingState||state is! FacebookSignInLoadingState?
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BuildLoginHead(),
                        const SizedBox(height: 40,),
                        BuildEmailAndPassword(
                            cubit: cubit,
                            emailController: _emailController,
                            passwordController: _passwordController,
                        ),
                        const SizedBox(height: 20,),
                        BuildLoginButton(
                            cubit: cubit,
                            state: state,
                            formKey: formKey,
                            emailController: _emailController,
                            passwordController: _passwordController
                        ),
                        const SizedBox(height: 15,),
                        const BuildRegisterButton(),
                        const BuildOrDivider(),
                        const SizedBox(height: 15,),
                        OutlinedButton(
                          onPressed: (){
                            cubit.googleSignIn(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                languageFun(
                                    en: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/google.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(width: 10,),
                                      ],
                                    ),
                                    ar: const SizedBox()
                                ),
                                Text(
                                    "googleSign".tr,
                                    style:Theme.of(context).textTheme.bodyText1!.copyWith(
                                        fontSize: 15
                                    )),
                                languageFun(
                                    ar: Row(
                                      children: [
                                        const SizedBox(width: 10,),
                                        Image.asset(
                                          'assets/images/google.png',
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
                        ),
                        const SizedBox(height: 10,),
                        OutlinedButton(
                          onPressed: (){
                            cubit.facebookSignIn(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                languageFun(
                                    en: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/facebook.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(width: 10,),
                                      ],
                                    ),
                                    ar: const SizedBox()
                                ),
                                Text(
                                    "facebookSign".tr,
                                    style:Theme.of(context).textTheme.bodyText1!.copyWith(
                                        fontSize: 15
                                    )),
                                languageFun(
                                    ar: Row(
                                      children: [
                                        const SizedBox(width: 10,),
                                        Image.asset(
                                          'assets/images/facebook.png',
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ):const DefaultProgressIndicator(icon: IconBroken.Login)
        );
      },
    ),
    );
  }
}
