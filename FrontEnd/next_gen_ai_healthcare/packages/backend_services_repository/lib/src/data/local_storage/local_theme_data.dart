import 'package:backend_services_repository/backend_service_repositoy.dart';

class LocalThemeData {
  static final LocalThemeData _instance = LocalThemeData._internal();
  factory LocalThemeData() {
    return _instance;
  }
  LocalThemeData._internal();

  // final SqlHelper _sqlHelper = SqlHelper();

  // Future<void> storeTheme(String state)async{
  //   final db = await _sqlHelper.database;
  //   db.insert('theme', {'id':1, 'isLight': state=='light'?1:0});
  // }

  // Future<bool> getTheme()async{
  //   final db = await _sqlHelper.database;
  //   List<Map<String, dynamic>> mp = (await db.query('theme', where: "id = ?", whereArgs: [1])) as List<Map<String, dynamic>>;
  //   if(mp.isEmpty){
  //     return false;
  //   } else{
  //     return mp[0]['isLight']==1;
  //   }
  // }
  Future<void> storeTheme(String state) async {
    final box = Hive.box('settings');
    await box.put('isLight', state == 'light' ? 1 : 0);
  }

  bool getTheme()  {
    final box = Hive.box('settings');
    return box.get('isLight') ?? true;
  }
}
