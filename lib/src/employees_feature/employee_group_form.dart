import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../menu_feature/menu.dart';
import '../menu_feature/menu_nav_controller.dart';
import '../menu_feature/menu_tabbar.dart';
import '../menu_feature/menu_view.dart';
import '../services/employee_service.dart';
import '../services/menu_service.dart';
import '../shared/add_delete_buttons.dart';
import '../shared/form_error_message.dart';
import '../shared/utils.dart';
import 'employee.dart';

class EmployeeGroupForm extends StatefulWidget {
  final EmployeeGroup? group;

  const EmployeeGroupForm({super.key, this.group});

  @override
  State<EmployeeGroupForm> createState() => _EmployeeGroupFormState();
}

class _EmployeeGroupFormState extends State<EmployeeGroupForm> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(text: widget.group?.name);
  late final _menuIds = widget.group?.menuNotifiers ?? {};
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Namen eingeben",
            ),
            controller: _nameController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Bitte geben Sie einen Namen an";
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          FormField(
            builder: (_) => Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Menü Benachrichtigungen",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        Get.put(MenuNavController());
                        await Utils.showBottomSheet(
                          "Menü Benachrichtigung hinzufügen",
                          _buildBottomSheetMenuPicker(),
                        );
                        Get.delete<MenuNavController>();
                      },
                    ),
                  ],
                ),
                if (_menuIds.isNotEmpty)
                  ..._menuIds.map((id) => _buildMenuNotifierTile(id)).toList(),
                if (_menuIds.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Keine Menüs"),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 25.0),
          const Spacer(),
          if (_error != null) FormErrorMessage(text: _error!),
          AddDeleteButtons(
            onAdd: _onAdd,
            onDelete: _onDelete,
            deleteText: widget.group == null ? "Abbrechen" : "Löschen",
          ),
        ],
      ),
    );
  }

  Widget _buildMenuNotifierTile(String menuId) => Obx(() {
        Menu menu = MenuService.to.allMenus.firstWhere((m) => m.id == menuId);
        return ListTile(
          title: Text(menu.name),
          subtitle: !menu.isRoot ? Text(menu.root.name) : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() => _menuIds.remove(menuId));
            },
          ),
        );
      });

  Widget _buildBottomSheetMenuPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const MenuTabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
        ),
        const Expanded(child: MenuView()),
        ElevatedButton(
          child: const Text("Hinzufügen"),
          onPressed: () {
            Get.back();
            setState(() {
              _menuIds.add(MenuNavController.to.current!.id);
            });
          },
        ),
      ],
    );
  }

  void _onDelete() async {
    if (widget.group == null) return Get.back();

    String? error;

    await Utils.showConfirmDialog(
      "Willst du diesen Benutzer wirklich löschen?",
      () async {
        error = await EmployeeService.to.deleteGroup(widget.group!);
      },
    );

    if (error != null) return setState(() => _error = error);

    Get.back();
  }

  void _onAdd() async {
    if (!_formKey.currentState!.validate()) return;

    String? error;

    if (widget.group != null) {
      widget.group?.name = _nameController.text;
      error = await EmployeeService.to.updateGroup(widget.group!);
    } else {
      error = await EmployeeService.to.addGroup(
        name: _nameController.text,
      );
    }

    if (error != null) return setState(() => _error = error);

    Get.back();
  }
}
