import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider/screens/register/cubit/register_cubit.dart';
import 'package:spider/screens/register/cubit/register_state.dart';
import 'package:spider/shared/default_widgets.dart';

import 'register_items.dart';

class RegisterScreen extends StatefulWidget {
  static const String screenRoute="register_screen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _phoneController=TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>RegisterCubit(),
    child: BlocConsumer<RegisterCubit,RegisterStates>(
      listener: (context,state){},
      builder: (context,state){
        RegisterCubit cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: const BuildBackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BuildRegisterHead(),
                    const SizedBox(height: 30,),
                    BuildRegisterFields(
                        cubit: cubit,
                        emailController: _emailController,
                        nameController: _nameController,
                        passwordController: _passwordController,
                        phoneController: _phoneController
                    ),
                    const SizedBox(height: 20,),
                    BuildRegisterButton(
                        cubit: cubit,
                        state: state,
                        formKey: _formKey,
                        emailController: _emailController,
                        nameController: _nameController,
                        passwordController: _passwordController,
                        phoneController: _phoneController
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),);
  }
}
