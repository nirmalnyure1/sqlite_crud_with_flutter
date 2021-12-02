import 'package:flutter/material.dart';
import 'package:sqlite_flutter/model.dart';

class CardList extends StatelessWidget {
  final StudentModel data;
  final Function editData;
  final int index;
  final Function delete;


  CardList({required this.data,required this.editData,required this.index, required this.delete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(onPressed: () { editData(index); }, icon: Icon(Icons.edit),),
      title: Text(data.name.toString(),),
      subtitle: Text(data.address.toString()),

      trailing: IconButton(onPressed: () {delete(index);  }, icon: Icon(Icons.delete),),
    );
  }
}
