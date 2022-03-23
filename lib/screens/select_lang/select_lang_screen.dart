import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'select_languuage_item.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){},
      builder: (context,state){
        SpiderCubit cubit = SpiderCubit.get(context);
        return Scaffold(
          body:Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("chooseLang".tr,style: const TextStyle(fontSize: 20),),
                      const SizedBox(height: 70,),
                      Row(
                        children:  [
                          InkWell(
                            onTap :(){
                              cubit.selectLanguage(arabic: false, english: true);
                            },
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                  color:cubit.enColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset('assets/images/en.png',
                                        width: 100,
                                        height: 100,)
                                  ),
                                  const Text("English",style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap :(){
                              cubit.selectLanguage(arabic: true, english: false);
                            },
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                  color:cubit.arColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset('assets/images/ar.png',
                                        width: 100,
                                        height: 100,)
                                  ),
                                  const Text("العربية",style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const BuildContinueButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}


