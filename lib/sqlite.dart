import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';

class sqliteDB {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //Initialize DB
  static initDb() async {
    String folderPath = await getDatabasesPath();
    String path = join(folderPath, "todo.db");
    //await deleteDatabase(path);
    var taskDb = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int t) async {
        await db.execute(
            'CREATE TABLE TASK (taskID INTEGER PRIMARY KEY, taskListID INTEGER, parentTaskID INTEGER, taskName TEXT, deadlineDate INTEGER, deadlineTime INTEGER, isFinished INTEGER, isRepeating INTEGER)');
      },
    );
    _db = taskDb;
    return taskDb;
  }

  static Future<int?> insertTask(Map<String, dynamic> taskdata) async {
    print(db);
    var dbClient = await db;

    int id = await dbClient.insert("TASK", taskdata);
    if (id != 0) {
      return id;
    } else {
      return (null);
    }
  }

  static Future<List<Task>?> getAllTasks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> taskListFromDB = await dbClient.query("TASK");
    for (var map in taskListFromDB) {
      print(map);
    }
    //var taskListMemory = taskListFromDB.map((t) => Task.fromMap(t)).toList();
    // return(taskListMemory);//
  }
}