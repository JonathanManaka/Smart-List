import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/Models/groceryPreviousItemModel.dart';
import 'package:smart_grocery_list/Models/groceryItemCalculatorModel.dart';
import 'package:intl/intl.dart';
import 'package:smart_grocery_list/main.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

class GroceryPreviousItemNotifie
    extends StateNotifier<List<GroceryPreviousItemModel>> {
  GroceryPreviousItemNotifie() : super([]);

  void addPreviousItem(GroceryPreviousItemModel groceryPreviousItemModel) {
    state = [...state, groceryPreviousItemModel];
  }

  void saveCalItems(List<GroceryItemCalculatorModel> calcItems, WidgetRef ref) {
    var now = DateTime.now();
    var nowDateFormatter = DateFormat('yyyy-MM-dd');
    String formattedItemNowDate = nowDateFormatter.format(now);
    ref.read(groceryPreviousItemProvider).clear();
    for (var items in calcItems) {
      addPreviousItem(GroceryPreviousItemModel(
          prevItemId: '',
          prevItemPrice: items.itemCalcPrice,
          prevItemQnty: items.itemQuantity,
          prevItemCreatedDate: formattedItemNowDate,
          prevItemCalcFk: items.itemCalcId));
    }
  }

//This function deletes all previous items by Fk Which matches the id of the calculated items
  void deletePreviousItemsbyIDFromDb(int id) async {
    await SQLHelper.deletePrevItemsByFk(id);
  }

//This method will first delete the previous item to create only one is to one relationship between
//previousItem and the current calculated item
  void savePrevItemsToDb() async {
    for (var prevItems in state) {
      int id = int.parse(prevItems.prevItemCalcFk);

      deletePreviousItemsbyIDFromDb(id);
      await SQLHelper.createPreviousItem(
          prevItems.prevItemPrice.toString(),
          prevItems.prevItemCreatedDate,
          int.parse(prevItems.prevItemCalcFk),
          prevItems.prevItemQnty);
    }
  }

  Future<double> getPreviousItemPriceFromDb(int id) async {
    List<Map<String, dynamic>> prevItems =
        await SQLHelper.selectPrevItemPrice(id);
    double prevItemPrice = 0.00;
    if (prevItems.isNotEmpty) {
      for (var previousItems in prevItems) {
        prevItemPrice = double.parse(previousItems['prevItemPrice']);
      }
    }

    return prevItemPrice;
  }

  //Get previous Item quantity from db
  Future<int> getPreviousItemQntyFromDb(int id) async {
    List<Map<String, dynamic>> prevItems =
        await SQLHelper.selectPrevItemQuantity(id);
    int prevItemQnty = 0;
    if (prevItems.isNotEmpty) {
      for (var previousItems in prevItems) {
        prevItemQnty = previousItems['prevItemQuantity'];
      }
    }

    return prevItemQnty;
  }

  Future<String> getPrevItemCreatedDateFromDb(int id) async {
    List<Map<String, dynamic>> prevItems =
        await SQLHelper.selectPrevItemCreatedDate(id);
    String prevItemCreatedDate = '';
    if (prevItems.isNotEmpty) {
      for (var previousItems in prevItems) {
        prevItemCreatedDate = previousItems['prevItemCreatedate'];
      }
    }

    return prevItemCreatedDate;
  }

  Future<double> calcTotalPrevItemPrice(
      List<GroceryItemCalculatorModel> calcItems) async {
    double total = 0.0;
    for (var items in calcItems) {
      double itemPrice =
          await getPreviousItemPriceFromDb(int.parse(items.itemCalcId));
      int itemQnty =
          await getPreviousItemQntyFromDb(int.parse(items.itemCalcId));
      print(itemQnty);
      double priceTot = itemPrice * itemQnty;
      total += priceTot;
    }
    return total;
  }
}
