import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tables_controller.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TablesController.to.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: const Text("Tischplan")),
            body: ListView.builder(
              itemCount: TablesController.to.tables.length,
              itemBuilder: (_, index) {
                var table = TablesController.to.tables[index];
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
                                    TablesController.to.delete(table),
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
