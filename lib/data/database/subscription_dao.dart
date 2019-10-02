import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class SubscriptionDao {
  static const TABLE_NAME = "subscriptions";

  SubscriptionDao(Future<Database> database) {
    this._database = database;
  }

  Future<Database> _database;

  static final columnId = "id";
  static final columnName = "name";
  static final columnDescription = "description";
  static final columnPrice = "price";
  static final columnFirstBill = "first_bill";
  static final columnColor = "color";
  static final columnRenewal = "renewal";
  static final columnRenewalPeriod = "renewal_period";

  static String createSubscriptionTable() {
    return "CREATE TABLE ${SubscriptionDao.TABLE_NAME} "
        "("
        "$columnId ${DataBaseConstants.INTEGER} ${DataBaseConstants.PRIMARY_KEY}, "
        "$columnName ${DataBaseConstants.TEXT}, "
        "$columnDescription ${DataBaseConstants.TEXT}, "
        "$columnPrice ${DataBaseConstants.REAL}, "
        "$columnFirstBill ${DataBaseConstants.INTEGER}, "
        "$columnColor ${DataBaseConstants.INTEGER}, "
        "$columnRenewal ${DataBaseConstants.INTEGER}, "
        "$columnRenewalPeriod ${DataBaseConstants.TEXT}"
        ");";
  }

  Future<int> insertSubscription(Subscription subscription) async {
    final db = await _database;

    final result = await db.insert(
      TABLE_NAME,
      subscription.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return Future.value(result);
  }

  Future<List<Subscription>> fetchAllSubscriptionsUntil(
      {DateTime untilAt}) async {
    final db = await _database;

    String whereString = '$columnFirstBill < ?';

    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: whereString,
      whereArgs: [untilAt.millisecondsSinceEpoch],
    );

    return List.generate(maps.length, (i) {
      return Subscription.fromMap(maps[i]);
    });
  }

//  Future<void> updateDog(Subscription subscription) async {
//    // Get a reference to the database.
//    final db = await database;
//
//    // Update the given Dog.
//    await db.update(
//      'dogs',
//      dog.toMap(),
//      // Ensure that the Dog has a matching id.
//      where: "id = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [dog.id],
//    );
//  }
//
//  Future<void> deleteDog(int id) async {
//    // Get a reference to the database.
//    final db = await database;
//
//    // Remove the Dog from the database.
//    await db.delete(
//      'dogs',
//      // Use a `where` clause to delete a specific dog.
//      where: "id = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [id],
//    );
//  }

}
