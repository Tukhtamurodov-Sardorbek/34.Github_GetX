import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_page_getx/controllers/controller_search.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: GetX<SearchController>(
        init: SearchController(),
        builder: (_controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller.accountController.value,
                  focusNode: _controller.accountFocus.value,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff3d3d47),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      labelText: 'Username',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      prefixIcon: const Icon(Icons.person_outline_sharp,
                          color: Colors.white54),
                      suffixIcon: _controller.isNotEmpty.value
                          ? IconButton(
                          splashRadius: 1,
                          icon: const Icon(CupertinoIcons.clear,
                              size: 18, color: Colors.white),
                          onPressed: () {
                            _controller.clear();
                          })
                          : _controller.history.isNotEmpty
                          ? PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white54, size: 26),
                        itemBuilder: (BuildContext context) {
                          return _controller.history.reversed
                              .map<PopupMenuItem<String>>(
                                  (String value) {
                                return PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    value: value,
                                    child: ListTile(
                                      contentPadding:
                                      const EdgeInsets.fromLTRB(
                                          4.0, 0.0, 0.0, 0.0),
                                      isThreeLine: false,
                                      title: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      trailing: IconButton(
                                          splashRadius: 1,
                                          icon: const Icon(
                                              CupertinoIcons.trash_fill,
                                              size: 22,
                                              color: Color(0xffff000f)),
                                          onPressed: () {
                                            _controller.deleteHistory(value);
                                          }),
                                    ));
                              }).toList();
                        },
                        onSelected: (String value) {
                          _controller.updateField(value);
                        },
                      )
                          : const SizedBox.shrink(),

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Colors.white54, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Colors.white54, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Colors.white54, width: 2))),
                  onChanged: (String txt) {
                    _controller.change(txt);
                  },
                  onSubmitted: (String account) {
                    _controller.storeHistory(account);
                    _controller.findUser(context);
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  height: 42,
                  color: const Color(0xff02d800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: _controller.isLoading.value
                      ? const Center(
                      child: SizedBox(
                          height: 26,
                          width: 26,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )))
                      : const Text('Find user',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  onPressed: () {
                    _controller.storeHistory(_controller.accountController.value.text);
                    _controller
                        .findUser(context)
                        .timeout(const Duration(seconds: 5), onTimeout: () {

                      _controller.onTimeOut(context);
                    });
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
