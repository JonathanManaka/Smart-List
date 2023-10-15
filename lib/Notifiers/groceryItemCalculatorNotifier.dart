import 'dart:math';
import 'package:riverpod/riverpod.dart';
import 'package:smart_grocery_list/Models/groceryItemCalculatorModel.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

class GroceryItemNotifier
    extends StateNotifier<List<GroceryItemCalculatorModel>> {
  GroceryItemNotifier() : super([]);

  void addItems(GroceryItemCalculatorModel groceryItemCalculatorModel) {
    state = [...state, groceryItemCalculatorModel];
  }

  void getItemFromDb(int listId) async {
    List<Map<String, dynamic>> data = await SQLHelper.getItemByListFk(listId);

    for (var items in data) {
      String id = items['id'].toString();
      int quantity = items['itemQuantity'];

      addItems(GroceryItemCalculatorModel(
          itemDescription: items['itemDescription'],
          itemCalcId: id,
          itemCalcPrice: 0.00,
          itemCalcFk: listId.toString(),
          itemQuantity: quantity));
    }
  }

  void updateItemPrice(int itemId, double newPrice) {
    String tempItemDescription = '';
    String tempItemCalcId = '';
    String tempItemCalcFk = '';
    int tempItemQuantity = 0;

    for (var items in state) {
      if (int.parse(items.itemCalcId) == itemId) {
        tempItemDescription = items.itemDescription;
        tempItemCalcId = items.itemCalcId;
        tempItemCalcFk = items.itemCalcFk;
        tempItemQuantity = items.itemQuantity;
      }
    }
    //Add all the items except the one with the same Id passed in this method
    final result = state
        .where((element) => int.parse(element.itemCalcId) != itemId)
        .toList();
    state = [...result];
    //Calling addItems method to add the item with the new price
    addItems(GroceryItemCalculatorModel(
        itemDescription: tempItemDescription,
        itemCalcId: tempItemCalcId,
        itemCalcPrice: newPrice,
        itemCalcFk: tempItemCalcFk,
        itemQuantity: tempItemQuantity));
  }

//This function returns the total of all the item prices
  double getTotalItems() {
    double total = 0.0;
    for (var items in state) {
      total += items.itemCalcPrice;
    }
    return total;
  }

  //This function rounds to two decimal places
  double roundDouble(double val) {
    num mod = pow(10.0, 2);
    return ((val * mod).round().toDouble() / mod);
  }
}
