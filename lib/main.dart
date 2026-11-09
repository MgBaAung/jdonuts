import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'core/local/j_donuts_local_data_source.dart';
import 'features/app/app_dependencies.dart';
import 'features/shop/presentation/donut_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>('j_donuts');
  final localDataSource = JDonutsLocalDataSource(box: box);
  await localDataSource.ensureMigrated();
  await configureJDonutsDependencies(localDataSource: localDataSource);
  runApp(const DonutApp());
}
