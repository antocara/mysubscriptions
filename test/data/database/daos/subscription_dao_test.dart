import 'package:flutter_test/flutter_test.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_TEST_NAME = "database_test";

void main() {
//  final subscriptionNameTest = "Antonio_test";
//
//  SubscriptionDao subscriptionDao;
//  DatabaseProvider _databaseProvider;
//
//  Subscription _buildSubscriptionMock() {
//    return Subscription(name: subscriptionNameTest);
//  }
//
//  group("Subscription dao tests", () {
//    setUp(() async {
//      final String databasePath = await getDatabasesPath();
//
//      final String path = join(databasePath, DATABASE_TEST_NAME);
//
//      _databaseProvider = DatabaseProvider.instance;
//      final future = _databaseProvider.initialize(databasePath: path);
//      subscriptionDao = SubscriptionDao(future);
//    });

  // Delete the database so every test run starts with a fresh database
//    tearDownAll(() async {
//      final String databasePath = await getDatabasesPath();
//      // print(databasePath);
//      final String path = join(databasePath, DATABASE_TEST_NAME);
//
////      final path = await _databaseProvider.databasePath(
////          databaseName: DATABASE_TEST_NAME);
//      _databaseProvider.dropDatabase(databasePath: path);
//    });

//    test("should insert and query a susbcription", () async {
//      await subscriptionDao.insertSubscription(_buildSubscriptionMock());
//
//      final resultSaved = await subscriptionDao.fetchAllSubscriptions();
//
//      expect(resultSaved.length, 1);
//      final subscriptionSaved = resultSaved[0];
//
//      expect(subscriptionSaved.name, subscriptionNameTest);
//    });
//  });
}
