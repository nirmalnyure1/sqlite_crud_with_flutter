import 'package:flutter/material.dart';
import 'package:sqlite_flutter/card.dart';
import 'package:sqlite_flutter/db/database_helper.dart';
import 'package:sqlite_flutter/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late DatabaseHelper dbHelper;
  List<StudentModel> data = [];
  bool fetching = true;
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper.instance;
    dbHelper.

    getData();
  }

  void getData() async {
    data = await dbHelper.getData();
    setState(() {
      fetching = false;
    });
  }

  editData(index) async {
    currentIndex = index;
    nameController.text = data[index].name;
    addressController.text = data[index].address;

    showMyDilogueUpdate();
  }

  showMyDilogue() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "name"),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(hintText: "address"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    StudentModel localData = StudentModel(
                        name: nameController.text,
                        address: addressController.text);
                    dbHelper.insertData(localData);
                    //localData.id=data[data.length]
                    setState(() {
                      // data.add(localData);
                      getData();
                    });

                    Navigator.pop(context);
                    nameController.clear();
                    addressController.clear();
                  },
                  child: Text("save"))
            ],
          );
        });
  }

  showMyDilogueUpdate() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "name"),
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(hintText: "address"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    StudentModel updateStudent = data[currentIndex];
                    updateStudent.name = nameController.text;
                    updateStudent.address = addressController.text;
                    dbHelper.update(updateStudent, updateStudent.id!);

                    setState(() {
                      getData();
                    });

                    Navigator.pop(context);
                    nameController.clear();
                    addressController.clear();
                  },
                  child: Text("update"))
            ],
          );
        });
  }

  void delete(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 50,
              child: Column(
                children: [Text("Are you sure to to delete")],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  dbHelper.delete(data[index].id!);

                  setState(() {
                    getData();
                  });

                  Navigator.pop(context);
                  nameController.clear();
                  addressController.clear();
                },
                child: Text("yes"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("no"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMyDilogue();
          },
          child: const Icon(
            Icons.add,
            color: Colors.red,
          ),
        ),
        body: fetching
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) => CardList(
                  data: data[index],
                  editData: editData,
                  index: index,
                  delete: delete,
                ),
              ));
  }
}
