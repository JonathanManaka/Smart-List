// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddItemsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddItemsPage(),
      );
    },
    GroceryItemCalculatorRoute.name: (routeData) {
      final args = routeData.argsAs<GroceryItemCalculatorRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GroceryItemCalculatorPage(
          key: args.key,
          titleName: args.titleName,
        ),
      );
    },
    GroceryListStatsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GroceryListStatsPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePage(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreenPage(),
      );
    },
  };
}

/// generated route for
/// [AddItemsPage]
class AddItemsRoute extends PageRouteInfo<void> {
  const AddItemsRoute({List<PageRouteInfo>? children})
      : super(
          AddItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddItemsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GroceryItemCalculatorPage]
class GroceryItemCalculatorRoute
    extends PageRouteInfo<GroceryItemCalculatorRouteArgs> {
  GroceryItemCalculatorRoute({
    Key? key,
    required String titleName,
    List<PageRouteInfo>? children,
    required String title,
  }) : super(
          GroceryItemCalculatorRoute.name,
          args: GroceryItemCalculatorRouteArgs(
            key: key,
            titleName: titleName,
          ),
          initialChildren: children,
        );

  static const String name = 'GroceryItemCalculatorRoute';

  static const PageInfo<GroceryItemCalculatorRouteArgs> page =
      PageInfo<GroceryItemCalculatorRouteArgs>(name);
}

class GroceryItemCalculatorRouteArgs {
  const GroceryItemCalculatorRouteArgs({
    this.key,
    required this.titleName,
  });

  final Key? key;

  final String titleName;

  @override
  String toString() {
    return 'GroceryItemCalculatorRouteArgs{key: $key, titleName: $titleName}';
  }
}

/// generated route for
/// [GroceryListStatsPage]
class GroceryListStatsRoute extends PageRouteInfo<void> {
  const GroceryListStatsRoute({List<PageRouteInfo>? children})
      : super(
          GroceryListStatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'GroceryListStatsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreenPage]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
