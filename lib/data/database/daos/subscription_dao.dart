import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class SubscriptionDao {
  static const TABLE_NAME = "subscriptions";

  SubscriptionDao({@required Future<Database> database}) {
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
  static final columnActive = "active";

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
        "$columnActive ${DataBaseConstants.INTEGER}, "
        "$columnRenewalPeriod ${DataBaseConstants.TEXT}"
        ");";
  }

  ///Inserta una suscripción pasada como parámetro [subscription]
  ///en la base de datos
  ///devuelve el id de la suscripción guardada
  Future<int> insertSubscription({@required Subscription subscription}) async {
    final db = await _database;

    final result = await db.insert(
      TABLE_NAME,
      subscription.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return Future.value(result);
  }

  ///Obtiene de la base de datos todas las suscripciones
  ///guardadas, tanto activas como no activas
  Future<List<Subscription>> fetchAllSubscriptions() async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

    return List.generate(maps.length, (i) {
      return Subscription.fromMap(maps[i]);
    });
  }

  ///Obtiene todas las suscripciones hasta una fecha pasada
  ///por parámetro [untilAt]
  ///Retorna un futuro de una lista de suscripciones
  Future<List<Subscription>> fetchAllSubscriptionsUntil(
      {@required DateTime untilAt}) async {
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

  ///Obtiene los datos referentes a una suscripción no activa [subscription]
  Future<Subscription> fetchSubscription({@required Subscription subscription}) async {
    return _fetchSubscriptionData(subscription: subscription, isActive: false);
  }

  ///Obtiene los datos referentes a una suscripción activa [subscription]
  Future<Subscription> fetchActiveSubscription(
      {@required Subscription subscription}) async {
    return _fetchSubscriptionData(subscription: subscription, isActive: true);
  }

  Future<Subscription> _fetchSubscriptionData(
      {@required Subscription subscription, bool isActive}) async {
    final db = await _database;

    String whereString;
    if (isActive) {
      whereString = '$columnId == ? AND $columnActive == 1';
    } else {
      whereString = '$columnId == ?';
    }

    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: whereString,
      whereArgs: [subscription.id],
    );

    final result = List.generate(maps.length, (i) {
      return Subscription.fromMap(maps[i]);
    });
    if (result.length > 0) {
      return result.first;
    } else {
      return Future.value(null);
    }
  }

  ///Elimina una [subscription] pasada como parámetro de la base de datos
  ///Este borrado es lógico y no físico. Lo que se cambia es el estado del
  ///flag de activo de la suscripción de activo a no activo
  Future<bool> deleteSubscription({@required Subscription subscription}) async {
    final db = await _database;

    String whereString = '$columnId == ?';

    final result = await db.update(
      TABLE_NAME,
      subscription.toMap(),
      where: whereString,
      whereArgs: [subscription.id],
    );

    return result != 0;
  }
}
