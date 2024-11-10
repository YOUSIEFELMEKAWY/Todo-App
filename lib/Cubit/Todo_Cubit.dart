import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Cubit/Todo_States.dart';
import 'package:todoapp/Screens/Archived_Screen.dart';
import 'package:todoapp/Screens/Done_Screen.dart';
import 'package:todoapp/Screens/Tasks_Screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialStates());

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int currentIndex = 0;
  List screens = [
    const TaskScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];
  List<String> Titles = ['Tasks', 'Done Tasks', 'Archived Tasks'];
  late Database database;
  IconData fButton = Icons.add;
  bool isBottomSheetShown = false;

  void changeIndex(int index) {
    currentIndex = index;
    emit(bottomNavState());
  }

  void createDataBase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('Database Created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error When creating database ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(createDataBaseState());
      return database;
    });
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks (title , date , time , status) VALUES("$title","$date","$time","new")')
            .then((value) {
          getDataFromDatabase(database);
          emit(insertDataBaseState());

          print("$value Inserted successfully");
        }).catchError((error) {
          print(error.toString());
        }));
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(getDataBaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(getDataBaseState());
    });
  }

  void changeIcon({required bool isShown, required IconData icon}) {
    fButton = icon;
    isBottomSheetShown = isShown;

    emit(changeIconState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(updateDataBaseState());
    });
  }

  void deleteDate({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(deleteDataState());
    });
  }
}
