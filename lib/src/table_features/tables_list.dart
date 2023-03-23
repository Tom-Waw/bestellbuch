import 'package:flutter/material.dart';

class TablesList extends StatefulWidget {
  const TablesList({Key? key}) : super(key: key);

  @override
  State<TablesList> createState() => _TablesListState();
}

class _TablesListState extends State<TablesList> {
  List<String> data = [
    'Tisch 1',
    'Tisch 2',
    'Tisch 3',
    'Tisch 4',
    'Tisch 5',
    'Tisch 6'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListTile(
                title: Text(data[index]),
                trailing: Container(
                  width: 20,
                  child: Row(
                    children: [
                      //Delete Button
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  data.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete))),
                    ],
                  ),
                ),
              ),
            ));
      },
    ));
  }
}
