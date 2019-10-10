import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class PaymentDao {
  static const TABLE_NAME = "payments";

  PaymentDao(Future<Database> database) {
    this._database = database;
  }

  Future<Database> _database;

  static final columnId = "id";
  static final columnRenewalId = "renewal_id";
  static final columnSubscriptionId = "subscription_id";
  static final columnPrice = "price";
  static final columnRenewalAt = "renewal_at";
  static final columnInsertAt = "insert_at";

  static String createPaymentTable() {
    return "CREATE TABLE ${PaymentDao.TABLE_NAME} "
        "("
        "$columnId ${DataBaseConstants.INTEGER} ${DataBaseConstants.PRIMARY_KEY}, "
        "$columnRenewalId ${DataBaseConstants.INTEGER}, "
        "$columnSubscriptionId ${DataBaseConstants.INTEGER}, "
        "$columnPrice ${DataBaseConstants.REAL}, "
        "$columnRenewalAt ${DataBaseConstants.INTEGER}, "
        "$columnInsertAt ${DataBaseConstants.INTEGER}"
        ");";
  }

  Future<int> insertPayment(Payment payment) async {
    final db = await _database;

    final result = await db.insert(
      TABLE_NAME,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return Future.value(result);
  }

//  Future<List<Payment>> fetchAllPaymentsUntil(
//      {DateTime untilAt}) async {
//    final db = await _database;
//
//    String whereString = '$columnFirstBill < ?';
//
//    final List<Map<String, dynamic>> maps = await db.query(
//      TABLE_NAME,
//      where: whereString,
//      whereArgs: [untilAt.millisecondsSinceEpoch],
//    );
//
//    return List.generate(maps.length, (i) {
//      return Subscription.fromMap(maps[i]);
//    });
//  }
//
  Future<List<Payment>> fetchPaymentsBySubscriptions(
      {Subscription subscription}) async {
    final db = await _database;

    String whereString =
        '$columnSubscriptionId == ? ORDER BY $columnInsertAt ASC';

    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: whereString,
      whereArgs: [subscription.id],
    );

    return List.generate(maps.length, (i) {
      return Payment.fromMap(maps[i]);
    });
  }

  Future<Payment> fetchLastPaymentBySubscriptions(
      {Subscription subscription}) async {
    final payments =
        await fetchPaymentsBySubscriptions(subscription: subscription);
    try {
      return Future.value(payments.last);
    } catch (iterableElementError) {
      return Future.value(Payment());
    }
  }
}
