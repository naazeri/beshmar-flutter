import 'package:flutter/material.dart';
import 'package:beshmar/utils/backup.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/counter_model.dart';
import '../data/edit_result_model.dart';
import '../utils/prefs.dart';
import '../utils/show.dart';
import '../utils/styles.dart';
import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';
import 'help_page.dart';
import 'list_edit_item_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({this.title = 'Home', super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum EditResultType { newItem, updated, deleted }

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<CounterModel> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        _saveData();
        break;
      default:
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldRTL(
      appBar: _getAppBar(),
      body: getListView(),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget getListView() {
    final itemCount = list.length;

    return ReorderableListView.builder(
      header: const SizedBox(height: 10),
      footer: const SizedBox(height: 75),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        return Container(
          key: Key('$i'),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
              right: 10,
              left: 0,
              top: 5,
              bottom: 5,
            ),
            trailing: _getListCountView(i),
            title: Text(
              list[i].title,
              style: Styles.textHeader3,
            ),
            onTap: () => _showListEditPage(i),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);
        });

        _saveData();
      },
    );
  }

  Row _getListCountView(int i) {
    const holdTimeout = 200;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoldDetector(
          onHold: () => _addNumber(i, 1),
          holdTimeout: const Duration(milliseconds: holdTimeout),
          child: IconButton(
            onPressed: () => _addNumber(i, 1),
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Theme.of(context).primaryColor,
              size: 28.0,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(200),
          ),
          child: Text(
            list[i].count.toString(),
            style: Styles.textHeader3,
          ),
        ),
        HoldDetector(
          onHold: () => _addNumber(i, -1),
          holdTimeout: const Duration(milliseconds: holdTimeout),
          child: IconButton(
            onPressed: () => _addNumber(i, -1),
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: Theme.of(context).primaryColor,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: AppBarTitle(widget.title),
      leading: PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
          return [
            // const PopupMenuItem<int>(
            //   value: 0,
            //   child: Text("تنظیمات"),
            // ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text("پشتیبان گیری اطلاعات"),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Text("بازگردانی اطلاعات"),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: Text('راهنما'),
            ),
            const PopupMenuItem<int>(
              value: 4,
              child: Text('درباره ما'),
            ),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case 1:
              await Backup.backupData(_getDataAsString(), context);
              break;
            case 2:
              _importData();
              break;
            case 3:
              _showHelpPage();
              break;
            case 4:
              _launchUrl('https://naazeri.ir/');
              break;
            default:
          }
        },
      ),
    );
  }

  FloatingActionButton _getFloatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add_rounded),
      onPressed: () => _showListEditPage(null),
    );
  }

  void _addNumber(int index, int value) {
    if (list[index].count + value < 0) return;

    setState(() {
      list[index].count += value;
    });

    _saveData();
  }

  void _showListEditPage(int? index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListEditItemPage(
          model: index != null ? list[index] : null,
          index: index,
        ),
      ),
    ).then(_onNavigatorResult);
  }

  void _showHelpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpPage(),
      ),
    );
  }

  void _onNavigatorResult(dynamic result) {
    if (result is EditResultModel) {
      switch (result.editType) {
        case EditResultType.newItem:
          if (result.model != null) {
            setState(() {
              list.add(result.model!);
            });
          }
          break;
        case EditResultType.updated:
          if (result.model != null && result.index != null) {
            setState(() {
              list[result.index!] = result.model!;
            });
          }
          break;
        case EditResultType.deleted:
          if (result.index != null) {
            setState(() {
              list.removeAt(result.index!);
            });
          }
          break;
        default:
      }

      _saveData();
    }
  }

  void _loadData() async {
    try {
      final result = await Prefs.readData();
      if (result == null) return;
      var newList = CounterModel.decode(result);

      setState(() {
        list = newList;
      });
    } catch (_) {}
  }

  Future<bool> _saveData() async {
    try {
      return await Prefs.saveData(_getDataAsString());
    } catch (e) {
      return Future<bool>.value(false);
    }
  }

  Future<void> _importData() async {
    try {
      final data = await Backup.importData(context);

      if (data == null) {
        return;
      }

      var newList = CounterModel.decode(data);

      setState(() {
        list = newList;
      });

      _saveData();
      Show.snackBar(context, 'بازگردانی اطلاعات با موفقیت انجام شد',
          seconds: 4);
    } catch (e) {
      Show.snackBar(context, 'فایل پشتیبان نامعتبر است', seconds: 4);
    }
  }

  String _getDataAsString() {
    return CounterModel.encode(list);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      Show.snackBar(context, 'خطا در اجرای عملیات');
    }
  }
}
