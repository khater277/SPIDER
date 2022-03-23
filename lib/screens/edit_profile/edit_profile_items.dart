import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';

import 'package:spider/styles/icons_broken.dart';

import '../../shared/default_widgets.dart';

class BuildUpdateButton extends StatelessWidget {
  final SpiderCubit cubit;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController phoneController;
  const BuildUpdateButton({Key? key, required this.cubit,
    required this.formKey, required this.nameController,
    required this.bioController, required this.phoneController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          if(formKey.currentState!.validate()) {
            cubit.updateUserData(
                name: nameController.text,
                bio: bioController.text,
                phone: phoneController.text
            );
          }
        },
        child: Text("update".tr,
          style: const TextStyle(
              fontSize: 14
          ),)
    );
  }
}

class BuildCoverImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildCoverImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CoverImage(cubit: cubit),
          BuildPickCoverImage(cubit: cubit, ),
        ],
      ),
    );
  }
}
class CoverImage extends StatelessWidget {
  final SpiderCubit cubit;
  const CoverImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5),
          topLeft: Radius.circular(5),
        ),
        child:
        cubit.coverImage==null?
        DefaultFadedImage(
            imgUrl: "${cubit.userModel!.coverImage}",
            height: 150,
            width: double.infinity
        )
            :Image.file(cubit.coverImage!,
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        )
    );
  }
}
class BuildPickCoverImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildPickCoverImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor:
        Colors.white.withOpacity(0.5),
        child: IconButton(
          onPressed: () {
            cubit.getCoverImage();
          },
          icon: Icon(
            IconBroken.Camera,
            color: Colors.grey.shade800,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class BuildProfileImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildProfileImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ProfileImage(cubit: cubit),
        BuildPickProfileImage(cubit: cubit)
      ],
    );
  }
}
class ProfileImage extends StatelessWidget {
  final SpiderCubit cubit;
  const ProfileImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      child: CircleAvatar(
          radius: 55,
          backgroundImage:
          cubit.profileImage==null?
          CachedNetworkImageProvider(
            cubit.userModel!.profileImage.toString(),
          )
              :FileImage(cubit.profileImage!) as ImageProvider
      ),
    );
  }
}
class BuildPickProfileImage extends StatelessWidget {
  final SpiderCubit cubit;
  const BuildPickProfileImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      child: IconButton(
        onPressed: () {
          cubit.getProfileImage();
        },
        icon: Icon(
          IconBroken.Camera,
          color: Colors.grey.shade800,
          size: 25,
        ),
      ),
    );
  }
}

class BuildUpdateProfileButton extends StatelessWidget {
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildUpdateProfileButton({Key? key, required this.cubit, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          MaterialButton(
            onPressed: (){
              cubit.setProfileImage();
            },
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(IconBroken.Image,color: Colors.white,),
                const SizedBox(width: 5,),
                Text(
                  "uploadProfile".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            color: Colors.blue.withOpacity(0.7),
          ),
          if(state is SpiderSetProfileImageLoadingState)
            LinearProgressIndicator(
              color: Colors.blue.withOpacity(0.3),
              backgroundColor: Colors.white,
            ),
        ],
      ),
    );
  }
}

class BuildUpdateCoverButton extends StatelessWidget {
  final SpiderCubit cubit;
  final SpiderStates state;
  const BuildUpdateCoverButton({Key? key, required this.cubit, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          MaterialButton(
            onPressed: (){
              cubit.setCoverImage();
            },
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(IconBroken.Image,color: Colors.white,),
                const SizedBox(width: 5,),
                Text(
                  "uploadCover".tr,
                  style: const TextStyle(
                      color: Colors.white
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            color: Colors.blue.withOpacity(0.7),
          ),
          if(state is SpiderSetCoverImageLoadingState)
            LinearProgressIndicator(
              color: Colors.blue.withOpacity(0.3),
              backgroundColor: Colors.white,
            ),
        ],
      ),
    );
  }
}
