import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';
import 'package:spider/screens/edit_profile/edit_profile_items.dart';
import 'package:spider/styles/icons_broken.dart';

class EditProfileScreen extends StatefulWidget {
  static const String screenRoute="edit_profile_screen";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  final TextEditingController _phoneController=TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){
        if(state is SpiderSetProfileImageSuccessState) {
          buildFlushBar(
            context: context,
            icon: IconBroken.Image,
            message: "profile image uploaded successfully",
            duration: 3,
            color: Colors.blue,
            messageColor: Colors.white,
            position: FlushbarPosition.TOP
        );
        }
      },
      builder: (context,state){
        clickNotification(context);
        receiveNotification(context);
        SpiderCubit cubit=SpiderCubit.get(context);
        _nameController.text="${cubit.userModel!.name}";
        _bioController.text="${cubit.userModel!.bio}";
        _phoneController.text="${cubit.userModel!.phone}";
        return Scaffold(
          appBar: AppBar(
            title: Text("editProfileAppBar".tr,style: const TextStyle(
                fontSize: 20
            ),),
            titleSpacing: 0,
            actions: [
              BuildUpdateButton(
                  cubit: cubit,
                  formKey: formKey,
                  nameController: _nameController,
                  bioController: _bioController,
                  phoneController: _phoneController
              ),
              const SizedBox(width: 5,)
            ],
            leading: const BuildBackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is SpiderUpdateUserDataLoadingState)
                      const DefaultLinerIndicator(),
                    SizedBox(
                      height: 210,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          BuildCoverImage(cubit: cubit),
                          BuildProfileImage(cubit: cubit)
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    if(cubit.coverImage!=null||cubit.profileImage!=null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(cubit.profileImage!=null)
                              BuildUpdateProfileButton(cubit: cubit, state: state),
                            const SizedBox(width: 5,),
                            if(cubit.coverImage!=null)
                              BuildUpdateCoverButton(cubit: cubit, state: state)
                          ],
                        ),
                      ),
                    const SizedBox(height: 18,),
                    DefaultTextFormFiled(
                      validateText: "name".tr,
                      controller: _nameController,
                      inputType: TextInputType.name,
                      prefixIcon: IconBroken.User,
                      label: "name".tr,
                      textColor: Colors.grey[600],
                      borderColor: Colors.grey[400],
                      preIconColor:Colors.blue.withOpacity(0.5),
                      height: 12,
                    ),
                    const SizedBox(height: 10,),
                    DefaultTextFormFiled(
                        validateText: "bio".tr,
                        controller: _bioController,
                        inputType: TextInputType.text,
                        prefixIcon: IconBroken.Edit_Square,
                        label: "bio".tr,
                        textColor: Colors.grey[600],
                        borderColor: Colors.grey[400],
                        preIconColor: Colors.blue.withOpacity(0.5),
                        cursorHeight: 22,
                        height: 12
                    ),
                    const SizedBox(height: 10,),
                    DefaultTextFormFiled(
                        validateText: "phoneNumber".tr,
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                        prefixIcon: IconBroken.Call,
                        label: "phoneNumber".tr,
                        textColor: Colors.grey[600],
                        borderColor: Colors.grey[400],
                        preIconColor: Colors.blue.withOpacity(0.5),
                        cursorHeight: 22,
                        height: 12
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}














