class GroceryItemCalculatorModel {
  final String itemDescription;
  final String itemCalcId;
  final double itemCalcPrice;
  final int itemQuantity;
  final String itemCalcFk;

  GroceryItemCalculatorModel({
    required this.itemDescription,
    required this.itemCalcId,
    required this.itemCalcPrice,
    required this.itemCalcFk,
    required this.itemQuantity,
  });
}
