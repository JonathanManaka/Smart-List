class GroceryListItemModel {
  final String listItemID;
  final String listItemDescription;
  final int listItemQuantity;
  final String listFk;

  GroceryListItemModel(
      {required this.listItemID,
      required this.listItemDescription,
      required this.listItemQuantity,
      required this.listFk});
}
