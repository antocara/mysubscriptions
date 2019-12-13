import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/amount_payments_year.dart';
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

  ///Guarda un pago [payment] en base de datos
  Future<int> insertPayment({@required Payment payment}) async {
    final db = await _database;

    final result = await db.insert(
      TABLE_NAME,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return Future.value(result);
  }

  ///Obtiene todos los pagos pertenecientes a una suscripción [subscription]
  ///ordenados de forma ascendente
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

  ///Obtiene el último pago que exista en base de datos por una [subscription] dada
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

  ///Obtiene un listado de pagos entre dos fechas [starDate] y [endDate] ordenados
  ///según el parámetro [sortBy]
  Future<List<Payment>> fetchPaymentsBetween(
      {DateTime starDate, DateTime endDate, @required SortBy sortBy}) async {
    final db = await _database;

    String whereString =
        '$columnRenewalAt >= ? AND $columnRenewalAt <= ? ORDER BY $columnRenewalAt ${_sortBy(sortBy)}';

    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: whereString,
      whereArgs: [
        starDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch
      ],
    );

    return List.generate(maps.length, (i) {
      return Payment.fromMap(maps[i]);
    });
  }

  ///Obtiene todos los pagos agrupados por año
  Future<List<List<AmountPaymentsYear>>>
      fetchAllPaymentsGroupedByYears() async {
    final db = await _database;

    String date = "DATETIME(ROUND($columnRenewalAt / 1000), 'unixepoch')";
    String selectYear = "strftime('%Y',$date)";
    String query = "SELECT distinct($selectYear) as 'year' FROM $TABLE_NAME ";

    final List<Map> queryResult = await db.rawQuery(query);

    var data = queryResult.map((result) async {
      final year = result['year'];
      return await _selectAmountPaymentsByYear(year);
    });

    return Future.wait(data);
  }

  /// Recupera los pagos realizados de cada susbcripción por año
  /// y obtiene el total de estos pagos anuales
  Future<List<AmountPaymentsYear>> _selectAmountPaymentsByYear(
      String year) async {
    final db = await _database;

    String date = "DATETIME(ROUND($columnRenewalAt / 1000), 'unixepoch')";
    String selectYear = "strftime('%Y',$date)";

    String query =
        "SELECT sum($columnPrice) as 'amount', $columnSubscriptionId FROM $TABLE_NAME WHERE $selectYear = '$year' GROUP BY $columnSubscriptionId";

    final List<Map> maps = await db.rawQuery(query);

    return List.generate(maps.length, (i) {
      final amountPayment = AmountPaymentsYear.fromMap(maps[i]);
      amountPayment.year = year;
      return amountPayment;
    });
  }

  String _sortBy(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.ASC:
        return "ASC";
      case SortBy.DESC:
        return "DESC";
    }
    return "";
  }
}

enum SortBy { ASC, DESC }
