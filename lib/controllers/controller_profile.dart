import 'package:get/get.dart';
import 'package:github_page_getx/models/repository_model.dart';
import 'package:github_page_getx/services/hive_service.dart';

class ProfileController extends GetxController{
  var pinnedRepositories = <Repository>[].obs;

  loadPinnedRepos(){
    pinnedRepositories.value = HiveService.loadPinnedRepos();
  }

  @override
  void onInit() {
    loadPinnedRepos();
    super.onInit();
  }

}