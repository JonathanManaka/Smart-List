import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("CREATE TABLE list ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "listDescription TEXT,"
        "listCreatedDate TEXT"
        ")");
    await database.execute("CREATE TABLE item ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "itemDescription TEXT,"
        "itemQuantity INTEGER,"
        "listItemFK INTEGER, FOREIGN KEY (listItemFk) REFERENCES listName (id)"
        ")");

    await database.execute("CREATE TABLE previousItem ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "prevItemPrice TEXT,"
        "prevItemCreatedate TEXT,"
        "prevItemQuantity INTEGER,"
        "prevItemFK INTEGER, FOREIGN KEY (prevItemFK) REFERENCES listName (id)"
        ")");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('smartShoppingList.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //This method creates new List
  static Future<int> createList(
      String listDescription, String createdDate) async {
    final db = await SQLHelper.db();

    final data = {
      'listDescription': listDescription,
      'listCreatedDate': createdDate,
    };
    final id = await db.insert('list', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Update List Name
  static Future<void> updateListName(int id, String title) async {
    final db = await SQLHelper.db();

    final data = {'listDescription': title};

    await db.update('list', data, where: "id = ?", whereArgs: [id]);
  }

  //Delete List
  static Future<void> deleteList(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("list", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong while deleting the List: $err");
    }
  }

  //This method created new item
  static Future<void> createItem(
      String itemDescription, String listFK, int itemQuantity) async {
    final db = await SQLHelper.db();
    final data = {
      'itemDescription': itemDescription,
      'itemQuantity': itemQuantity,
      'listItemFK': int.parse(listFK),
    };
    db.insert('item ', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

//Create previous items
  static Future<void> createPreviousItem(String prevPrice,
      String prevCreatedDate, int prevFk, int prevQnty) async {
    final db = await SQLHelper.db();
    final data = {
      'prevItemPrice': prevPrice,
      'prevItemCreatedate': prevCreatedDate,
      'prevItemFK': prevFk,
      'prevItemQuantity': prevQnty
    };
    db.insert('previousItem', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> selectAllPreviousItems() async {
    final db = await SQLHelper.db();
    return db.query('previousItem');
  }

  //Select only prevItemPrice by Id
  static Future<List<Map<String, dynamic>>> selectPrevItemPrice(int fk) async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        'SELECT prevItemPrice FROM previousItem WHERE prevItemFK=?', [fk]);
  }
  //Selecting only prevItemQuantity

  static Future<List<Map<String, dynamic>>> selectPrevItemQuantity(
      int fk) async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        'SELECT prevItemQuantity FROM previousItem WHERE prevItemFK=?', [fk]);
  }

  //Select only prevItemCreatedDate by id
  static Future<List<Map<String, dynamic>>> selectPrevItemCreatedDate(
      int fk) async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        'SELECT prevItemCreatedate FROM previousItem WHERE prevItemFK=?', [fk]);
  }

  //Detele items
  static Future<void> deleteItems(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("item", where: "listItemFK = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong while deleting an item: $err");
    }
  }

  //Delete PreItem
  static Future<void> deletePrevItems(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("previousItem", where: "prevItemFK = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong while deleting an Previous item: $err");
    }
  }

  //Reading item where Fk is equal to the list PK
  static Future<List<Map<String, dynamic>>> getItemByListFk(int fk) async {
    final db = await SQLHelper.db();
    return db.rawQuery('SELECT * FROM item WHERE listItemFK=?', [fk]);
  }

  //Selecting all Lists form list table
  static Future<List<Map<String, dynamic>>> selectAllLists() async {
    final db = await SQLHelper.db();
    return db.query('list');
  }

  //Delete all the lists
  static Future<int> deleteAllLists() async {
    final db = await SQLHelper.db();
    int result = 0;
    try {
      result = await db.delete("list");
    } catch (err) {
      debugPrint("Something went wrong while deleting a list: $err");
    }
    return result;
  }

  //Delete all the items

  static Future<int> deleteAllItems() async {
    final db = await SQLHelper.db();
    int result = 0;
    try {
      result = await db.delete("item");
    } catch (err) {
      debugPrint("Something went wrong while deleting an item: $err");
    }
    return result;
  }

  //Delete all previous items
  static Future<int> deleteAllPrevItems() async {
    final db = await SQLHelper.db();
    int result = 0;
    try {
      result = await db.delete("previousItem");
    } catch (err) {
      debugPrint("Something went wrong while deleting an Previous item: $err");
    }
    return result;
  }

  //Deleting previousItems by Fk
  static Future<void> deletePrevItemsByFk(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("previousItem", where: "prevItemFK = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong while deleting an previousItem: $err");
    }
  }

//Select single list by id
  static Future<List<Map<String, dynamic>>> selectOneList(var id) async {
    final db = await SQLHelper.db();
    return db.query('list', where: "id = ?", whereArgs: [id]);
  }
}
