import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_grocery_list/Models/groceryItemCalculatorModel.dart';
import 'package:smart_grocery_list/Models/groceryListItemModel.dart';
import 'package:smart_grocery_list/Models/groceryListModel.dart';
import 'package:smart_grocery_list/Models/groceryPreviousItemModel.dart';
import 'package:smart_grocery_list/Notifiers/groceryItemCalculatorNotifier.dart';
import 'package:smart_grocery_list/Notifiers/groceryPreviousItemNotifier.dart';
import 'package:smart_grocery_list/utils/groceryListModelData.dart';
import 'package:smart_grocery_list/Notifiers/groceryListDataNotifier.dart';

import 'package:smart_grocery_list/Notifiers/groceryListItemNotifier.dart';
import 'package:smart_grocery_list/Notifiers/groceryListNotifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_grocery_list/styles/colorPalette.dart';
import 'package:smart_grocery_list/routes/app_router.dart';

final groceryListProvider =
    StateNotifierProvider<GroceryListNotifier, List<GroceryListModel>>((ref) {
  return GroceryListNotifier();
});
final groceryListItemProvider =
    StateNotifierProvider<GroceryListItemNotifier, List<GroceryListItemModel>>(
        (ref) {
  return GroceryListItemNotifier();
});
final groceryListItemCalculatorProvider = StateNotifierProvider<
    GroceryItemNotifier, List<GroceryItemCalculatorModel>>((ref) {
  return GroceryItemNotifier();
});
final iDCountProvider = StateProvider<int>((ref) {
  return 0;
});

final quantityProvider = StateProvider<int>((ref) {
  return 1;
});

final groceryListDataProvider =
    StateNotifierProvider<GroceryListDataNotifier, List<GroceryListModelData>>(
        (ref) {
  return GroceryListDataNotifier();
});
final groceryPreviousItemProvider = StateNotifierProvider<
    GroceryPreviousItemNotifie, List<GroceryPreviousItemModel>>((ref) {
  return GroceryPreviousItemNotifie();
});
final budgetProvider = StateProvider<double>((ref) {
  return 0.0;
});
final budgetLeftProvider = StateProvider<double>((ref) {
  return 0.0;
});
final totalProvider = StateProvider<double>((ref) {
  return 0.0;
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  final _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Geting list from database to state when the app start
    ref.read(groceryListDataProvider.notifier).getListsFromDb(ref);
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.PrimaryColor,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
            displayLarge:
                TextStyle(fontSize: 38.22, fontWeight: FontWeight.w500),
            titleLarge: GoogleFonts.annieUseYourTelescope(
              fontSize: 28.22,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: GoogleFonts.annieUseYourTelescope(
                fontSize: 17, fontWeight: FontWeight.w600),
            displaySmall: GoogleFonts.annieUseYourTelescope(
                fontSize: 15, fontWeight: FontWeight.w600),
            titleMedium:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            titleSmall:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
