import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smart_grocery_list/main.dart';
import 'package:smart_grocery_list/routes/app_router.dart';
import 'package:smart_grocery_list/styles/colorPalette.dart';

@RoutePage()
class GroceryItemCalculatorPage extends ConsumerWidget {
  final String titleName;
  GroceryItemCalculatorPage({Key? key, required this.titleName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsCalculate = ref.watch(groceryListItemCalculatorProvider);
    double budget = ref.watch(budgetProvider);
    double budgetLeft = ref.watch(budgetLeftProvider);
    double total = ref.watch(totalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            titleName,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        //Open Update Budget Dialog
        actions: <Widget>[
          InkWell(
            splashColor: Palette.PrimaryColor,
            onTap: () {
              openBudgetDialog(context, ref);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                child: Image.asset('assets/Budget button.png'),
              ),
            ),
          )
        ],
        backgroundColor: Palette.PrimaryColor,
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: itemsCalculate.length,
                  itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          //Grocery List Card
                          InkWell(
                            onTap: () async {
                              int selectedItemId =
                                  int.parse(itemsCalculate[index].itemCalcId);
                              String selectedItemName =
                                  itemsCalculate[index].itemDescription;

                              String prevItemCreatedDate = await ref
                                  .read(groceryPreviousItemProvider.notifier)
                                  .getPrevItemCreatedDateFromDb(selectedItemId);
                              double prevItemPrice = await ref
                                  .read(groceryPreviousItemProvider.notifier)
                                  .getPreviousItemPriceFromDb(selectedItemId);
                              openItemPriceDialog(
                                  context,
                                  ref,
                                  selectedItemId,
                                  selectedItemName,
                                  prevItemCreatedDate,
                                  prevItemPrice);
                            },
                            child: Container(
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
                                      itemsCalculate[index].itemDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black87),
                                    ),
                                    Text(
                                      '${itemsCalculate[index].itemQuantity.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black87),
                                    ),
                                  ],
                                )), //End of Expanded Pre-info

                                //ItemPrice section
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(left: 115),
                                  child: Text(
                                      itemsCalculate[index]
                                          .itemCalcPrice
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.black)),
                                ))
                              ]),
                            ),
                          )
                          //End of grocery list card
                        ],
                      )))),
          Flexible(
              child: Container(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.PrimaryColor,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white)),
              onPressed: () async {
                //Calculate the total itemPrices of the previous items
                double prevItemsTotal = await ref
                    .read(groceryPreviousItemProvider.notifier)
                    .calcTotalPrevItemPrice(itemsCalculate);
                //Calling saveCalItems to save calculated items
                // to previousItems state to be later stored to db
                ref
                    .read(groceryPreviousItemProvider.notifier)
                    .saveCalItems(itemsCalculate, ref);
                //This function will take information in state and store it to the db
                ref
                    .read(groceryPreviousItemProvider.notifier)
                    .savePrevItemsToDb();

                double change = ref
                        .read(groceryListItemCalculatorProvider.notifier)
                        .roundDouble(prevItemsTotal - ref.read(totalProvider)) *
                    1;
                String message = '';
                print(change);

                if (prevItemsTotal == 0) {
                  message = 'You spent ${ref.read(totalProvider)}';
                } else {
                  if (ref.read(totalProvider) < prevItemsTotal) {
                    message = 'You saved : $change on this grocery';
                  } else if (ref.read(totalProvider) > prevItemsTotal) {
                    message = 'You lost $change on this grocery..';
                  } else if (ref.read(totalProvider) == prevItemsTotal) {
                    message = 'Your shopping';
                  }
                }

                // ignore: use_build_context_synchronously
                openMessageDiaglog(context, message, ref);
              },
              child: Text(
                'Save',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.white),
              ),
            ),
          )),
          //Footer Display
          Flexible(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    //Budget Display
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(3.2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Palette.PrimaryColor, width: 2)),
                              child: Text('Budget:  $budget'),
                            ))),
                    //Budget left
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(3.2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: Colors.red, width: 2)),
                              child: Text('Budget left: $budgetLeft'),
                            ))),
                    //Total
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(3.2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.green, width: 2)),
                              child: Text('Total: $total'),
                            )))
                  ],
                ),
              ))
        ],
      )),
    );
  }

  void openMessageDiaglog(BuildContext context, message, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
          ),
          content: ElevatedButton.icon(
              onPressed: () {
                ref.read(totalProvider.notifier).state = 0.0;
                ref.read(budgetLeftProvider.notifier).state = 0.0;

                context.router.push(HomeRoute());
              },
              icon: Icon(Icons.done),
              label: Text(''))),
    );
  }

  void openBudgetDialog(BuildContext context, WidgetRef ref) {
    TextEditingController groceryBugdet = TextEditingController();

    final budgetKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Container(
                child: Image.asset('assets/budgetIcon.png'),
              )),
              content: SingleChildScrollView(
                child: Form(
                  key: budgetKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: groceryBugdet,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Provide your budget';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter your Budget',
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
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Save list button for future comparison
                      Container(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Palette.PrimaryColor),
                            onPressed: () {
                              if (budgetKey.currentState!.validate()) {
                                String budget = groceryBugdet.text;
                                //Updating budget
                                ref.read(budgetProvider.notifier).state =
                                    double.parse(budget);
                                //Refreshing budget left
                                ref.read(budgetLeftProvider.notifier).state =
                                    ref.read(budgetProvider.notifier).state -
                                        ref.read(totalProvider.notifier).state;
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Save Budget',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  //Item price Dialog
  void openItemPriceDialog(BuildContext context, WidgetRef ref, int itemId,
      String itemName, String prevCreatedDate, double prevPrice) {
    TextEditingController itemPriceCntr = TextEditingController();

    final itemPriceKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Container(
                      child: Column(
                children: [
                  Text(
                    itemName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    'Last Purchase Date: $prevCreatedDate',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  Text('Last Purchase price: $prevPrice',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.red)),
                ],
              ))),
              content: SingleChildScrollView(
                child: Form(
                  key: itemPriceKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: itemPriceCntr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Provide item price';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter item price',
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
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Save list button for future comparison
                      Container(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Palette.PrimaryColor),
                            onPressed: () {
                              double itemPrice =
                                  double.parse(itemPriceCntr.text);

                              if (itemPriceKey.currentState!.validate()) {
                                ref
                                    .read(groceryListItemCalculatorProvider
                                        .notifier)
                                    .updateItemPrice(itemId, itemPrice);
                              }
                              //Get total items and update the total state
                              ref.read(totalProvider.notifier).state = ref
                                  .read(groceryListItemCalculatorProvider
                                      .notifier)
                                  .getTotalItems();

                              //Refreshing the budget left
                              ref.read(budgetLeftProvider.notifier).state =
                                  ref.read(budgetProvider.notifier).state -
                                      ref.read(totalProvider.notifier).state;

                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save price',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
