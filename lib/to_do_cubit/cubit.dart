import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/to_do_cubit/states.dart';
import '../ui/archived_screen.dart';
import '../ui/done_screen.dart';
import '../ui/tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit (): super (AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  String tableDatabaseName= 'Tasks';
  int currentIndex = 0 ;
  bool isBottomSheetShown = false;
  IconData fab = Icons.add;
  List <Map> newTasks = [];
  List <Map> doneTasks = [];
  List <Map> archivedTasks = [];

  TextEditingController tittleController =TextEditingController();
  TextEditingController timeController =TextEditingController();
  TextEditingController dateController =TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();


  List listOfScreens= const[
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List listOfTittles= [
    "Tittle Screen",
    "Done Screen",
    "Archived Screen",
  ];

  void changeIndex(int index){
    currentIndex = index ;
    emit(ChangeIndex());
  }

  static Database? database;

  void createDatabase()async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

     openDatabase(
        path,
        version: 3,
        onCreate: (database,version) async {
          log('create Database');

          database.execute('CREATE TABLE $tableDatabaseName (id INTEGER PRIMARY KEY, tittle TEXT, data TEXT, time TEXT , status TEXT)')
              .then((value)
          {
            log('table Database');
          }).catchError((error){
            log("the error is ${error.toString()}");
          });
        },
        onOpen: (database){
          log('dataBase opened');
          getDataFromDatabase(database);

        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

  Future insertToDataBase({
    required String tittle,
    required String data,
    required String time,
  })async{
    database!.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO $tableDatabaseName(tittle, data, time, status) VALUES("$tittle", "$data", "$time", "new")'
      ).then((value){

        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);

      }).catchError((error){

        log('error when inserting ${error.toString()}');

      });
      return null;
    });
  }


  void getDataFromDatabase(database){
    newTasks = [];
    doneTasks= [];
    archivedTasks =[];
    emit(AppGetDatabaseLoadingState());
     database!.rawQuery('SELECT * FROM $tableDatabaseName').then((value) {
       value.forEach((element) {
         if(element['status']== 'new') {
           newTasks.add(element);
         } else if(element['status'] == 'done') {
           doneTasks.add(element);
         } else {
           archivedTasks .add(element);
         }
       });
       emit(AppGetDatabaseState());
     });
  }

  void updateDatabase(
      @required String status,
      @required int id,
      ){
    database!.rawUpdate(
        'UPDATE $tableDatabaseName SET status = ? WHERE id = ?',
        [status, id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }


 void deleteDatabase(
      @required int id,
      ){
    database!.rawDelete('DELETE FROM $tableDatabaseName WHERE id = ?',
        [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  void changeBottomSheetState(
      @required bool isShow,
      @required IconData icon,
      ){
    isBottomSheetShown = isShow ;
    fab = icon;
    emit(AppChangeBottomSheetState());

  }

}