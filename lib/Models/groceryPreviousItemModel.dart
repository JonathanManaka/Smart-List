class GroceryPreviousItemModel {
  final String prevItemId;
  final double prevItemPrice;
  final int prevItemQnty;
  final String prevItemCreatedDate;
  final String prevItemCalcFk;

  GroceryPreviousItemModel(
      {required this.prevItemId,
      required this.prevItemPrice,
      required this.prevItemQnty,
      required this.prevItemCreatedDate,
      required this.prevItemCalcFk});
}
