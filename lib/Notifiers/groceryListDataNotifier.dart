import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/main.dart';

import 'package:smart_grocery_list/utils/groceryListModelData.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

class GroceryListDataNotifier
    extends StateNotifier<List<GroceryListModelData>> {
  GroceryListDataNotifier() : super([]);

  void addGroceryListData(GroceryListModelData groceryListModelData) {
    //Using dart spread operator to add groceryList
    state = [...state, groceryListModelData];
  }

  void getListsFromDb(WidgetRef ref) async {
    ref.read(groceryListDataProvider).clear();
    List<Map<String, dynamic>> data = await SQLHelper.selectAllLists();

    for (var lists in data) {
      int id = lists['id'];
      String listDesc = lists['listDescription'];
      String listCreatedDate = lists['listCreatedDate'];

      addGroceryListData(GroceryListModelData(
          listCreateDateData: listCreatedDate,
          listDescriptionData: listDesc,
          listIdData: id.toString()));
    }
  }

  Future<int> addListToDb(
      String listName, String listCreatedDate, WidgetRef ref) async {
    var id = await SQLHelper.createList(listName, listCreatedDate);
    return id;
  }

  void updatList(int id, String newTitle) async {
    await SQLHelper.updateListName(id, newTitle);
  }

  void deleteListFromDb(int id) async {
    await SQLHelper.deleteList(id).whenComplete(() {
      print('Done deleting lists');
    });
  }

  void deleteItemFromDb(int id) async {
    await SQLHelper.deleteItems(id).whenComplete(() {
      print('Done deleting item');
    });
  }
}
