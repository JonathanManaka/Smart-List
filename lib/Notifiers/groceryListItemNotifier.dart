import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/Models/groceryListItemModel.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

class GroceryListItemNotifier
    extends StateNotifier<List<GroceryListItemModel>> {
  GroceryListItemNotifier() : super([]);

  void addGroceryListItem(GroceryListItemModel groceryListItemModel) {
    state = [...state, groceryListItemModel];
  }

  void deleteGroceryListItem(index) {
    final result = state
        .where((element) => element.listItemID.toString() != index.toString())
        .toList();
    state = [...result];
  }

  void additemsToDb(int fk, String itemDesciption, int itemQnty) async {
    await SQLHelper.createItem(itemDesciption, fk.toString(), itemQnty);
  }
}
