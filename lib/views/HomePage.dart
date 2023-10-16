import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_grocery_list/Models/groceryListModel.dart';

import 'package:smart_grocery_list/main.dart';
import 'package:smart_grocery_list/routes/app_router.dart';
import 'package:smart_grocery_list/styles/colorPalette.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smart_grocery_list/utils/database_helper.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groceryList = ref.watch(groceryListDataProvider);

    int tempID = 0;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          child: InkWell(
            splashColor: Palette.PrimaryColor,
            onTap: () {
              ref.read(groceryListDataProvider.notifier).getListsFromDb(ref);
            },
            child: Image.asset(
              'assets/reload.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          'Shopping Lists',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Palette.PrimaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: groceryList.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: InkWell(
                        onTap: () {
                          int id = int.parse(groceryList[index].listIdData);
                          ref.read(groceryListItemCalculatorProvider).clear();
                          ref
                              .read(groceryListItemCalculatorProvider.notifier)
                              .getItemFromDb(id);
                          context.router.push(GroceryItemCalculatorRoute(
                              title: groceryList[index].listDescriptionData));
                          ref.read(budgetProvider.notifier).state = 0.0;
                          ref.read(budgetLeftProvider.notifier).state = 0.0;
                          ref.read(totalProvider.notifier).state = 0.0;
                        },
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
                                      groceryList[index].listDescriptionData,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black87),
                                    ),
                                    Text(
                                      groceryList[index].listCreateDateData,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.black87),
                                    )
                                  ],
                                )), //End of Expanded Pre-info

                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: InkWell(
                                      onTap: () {
                                        String oldGroceryListName =
                                            groceryList[index]
                                                .listDescriptionData;
                                        String listId =
                                            groceryList[index].listIdData;

                                        openEditGListDscrDialog(
                                            context,
                                            int.parse(listId),
                                            oldGroceryListName,
                                            ref);
                                      },
                                      child: Image.asset(
                                        'assets/groceryListedtBtn.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                /** 
                                * Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: InkWell(
                                      onTap: () {
                                        SQLHelper.deleteAllLists();
                                        SQLHelper.deleteAllItems();
                                        SQLHelper.deleteAllPrevItems();
                                      },
                                      child: Image.asset(
                                        'assets/groceryListAnalysisbtn.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                * */
                              ]),
                            )
                            //End of grocery list card
                          ],
                        ),
                      )))),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCreateListDscDialog(context, ref, tempID);
        },
        child: Container(
          child: Image.asset('assets/creatListIcon.png'),
        ),
        splashColor: Palette.PrimaryColor,
      ),
    );
  }

//ShowDialog for creating new Grocery List Name***************************************
  void openCreateListDscDialog(
      BuildContext context, WidgetRef ref, int tempID) {
    TextEditingController groceryListNameCntr = TextEditingController();
    final _newTitleKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Create New Title',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _newTitleKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter new title';
                          } else {
                            return null;
                          }
                        },
                        maxLength: 25,
                        controller: groceryListNameCntr,
                        decoration: InputDecoration(
                            labelText: 'Enter new Grocery List Name',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Palette.PrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Palette.PrimaryColor, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.red)),
                            //Turning the off the hint-label when entering text
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            labelStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    )),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Palette.PrimaryColor),
                            onPressed: () {
                              final String groceryListDescription =
                                  groceryListNameCntr.text;
                              if (_newTitleKey.currentState!.validate()) {
                                var now = DateTime.now();
                                var nowDateFormatter = DateFormat('yyyy-MM-dd');
                                String formattedNowDate =
                                    nowDateFormatter.format(now);

                                ref
                                    .read(groceryListProvider.notifier)
                                    .addGroceryList(GroceryListModel(
                                        listId: '0',
                                        listDescription: groceryListDescription,
                                        listCreatedDate: formattedNowDate));
                                ref.read(groceryListItemProvider).clear();
                                context.router.push(const AddItemsRoute());
                              }
                            },
                            child: Text(
                              'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

//Grocery List Description Edit Dialog ************************************
  void openEditGListDscrDialog(
      BuildContext context, int id, String oldGroceryListName, WidgetRef ref) {
    TextEditingController groceryListNameCntr = TextEditingController();
    groceryListNameCntr.text = oldGroceryListName;
    final newListKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  'Edit Grocery List Name',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: newListKey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 25,
                        controller: groceryListNameCntr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Provide Grocery List Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter new Grocery List Name',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Palette.PrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Palette.PrimaryColor, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.red)),
                            //Turning the off the hint-label when entering text
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            labelStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    )),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Palette.PrimaryColor),
                            onPressed: () {
                              String newName = groceryListNameCntr.text;
                              if (newName != '') {
                                ref
                                    .read(groceryListDataProvider.notifier)
                                    .updatList(id, newName);
                                ref
                                    .read(groceryListDataProvider.notifier)
                                    .getListsFromDb(ref);
                              }

                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save changes',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: () {
                              ref
                                  .read(groceryListDataProvider.notifier)
                                  .deleteListFromDb(id);
                              ref
                                  .read(groceryListDataProvider.notifier)
                                  .deleteItemFromDb(id);

                              ref
                                  .read(groceryListDataProvider.notifier)
                                  .getListsFromDb(ref);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Delete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.red),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
