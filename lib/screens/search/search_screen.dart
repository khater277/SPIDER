import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spider/cubit/spider_cubit.dart';
import 'package:spider/cubit/spider_states.dart';
import 'package:spider/screens/search/search_items.dart';
import 'package:spider/shared/constants.dart';
import 'package:spider/shared/default_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool clear=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocConsumer<SpiderCubit,SpiderStates>(
      listener: (context,state){},
      builder: (context,state){
        SpiderCubit cubit = SpiderCubit.get(context);
        return Scaffold(
            body:Padding(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
                right: languageFun(ar: 0.0, en: 10.0),
                left: languageFun(ar: 10.0, en: 0.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: (){Navigator.pop(context);},
                          icon: const BackIcon(size: 24,)),
                      Expanded(
                        child: DefaultTextFiled(
                          controller: _searchController,
                          hint: "searchHint".tr,
                          hintSize: 15,
                          height: 10,
                          suffix: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchController,
                            builder: (context, value, child) {
                              return IconButton(
                                onPressed: value.text.isNotEmpty ? () {
                                  setState(() {
                                    clear = true;
                                  });
                                  _searchController.clear();
                                  //FocusScope.of(context).unfocus();
                                } : null,
                                icon: const Icon(Icons.close,size: 24),
                              );
                            },
                          ),
                          focusBorder: Colors.blue.withOpacity(0.4),
                          border: Colors.grey.withOpacity(0.6),
                          onChanged: (value){
                            setState(() {
                              clear=false;
                            });
                            cubit.searchAllUsers(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  state is! SpiderSearchLoadingState?
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: (_searchController.text.isNotEmpty)? (
                          (cubit.searchList.isNotEmpty)?
                          (BuildUsersList(cubit: cubit,))
                              :clear==false? (const NotMatchingItem())
                              :const SearchNowItem()
                      ) : (
                          const SearchNowItem()
                      ),
                    ),
                  ):
                  const DefaultLinearIndicator(),
                ],
              ),
            )
        );
      },
    ));
  }
}
