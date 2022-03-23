import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spider/styles/icons_broken.dart';
import 'package:transparent_image/transparent_image.dart';

import 'constants.dart';


class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }
    return newValue;
  }
}

class DefaultProgressIndicator extends StatelessWidget {
  final IconData icon;
  const DefaultProgressIndicator({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlowingProgressIndicator(
            child: Icon(icon,size: 35,color: Colors.grey,),
          ),
          const SizedBox(height: 6,),
        ],
      ),
    );
  }
}

class DefaultLinerIndicator extends StatelessWidget {
  const DefaultLinerIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5,),
        LinearProgressIndicator(
          color: Colors.blue.withOpacity(0.3),
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class DefaultLinearIndicator extends StatelessWidget {
  const DefaultLinearIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Colors.blue.withOpacity(0.3),
      backgroundColor: Colors.white,
    );
  }
}

class BackIcon extends StatelessWidget {
  final double size;
  const BackIcon({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      languageFun(
          ar: IconBroken.Arrow___Right_2,
          en: IconBroken.Arrow___Left_2
      ),
      size: size,
    );
  }
}

Widget buildFlushBar({
  @required Color? color,
  @required String? message,
  @required Color? messageColor,
  @required int? duration,
  @required context,
  @required FlushbarPosition? position,
  @required IconData? icon,
}){
  return Flushbar(
    backgroundColor: color!,
    messageColor: messageColor,
    message: message,
    flushbarPosition: position!,
    duration: Duration(seconds: duration!),
    icon: Icon(icon,color: messageColor,),
    margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 2),
    borderRadius: BorderRadius.circular(5),
  )..show(context);
}

class FailedImage extends StatelessWidget{
  const FailedImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: double.infinity,
      child: Center(
        child: DefaultProgressIndicator(icon: IconBroken.Image),
      ),
    );
  }

}

class DefaultFadedImage extends StatelessWidget {
  final String imgUrl;
  final double height;
  final double width;
  const DefaultFadedImage({Key? key, required this.imgUrl, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: imgUrl,
      fit: BoxFit.cover,
      height: height,
      width: width,
      imageErrorBuilder: (context,s,d)=>
          ErrorImage(width: width, height: height),
    );
  }
}

class ErrorImage extends StatelessWidget {
  final double? width;
  final double? height;
  const ErrorImage({Key? key,@required this.width,@required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(IconBroken.Danger,size: 50,color: Colors.grey,),
            Text("connection error",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}

class BuildBackButton extends StatelessWidget {
  const BuildBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){Navigator.pop(context);},
      icon: const BackIcon(size: 22),
    );
  }
}

class NoItemsFounded extends StatelessWidget {
  final String text;
  final IconData icon;
  const NoItemsFounded({Key? key, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: Colors.grey[300],size: 250,),
            const SizedBox(height: 10,),
            Text(text,style: TextStyle(
                color: Colors.grey[400],
                fontSize: 20
            ),)
          ],
        ),
      ),
    );
  }
}

class DefaultSeparator extends StatelessWidget {
  const DefaultSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}


void toastBuilder({
  @required String? msg,
  @required Color? color,
}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 13.0);
}


//ignore: must_be_immutable
class DefaultTextFormFiled extends StatelessWidget{
  final TextEditingController? controller;
  final Color? textColor;
  final TextInputType? inputType;
  final IconData? prefixIcon;
  final String? label;
  final Color? borderColor;
  final Color? preIconColor;
  final String? validateText;
  double? height;
  double? cursorHeight;
  Color? suffixIconColor;
  bool? isPassword;
  // Function? onSubmit(value)?;
  // Function? onChanged(value)?;
  Function? suffixPressed;
  IconData? suffixIcon;

   DefaultTextFormFiled({Key? key,
     required this.controller,
     required this.textColor,
     required this.inputType,
     required this.prefixIcon,
     required this.label,
     required this.borderColor,
     required this.preIconColor,
     this.validateText, this.cursorHeight,
     this.height,this.isPassword,
     this.suffixIcon,this.suffixIconColor,this.suffixPressed}
     ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: textColor,
      validator: (value) {
        if (value!.isEmpty) {
          return "$validateText can't be empty";
        }
        return null;
      },
      style: TextStyle(
        color: textColor,
      ),
      cursorHeight: cursorHeight,
      keyboardType: inputType,
      obscureText: isPassword==null?false:isPassword!,
      //onFieldSubmitted: (value) => onSubmit!(value),
      //onChanged: (value)=>onChanged!(value),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: height==null?18:height!),
        prefixIcon: Icon(
          prefixIcon,
          color: preIconColor,
        ),
        //hintText: "ASD",
        suffixIcon:suffixIcon!=null? IconButton(
          onPressed: () => suffixPressed!(),
          icon: Icon(suffixIcon),
          color: suffixIconColor,
          //focusColor: suffixIconColor,
        ):null,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: borderColor!,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: borderColor!,
            )),
        labelText: label,
        labelStyle: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

class DefaultTextFiled extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final double hintSize;
  final double height;
  final Widget suffix;
  final Color focusBorder;
  final Color border;
  Function? onSubmitted;
  Function? onChanged;

  DefaultTextFiled({Key? key, required this.controller, required this.hint,
    required this.hintSize, required this.height, required this.suffix,
    required this.focusBorder, required this.border,this.onChanged,this.onSubmitted,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [NoLeadingSpaceFormatter()],
      cursorColor: Colors.blue.withOpacity(0.2),
      controller: controller,
      onSubmitted: (value)=>onSubmitted!(value),
      onChanged: (value)=>onChanged!(value),
      decoration:  InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: hintSize,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: height,
            horizontal: 15),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: border,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: focusBorder,
            )),
      ),
    );
  }
}

class DefaultDivider extends StatelessWidget {
  const DefaultDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}

class OfflineWidget extends StatelessWidget{
  final Widget onlineWidget;
  const OfflineWidget({Key? key, required this.onlineWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return connected? onlineWidget
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    IconBroken.Danger,
                    size: 250,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No internet connection found",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 20,color: Colors.grey.withOpacity(0.5),),
                      ),
                    ],
                  ),
                ],
              );
            },
            child: const Center(
              child: Text("Online OR Offline"),
            ),
          );
        });
  }
}