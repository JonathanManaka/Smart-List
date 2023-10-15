import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_list/views/HomePage.dart';
import 'package:smart_grocery_list/views/addItemsPage.dart';
import 'package:smart_grocery_list/views/groceryListStatsPage.dart';
import 'package:smart_grocery_list/views/itemCalculatorPage.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: ('Page,Route'))
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: AddItemsRoute.page),
        AutoRoute(page: GroceryItemCalculatorRoute.page),
        AutoRoute(page: GroceryListStatsRoute.page),
      ];
}
