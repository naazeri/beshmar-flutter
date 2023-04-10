import 'package:beshmar/utils/changelog.dart';
import 'package:beshmar/widget/list_item_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_config.dart';
import '../data/counter_model.dart';
import '../data/edit_result_model.dart';
import '../utils/backup.dart';
import '../utils/iab.dart';
import '../utils/prefs.dart';
import '../utils/show.dart';
import '../utils/showcase_helper.dart';
import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';
import 'list_edit_item_page.dart';

enum EditResultType { newItem, updated, deleted }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlayDelay: const Duration(seconds: 3),
      builder: Builder(
        builder: (context) => MyListView(title: AppConfig.appName),
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
    WidgetsBinding.instance.addPostFrameCallback(_onStateLoaded);
  }

  Future<void> _onStateLoaded(_) async {
    _initIab();
    ShowcaseHelper.statrt(context);
  }

  Future<void> _initIab() async {
    await Iab.init();

    final result = await Iab.checkIsFullVersionProduct();
    AppConfig.isFullVersion = result;
    Prefs.setFullVersionStatus(result);

    debugPrint('*** Full version: $result');
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
        itemBuilder: (context, i) => ListItemView(
          key: Key('$i'),
          index: i,
          onItemTap: () => _showListEditPage(i),
          onAddPressed: () => _addNumber(i, 1, needSave: true),
          onAddHold: () => _addNumber(i, 1, needSave: false),
          onSubtractPressed: () => _addNumber(i, -1, needSave: true),
          onSubtractHold: () => _addNumber(i, -1, needSave: false),
          onCancel: () => _saveData(),
        ),
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

  AppBar _getAppBar() {
    const int backupValue = 1;
    const int restoreValue = 2;
    const int shareValue = 3;
    const int changelogValue = 4;
    const int aboutusValue = 5;

    return AppBar(
      title: AppBarTitle(widget.title),
      leading: PopupMenuButton(
        itemBuilder: (context) {
          return [
            _getPopupMenuItem(backupValue, "پشتیبان گیری اطلاعات"),
            _getPopupMenuItem(restoreValue, "بازگردانی اطلاعات"),
            _getPopupMenuItem(shareValue, "اشتراک گذاری اپ"),
            _getPopupMenuItem(changelogValue, "تغییرات اخیر"),
            _getPopupMenuItem(aboutusValue, "درباره ما"),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case backupValue:
              await Backup.backupData(_getDataAsString(), context);
              break;
            case restoreValue:
              _importData();
              break;
            case shareValue:
              Share.share(
                AppConfig.shareLink,
                subject: '‏«بشمار» را در بازار اندروید ببین:',
              );
              break;
            case changelogValue:
              ChangeLog.show(context);
              break;
            case aboutusValue:
              _launchUrl(AppConfig.aboutUsLink);
              break;
            default:
          }
        },
      ),
      actions: [
        ShowcaseHelper.getShowcase(
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
            onPressed: _swapLockMode,
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  PopupMenuItem<int> _getPopupMenuItem(final int value, final String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text),
        ],
      ),
    );
  }

  Widget _getFloatingActionButton([int listCount = 0]) {
    return ShowcaseHelper.getShowcase(
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
              'برای اضافه کردن بیش از 3 آیتم لطفا نسخه کامل برنامه رو خریداری کنید',
              [
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
                TextButton(
                  child: const Text('انصراف'),
                  onPressed: () async {
                    Navigator.pop(context);
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

  void _swapLockMode() {
    setState(() {
      AppConfig.isCountingLocked = !AppConfig.isCountingLocked;
    });

    Prefs.setCountingLock(AppConfig.isCountingLocked);
  }
}
