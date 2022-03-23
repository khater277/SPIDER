import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/styles/icons_broken.dart';

class BuildTagsButton extends StatelessWidget {
  const BuildTagsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        child: Text("tags".tr,style: const TextStyle(fontSize: 14),),
      ),
    );
  }
}

class BuildAddPhotoButton extends StatelessWidget {
  final SpiderCubit cubit;

  const BuildAddPhotoButton({Key? key, required this.cubit,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
          onPressed: () {
            cubit.getPostImage();
          },
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children:  [
              const Icon(IconBroken.Image,
                size: 24,
              ),
              const SizedBox(width: 5,),
              Text("addPhoto".tr,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }
}

class BuildCreatePostImage extends StatelessWidget {
  final SpiderCubit cubit;

  const BuildCreatePostImage({Key? key, required this.cubit,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child: Image.file(
                cubit.postImage!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.5),
                child: IconButton(
                  onPressed: () {
                    cubit.removePostImage();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8,),
      ],
    );
  }
}

class BuildCreatePostNameAndProfilePic extends StatelessWidget {
  final SpiderCubit cubit;

  const BuildCreatePostNameAndProfilePic({Key? key, required this.cubit,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage:
          CachedNetworkImageProvider(
              "${cubit.userModel!.profileImage}"
          ),
        ),
        const SizedBox(width: 10,),
        Text(
          "${cubit.userModel!.name}",
          style: const TextStyle(height: 1.4,fontSize: 15),
        ),
      ],
    );
  }
}

class BuildPostButton extends StatelessWidget {
  final SpiderCubit cubit;
  final TextEditingController postController;
  const BuildPostButton({Key? key, required this.cubit,
    required this.postController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          postController.text == "" && cubit.postImage == null
              ? null
              : cubit.postImage == null
              ? cubit.createPost(text: postController.text)
              : cubit.setPostImage(text: postController.text);
        },
        child: Text(
          "publish".tr,
          style: const TextStyle(fontSize: 14),
        ));
  }
}