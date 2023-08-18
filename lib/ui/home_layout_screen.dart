import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../componant/dfaultTextFormField.dart';
import '../to_do_cubit/cubit.dart';
import '../to_do_cubit/states.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
         listener: (context , state){
           if(state is AppInsertDatabaseState) Navigator.pop(context);
         },
        builder: (context , state ){
          AppCubit cubit =BlocProvider.of(context);
          return Scaffold(
             key: cubit.scaffoldKey,
             appBar: AppBar(title: Text("${cubit.listOfTittles[cubit.currentIndex]}")),
             body: state is! AppGetDatabaseLoadingState
                 ? cubit.listOfScreens[cubit.currentIndex]
                 : const Center(child: CircularProgressIndicator()),

             bottomNavigationBar: BottomNavigationBar(
               type: BottomNavigationBarType.fixed,
               currentIndex: cubit.currentIndex,
               onTap: (val) {
                 cubit.changeIndex(val);
               },
               items: const [
                 BottomNavigationBarItem(
                     icon: Icon(Icons.menu), label: "Tasks"),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.check_circle_outline), label: "Done"),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.archive_outlined), label: "Archived"),
               ],
             ),

             floatingActionButton: FloatingActionButton(
               onPressed: () {
                 if (cubit.isBottomSheetShown) {
                   if (cubit.formKey.currentState!.validate()) {
                     cubit.insertToDataBase(
                       tittle: cubit.tittleController.text,
                       data: cubit.dateController.text,
                       time: cubit.timeController.text,
                     );
                   }
                 } else {
                   cubit.scaffoldKey.currentState!.showBottomSheet(
                     elevation: 20,
                     (context) => Container(
                       width: MediaQuery.of(context).size.width,
                       padding: const EdgeInsets.all(10),
                       child: Form(
                         key: cubit.formKey,
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             DefaultFormField(
                               width: 300,
                               height: 50,
                               hintText: 'task tittle',
                               prefix: Icons.title,
                               controller: cubit.tittleController,
                               validate: (value) {
                                 if (value!.isEmpty) {
                                   return 'tittle is required';
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10),
                             DefaultFormField(
                               width: 300,
                               height: 50,
                               hintText: 'task tittle',
                               prefix: Icons.watch_later_outlined,
                               controller: cubit.timeController,
                               onTap: () {
                                 showTimePicker(
                                   context: context,
                                   initialTime: TimeOfDay.now(),
                                 ).then((value) {
                                   cubit.timeController.text =
                                       value!.format(context).toString();
                                   print(value.format(context));
                                 });
                               },
                               validate: (value) {
                                 if (value!.isEmpty) {
                                   return 'time is required';
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10),
                             DefaultFormField(
                               width: 300,
                               height: 50,
                               hintText: 'task tittle',
                               prefix: Icons.calendar_month,
                               controller: cubit.dateController,
                               onTap: () {
                                 showDatePicker(
                                   context: context,
                                   initialDate: DateTime.now(),
                                   firstDate: DateTime.now(),
                                   lastDate: DateTime.utc(2024),
                                 ).then((value) {
                                   cubit.dateController.text =
                                       DateFormat.yMMMd().format(value!).toString();
                                 });
                               },
                               validate: (value) {
                                 if (value!.isEmpty) {
                                   return 'date is required';
                                 }
                                 return null;
                               },
                             ),
                           ],
                         ),
                       ),
                     ),
                   ).closed.then((value) {
                      cubit.changeBottomSheetState(false, Icons.edit_outlined);
                      cubit.tittleController= TextEditingController();
                      cubit.timeController= TextEditingController();
                      cubit.dateController= TextEditingController();
                   });
                   cubit.changeBottomSheetState(true, Icons.add);
                 }
               },
               child: Icon(cubit.fab),
             ),
           );
        }
      ),
    );
  }
}
