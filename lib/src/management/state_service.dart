import 'package:get/get.dart';

import 'api_service.dart';
import '../data/menu.dart';
import '../data/table.dart';

/// A class to read and update the store including menu and tables.
class StateService extends GetxService {
  final APIService _api = APIService.to;

  RxBool isLoading = false.obs;
  late final RxList<Menu> menus;
  late final RxList<Table> tables;

  StateService();

  static StateService get to => Get.find<StateService>();

  @override
  Future<void> onInit() async {
    loadData();
    super.onInit();
  }

  /// Load the store data from the APIService.
  Future<void> loadData() async {
    isLoading(true);
    var response = await _api.fetchData();

    menus = List<Menu>.from(response["menus"].map(Menu.fromJson)).obs;
    tables = List<Table>.from(response["tables"].map(Table.fromJson)).obs;

    isLoading(false);
  }

  void syncState() {
    menus.refresh();
    tables.refresh();
  }
}
