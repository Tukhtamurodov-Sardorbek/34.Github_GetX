import 'dart:convert';

import 'package:github_page_getx/models/repository_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  static String DB_NAME = 'database';
  static Box box = Hive.box(DB_NAME);

  /// FOR HISTORY LIST
  static Future<void> storeUserNames (String username) async {
    List<String> usernamesList = [];
    if(box.containsKey('usernames')){
      usernamesList = box.get('usernames');
    }

    if(!usernamesList.contains(username)){
      usernamesList.add(username);
    }else{
      usernamesList.remove(username);
      usernamesList.add(username);
    }

    await box.put('usernames', usernamesList);
    // print('STORED: $usernamesList');
  }

  static List<String> loadUserNames(){
    if(box.containsKey('usernames')){
      List<String> usernamesList = box.get('usernames');
      // print('LOADED: $usernamesList');
      return usernamesList;
    }
    return <String>[];
  }

  static Future<void> removeUserName(String username) async {
    List<String> usernamesList = [];
    if(box.containsKey('usernames')){
      usernamesList = box.get('usernames');
    }
    if(usernamesList.contains(username)){
      usernamesList.remove(username);
    }
    await box.put('usernames', usernamesList);
  }

  static Future<void> removeUserNames() async {
    await box.delete('usernames');
  }

  /// FOR PINNED REPOSITORIES LIST
  static Future<void> storePinnedRepos (List<Repository> repos) async {
    // Object => Map => String
    List<String> stringList = repos.map((repo) => jsonEncode(repo.toJson())).toList();
    await box.put('pinnedRepos', stringList);
  }

  static List<Repository> loadPinnedRepos(){
    if(box.containsKey('pinnedRepos')){
      // String => Map => Object
      List<String> stringList = box.get('pinnedRepos');
      List<Repository> reposList = stringList.map((stringRepo) => Repository.fromJson(jsonDecode(stringRepo))).toList();
      return reposList;
    }
    return <Repository>[];
  }

  static Future<void> removePinnedRepos() async {
    await box.delete('pinnedRepos');
  }
}