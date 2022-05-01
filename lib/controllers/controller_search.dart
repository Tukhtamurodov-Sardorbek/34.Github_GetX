import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_page_getx/models/user_model.dart';
import 'package:github_page_getx/pages/profile_page.dart';
import 'package:github_page_getx/services/hive_service.dart';
import 'package:github_page_getx/services/http_service.dart';
import 'package:github_page_getx/services/status_codes.dart';
import 'package:github_page_getx/services/web_scraping_service.dart';
import 'package:github_page_getx/widgets/snackBar.dart';

class SearchController extends GetxController{

  var accountController = TextEditingController().obs;
  var accountFocus = FocusNode().obs;
  var isLoading = false.obs;
  dynamic funcResponse = 0.obs;
  var isNotEmpty = false.obs;
  var history = <String>[].obs;

  clear() {
    isNotEmpty.value = false;
    accountFocus.value.unfocus();
    accountController.value.clear();
  }

  change(String txt) {
    isNotEmpty.value = txt.isNotEmpty;
  }

  updateField(String value) {
    isNotEmpty.value = true;
    accountFocus.value.unfocus();
    accountController.value.text = value;
  }

  storeHistory(String username) async{
    await HiveService.storeUserNames(username);
    loadHistory();
  }

  loadHistory(){
    history.value = HiveService.loadUserNames();
  }

  deleteHistory(String value){
    HiveService.removeUserName(value);
    history.remove(value);
  }

  onTimeOut(BuildContext context){
    snackBar(context, 'Request time out');
    isLoading.value = false;
  }

  Future<void> findUser(BuildContext context) async{
    accountFocus.value.unfocus();
    String user = accountController.value.text.toString().trim();

    if (user.isEmpty) {
      snackBar(context, 'Type the username, please!');
      return;
    }

    isLoading.value = true;

    await WebScraping.getWebsiteData(user);
    dynamic response = await Network.GET(Network.API_GET + user, Network.paramsEmpty());
    await _check(context, response);
  }

  Future<void> _check(BuildContext context, dynamic _response) async {
    if (_response is String) {
      User user = Network.parseUser(_response);

      if (user.starredReposLink != null) {
        if (kDebugMode) {
          print(
              'API: ${user.starredReposLink!.substring(22).replaceFirstMapped('{/owner}{/repo}', (m) => '')}');
        }
        String? response = await Network.GET(
            user.starredReposLink!
                .substring(22)
                .replaceFirstMapped('{/owner}{/repo}', (m) => ''),
            Network.paramsEmpty());
        await starredRepos(user, response!);
      }

      if (kDebugMode) {
        print('-----------------------------------------');
        print('Name: ${user.name}   Username: ${user.username}');
        print('Image: ${user.profileImage}  Starred: ${user.starredRepos}');
        print('-----------------------------------------');
      }
      if (funcResponse != null) {
        isLoading.value = false;
        Get.to(
              () => ProfilePage(user: user),
        );
      } else {
        isLoading.value = false;
      }
    } else {
      if (kDebugMode) {
        print(_response);
      }
      snackBar(context, StatusCodes.response(_response));
      isLoading.value = false;
    }
  }

  Future<void> starredRepos(User user, String response) async {
    List json = await jsonDecode(response);
    user.starredRepos = json.length;
    funcResponse.value = json.length;
  }
}