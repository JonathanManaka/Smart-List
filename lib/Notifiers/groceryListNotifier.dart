import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/Models/groceryListModel.dart';
import 'package:smart_grocery_list/main.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

class GroceryListNotifier extends StateNotifier<List<GroceryListModel>> {
  GroceryListNotifier() : super([]);
  void addGroceryList(GroceryListModel groceryListModel) {
    //Using dart spread operator to add groceryList
    state = [...state, groceryListModel];
  }

  void editGroceryListName(String newName, String id, String listCreatedDate) {
    deleteGroceryListName(id);
    addGroceryList(GroceryListModel(
        listId: id,
        listDescription: newName,
        listCreatedDate: listCreatedDate));
  }

  void deleteGroceryListName(index) {
    final result = state
        .where((element) => element.listId.toString() != index.toString())
        .toList();
    state = [...result];
  }

  String getListName() {
    String listName = '';

    for (var list in state) {
      listName = list.listDescription;
    }

    return listName;
  }

  String getListCreatedDate() {
    String listCreatedDate = '';

    for (var list in state) {
      listCreatedDate = list.listCreatedDate;
    }

    return listCreatedDate;
  }
}
