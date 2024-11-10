import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Cubit/Todo_Cubit.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer({
    super.key,
    required this.model,
  });

  final Map model;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        BlocProvider.of<TodoCubit>(context).deleteDate(id: model['id']);
      },
      background: Container(
        decoration: const BoxDecoration(color: Colors.red),
        child: const Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(Icons.delete),
            Spacer(),
            Icon(Icons.delete),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(model['time']),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model['date'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 104, 104, 104),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<TodoCubit>(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                )),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<TodoCubit>(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
