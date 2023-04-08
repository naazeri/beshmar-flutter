import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_config.dart';
import '../data/counter_model.dart';
import '../data/edit_result_model.dart';
import '../utils/backup.dart';
import '../utils/iab.dart';
import '../utils/prefs.dart';
import '../utils/show.dart';
import '../utils/showcase_helper.dart';
import '../utils/styles.dart';
import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';
import 'list_edit_item_page.dart';

enum EditResultType { newItem, updated, deleted }

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({this.title = 'Home', super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlayDelay: const Duration(seconds: 3),
      builder: Builder(
        builder: (context) => MyListView(title: widget.title),
      ),
      onComplete: (index, key) {
        if (index == ShowcaseHelper.keyList.length - 1) {
          Prefs.setShowcaseStatus(true);
        }
      },
    );
  }
}

class MyListView extends StatefulWidget {
  final String title;

  const MyListView({required this.title, super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initIab();

    if (!ShowcaseHelper.seen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase(ShowcaseHelper.keyList);
      });
    }
  }

  Future<void> _initIab() async {
    await Iab.init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await Iab.checkIsFullVersionProduct();
      AppConfig.isFullVersion = result;
      Prefs.setFullVersionStatus(result);
      debugPrint('*** Full version: $result');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Iab.dispose();
    super.dispose();
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
    final itemCount = CounterModel.list.length;

    return ScaffoldRTL(
      appBar: _getAppBar(),
      body: ReorderableListView.builder(
        header: const SizedBox(height: 10),
        footer: const SizedBox(height: 75),
        itemCount: itemCount,
        itemBuilder: (context, i) => _getListItemView(i),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final item = CounterModel.list.removeAt(oldIndex);
            CounterModel.list.insert(newIndex, item);
          });

          _saveData();
        },
      ),
      floatingActionButton: _getFloatingActionButton(itemCount),
    );
  }

  Widget _getListItemView(int i) {
    Widget listTile = ListTile(
      contentPadding: const EdgeInsets.only(
        right: 10,
        left: 0,
        top: 5,
        bottom: 5,
      ),
      trailing: _getListCountView(i),
      title: Text(
        CounterModel.list[i].title,
        style: Styles.textHeader3,
      ),
      onTap: () => _showListEditPage(i),
    );

    if (!ShowcaseHelper.seen && i == 0) {
      listTile = Showcase(
        key: ShowcaseHelper.keyList[2],
        title: 'ویرایش',
        description: 'با زدن روی هر آیتم، میشه اون رو ویرایش کرد',
        child: Showcase(
          key: ShowcaseHelper.keyList[3],
          title: 'ترتیب',
          description: 'با نگه داشتن روی آیتم، میشه جا به جاش کرد',
          child: listTile,
        ),
      );
    }

    return Container(
      key: Key('$i'),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: listTile,
    );
  }

  Row _getListCountView(int i) {
    const holdTimeout = 100;

    Widget addButton = HoldDetector(
      onHold: () => _addNumber(i, 1, needSave: false),
      onCancel: () {
        _saveData();
      },
      holdTimeout: const Duration(milliseconds: holdTimeout),
      child: IconButton(
        onPressed: () => _addNumber(i, 1),
        icon: Icon(
          Icons.add_circle_outline_rounded,
          color: Theme.of(context).primaryColor,
          size: 28.0,
        ),
      ),
    );

    if (!ShowcaseHelper.seen && i == 0) {
      addButton = Showcase(
        key: ShowcaseHelper.keyList[1],
        title: 'افزایش',
        description:
            'با نگه داشتن این دکمه با سرعت بیشتری تعداد افزایش پیدا میکنه',
        child: addButton,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        addButton,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(200),
          ),
          child: Text(
            CounterModel.list[i].count.toString(),
            style: Styles.textHeader3,
          ),
        ),
        HoldDetector(
          onHold: () => _addNumber(i, -1, needSave: false),
          onCancel: () {
            _saveData();
          },
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
              _launchUrl('https://naazeri.ir/');
              break;
            default:
          }
        },
      ),
      actions: [
        Showcase(
          key: ShowcaseHelper.keyList[4],
          title: 'قفل',
          description:
              'برای اینکه اشتباهی دستت نخوره و تعداد رو تغییر بدی می تونی قفلش کنی',
          child: IconButton(
            icon: Icon(
              AppConfig.isCountingLocked
                  ? Icons.lock_rounded
                  : Icons.lock_open_rounded,
            ),
            onPressed: () {
              setState(() {
                AppConfig.isCountingLocked = !AppConfig.isCountingLocked;
                Prefs.setCountingLock(AppConfig.isCountingLocked);
              });
            },
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  Widget _getFloatingActionButton([int listCount = 0]) {
    return Showcase(
      key: ShowcaseHelper.keyList[0],
      description: 'یک آیتم جدید اضافه کن',
      child: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          if (!AppConfig.isFullVersion &&
              listCount >= AppConfig.limitItemCount) {
            Show.dialog(
              context,
              'نسخه کامل',
              'برای اضافه کردن بیش از 3 آیتم نسخه کامل برنامه رو خریداری کنید',
              [
                TextButton(
                  child: const Text('انصراف'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('خرید'),
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await Iab.buyFullVersion();
                    debugPrint('*** purchase result: $result');
                    AppConfig.isFullVersion = result;
                    Prefs.setFullVersionStatus(result);
                  },
                ),
              ],
            );
          } else {
            _showListEditPage(null);
          }
        },
      ),
    );
  }

  void _addNumber(int index, int value, {bool needSave = true}) {
    if (AppConfig.isCountingLocked) {
      Show.snackBar(context, 'اعداد قفل شدن', seconds: 1, clearQueue: true);
      return;
    }

    if (CounterModel.list[index].count + value < 0) {
      return;
    }

    setState(() {
      CounterModel.list[index].count += value;
    });

    if (needSave) {
      _saveData();
    }
  }

  void _showListEditPage(int? index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListEditItemPage(
          model: index != null ? CounterModel.list[index] : null,
          index: index,
        ),
      ),
    ).then(_onNavigatorResult);
  }

  void _onNavigatorResult(dynamic result) {
    if (result is EditResultModel) {
      switch (result.editType) {
        case EditResultType.newItem:
          if (result.model != null) {
            setState(() {
              CounterModel.list.add(result.model!);
            });
          }
          break;
        case EditResultType.updated:
          if (result.model != null && result.index != null) {
            setState(() {
              CounterModel.list[result.index!] = result.model!;
            });
          }
          break;
        case EditResultType.deleted:
          if (result.index != null) {
            setState(() {
              CounterModel.list.removeAt(result.index!);
            });
          }
          break;
        default:
      }

      _saveData();
    }
  }

  Future<bool> _saveData() async {
    try {
      return await Prefs.setData(_getDataAsString());
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
        CounterModel.list = newList;
      });

      _saveData();
      // ignore: use_build_context_synchronously
      Show.snackBar(
        context,
        'بازگردانی اطلاعات با موفقیت انجام شد',
        seconds: 4,
      );
    } catch (e) {
      Show.snackBar(context, 'فایل پشتیبان نامعتبر است', seconds: 4);
    }
  }

  String _getDataAsString() {
    return CounterModel.encode(CounterModel.list);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      // ignore: use_build_context_synchronously
      Show.snackBar(context, 'خطا در اجرای عملیات');
    }
  }
}
