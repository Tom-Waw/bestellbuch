import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/main_controller.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainController.to.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: const Text("Tischplan")),
            body: ListView.builder(
              itemCount: MainController.to.tables.length,
              itemBuilder: (_, index) {
                var table = MainController.to.tables[index];
                return Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListTile(
                      title: Text(table.name),
                      trailing: SizedBox(
                        width: 20,
                        child: Row(
                          children: [
                            //Delete Button
                            Expanded(
                              child: IconButton(
                                onPressed: () =>
                                    MainController.to.deleteFromTables(table),
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ));
  }
}
