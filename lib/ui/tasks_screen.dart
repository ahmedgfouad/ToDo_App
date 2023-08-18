import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/componant/item_task.dart';
import 'package:to_do_app/componant/no_item.dart';
import 'package:to_do_app/to_do_cubit/cubit.dart';
import 'package:to_do_app/to_do_cubit/states.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return NoTasks(tasks: tasks);
        });
  }
}
