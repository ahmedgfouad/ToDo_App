import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/to_do_cubit/cubit.dart';

class BuildTaskItem extends StatelessWidget {
  Map model;
  BuildTaskItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(
              "${model['time']}",
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['tittle']}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "${model['data']}",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase('done', model['id']);
            },
            icon: const Icon(Icons.check_circle_outline,color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase('archived', model['id']);

            },
            icon: const Icon(Icons.archive, color: Colors.black38),
          ),
        ],
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteDatabase(model['id']);
      },
    );
  }
}
