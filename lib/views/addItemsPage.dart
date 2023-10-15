import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/Models/groceryListItemModel.dart';
import 'package:smart_grocery_list/routes/app_router.dart';
import 'package:smart_grocery_list/styles/colorPalette.dart';
import 'package:smart_grocery_list/Models/groceryListModel.dart';
import 'package:smart_grocery_list/main.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smart_grocery_list/utils/groceryListModelData.dart';
import 'package:smart_grocery_list/views/HomePage.dart';

@RoutePage()
class AddItemsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsKey = GlobalKey<FormState>();
    TextEditingController groceryListItemNameCntr = TextEditingController();
    String listName = ref.read(groceryListProvider.notifier).getListName();
    String listCreateDate =
        ref.read(groceryListProvider.notifier).getListCreatedDate();

    List<GroceryListItemModel> groceryItems =
        ref.watch(groceryListItemProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          listName,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () async {
                  //Add List Details from groceryListProvider to groceryListDataProvider
                  int id = await ref
                      .read(groceryListDataProvider.notifier)
                      .addListToDb(listName, listCreateDate, ref);

                  print('Id Is : $id');
                  for (var items in groceryItems) {
                    ref.read(groceryListItemProvider.notifier).additemsToDb(
                        id, items.listItemDescription, items.listItemQuantity);
                  }
                  ref
                      .read(groceryListDataProvider.notifier)
                      .getListsFromDb(ref);
                  context.router.replace(HomeRoute());
                },
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/SaveList.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ))
        ],
        backgroundColor: Palette.PrimaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: groceryItems.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          //Grocery List Card
                          Container(
                            height: 65,
                            width: 370,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Palette.shadeColor),
                            child: Row(children: [
                              //Expaned Pre-info
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    groceryItems[index].listItemDescription,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black87),
                                  ),
                                  Text(
                                    groceryItems[index]
                                        .listItemQuantity
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black87),
                                  ),
                                ],
                              )), //End of Expanded Pre-info

                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: InkWell(
                                    onTap: () {
                                      String selectedId =
                                          groceryItems[index].listItemID;
                                      print(selectedId);
                                      ref
                                          .read(
                                              groceryListItemProvider.notifier)
                                          .deleteGroceryListItem(selectedId);
                                    },
                                    child: Image.asset(
                                      'assets/deleteItem.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          )
                          //End of grocery list card
                        ],
                      )))),
          //Edding Grocery List Item Section
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  child: SingleChildScrollView(
                    child: Form(
                      key: itemsKey,
                      child: Column(
                        children: [
                          TextFormField(
                            maxLength: 25,
                            controller: groceryListItemNameCntr,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide the description of your item';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Enter Item Name',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Palette.PrimaryColor),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 2)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                //Turning the off the hint-label when entering text
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.black54,
                                    )),
                          ),
                          //Label
                          Text('Quantity'),
                          //Increment or decrement quantity Section
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              height: 30,
                              child: Row(
                                children: [
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Decrement button
                                  Flexible(
                                      child: Container(
                                          decoration: BoxDecoration(),
                                          margin: EdgeInsets.only(left: 20),
                                          child: Consumer(
                                              builder: (context, ref, child) {
                                            int quantityDecreVal =
                                                ref.watch(quantityProvider);
                                            return InkWell(
                                              splashColor: Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              onTap: () {
                                                if (quantityDecreVal < 2) {
                                                  ref
                                                      .read(quantityProvider
                                                          .notifier)
                                                      .state = 1;
                                                } else {
                                                  ref
                                                      .read(quantityProvider
                                                          .notifier)
                                                      .state--;
                                                }
                                              },
                                              child: Container(
                                                height: 17.61,
                                                width: 20,
                                                child: Image.asset(
                                                    'assets/decrementBtn.png'),
                                              ),
                                            );
                                          }))),
                                  Spacer(flex: 1),
                                  //Quantity Box
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Center(child: Consumer(
                                            builder: (context, ref, child) {
                                          int quantityValue =
                                              ref.watch(quantityProvider);
                                          return Text(
                                            '$quantityValue',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.black),
                                          );
                                        }))),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  //Increment button
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: InkWell(
                                        splashColor: Colors.green[100],
                                        borderRadius: BorderRadius.circular(15),
                                        onTap: () {
                                          ref
                                              .read(quantityProvider.notifier)
                                              .state++;
                                        },
                                        child: Container(
                                          height: 17.61,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/incrementBtn.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          //End of Increment or decrement quantity Section****************
                          //Add item to state button
                          Container(
                              width: 50,
                              height: 50,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                splashColor: Palette.PrimaryColor,
                                onTap: () {
                                  if (itemsKey.currentState!.validate()) {
                                    int tempId = ref.read(iDCountProvider);
                                    String itemDescription =
                                        groceryListItemNameCntr.text;
                                    int itemQuantity =
                                        ref.read(quantityProvider);
                                    //Save list to GrocerylistItem State
                                    ref
                                        .read(groceryListItemProvider.notifier)
                                        .addGroceryListItem(
                                            GroceryListItemModel(
                                                listItemID: tempId.toString(),
                                                listItemDescription:
                                                    itemDescription,
                                                listItemQuantity: itemQuantity,
                                                listFk: '0'));
                                    ref.read(iDCountProvider.notifier).state++;
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white10,
                                  child:
                                      Image.asset('assets/addItemToState.png'),
                                ),
                              )),
                          //End of Add item to state button***************
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          //Save Grocery List and Item Button
        ],
      )),
    );
  }
}
