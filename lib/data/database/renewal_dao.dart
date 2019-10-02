import 'package:sqflite/sqflite.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class RenewalDao {
  static const TABLE_NAME = "renewals";

  RenewalDao(Future<Database> database) {
    this._database = database;
  }

  Future<Database> _database;

  static final columnId = "id";
  static final columnSubscriptionId = "subscription_id";
  static final columnRenewalAt = "renewal_at";

  static String createRenewalTable() {
    return "CREATE TABLE ${RenewalDao.TABLE_NAME} "
        "("
        "$columnId ${DataBaseConstants.INTEGER} ${DataBaseConstants.PRIMARY_KEY}, "
        "$columnSubscriptionId ${DataBaseConstants.INTEGER}, "
        "$columnRenewalAt ${DataBaseConstants.INTEGER}"
        ");";
  }

  Future<bool> insertRenewal(Renewal renewal) async {
    final db = await _database;

    final result = await db.insert(
      TABLE_NAME,
      renewal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return Future.value(result == 1 ? true : false);
  }

  Future<List<Renewal>> fetchAllRenewalBy({Subscription subscription}) async {
    final db = await _database;

    String whereString = '$columnSubscriptionId = ?';

    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: whereString,
      whereArgs: [subscription.id],
    );

    return List.generate(maps.length, (i) {
      return Renewal.fromMap(maps[i]);
    });
  }
}
