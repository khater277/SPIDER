import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){},
      builder: (context,state){
        SpiderCubit cubit = SpiderCubit.get(context);
        return Center(
          child: DropdownButton(
              value: cubit.selectedValue,
              items: const [
                DropdownMenuItem(
                  child: Text("English"),
                  value: "en",
                ),
                DropdownMenuItem(
                  child: Text("العربية"),
                  value: "ar",
                ),
              ],
              onChanged: (value){
                cubit.changeAppLanguage(value.toString());
              }
          ),
        );
      },
    );
  }
}
