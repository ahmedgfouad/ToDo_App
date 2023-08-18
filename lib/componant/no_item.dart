import 'package:flutter/material.dart';
import 'package:to_do_app/componant/item_task.dart';

class NoTasks extends StatelessWidget {
  List<Map> tasks ;
   NoTasks({Key? key,required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          separatorBuilder: (context,index)=>const SizedBox(height: 10,),
          itemCount: tasks.length,
          itemBuilder: (context,index)=> BuildTaskItem(model: tasks[index]),
        ),
      ),
    )
    : const Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,color: Colors.green,size: 50,),
        Text("No tasks , please add some tasks",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black38,
          fontWeight: FontWeight.w700,
        ),),
      ],),);
  }
}
