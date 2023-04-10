import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';

import '../data/counter_model.dart';
import '../utils/showcase_helper.dart';
import '../utils/styles.dart';

class ListItemView extends StatelessWidget {
  final int index;
  final void Function()? onItemTap;
  final void Function() onAddHold;
  final void Function() onAddPressed;
  final void Function() onSubtractHold;
  final void Function() onSubtractPressed;
  final void Function()? onCancel;

  const ListItemView({
    super.key,
    required this.index,
    this.onItemTap,
    required this.onAddHold,
    required this.onAddPressed,
    required this.onSubtractHold,
    required this.onSubtractPressed,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    Widget listTile = ListTile(
      contentPadding: const EdgeInsets.only(
        right: 10,
        left: 0,
        top: 5,
        bottom: 5,
      ),
      trailing: _getListCountView(index, context),
      title: Text(
        CounterModel.list[index].title,
        style: Styles.textHeader3,
      ),
      onTap: onItemTap,
    );

    if (!ShowcaseHelper.seen && index == 0) {
      listTile = ShowcaseHelper.getShowcase(
        key: ShowcaseHelper.keyList[2],
        title: 'ویرایش',
        description: 'با زدن روی هر آیتم، میشه اون رو ویرایش کرد',
        child: ShowcaseHelper.getShowcase(
          key: ShowcaseHelper.keyList[3],
          title: 'ترتیب',
          description: 'با نگه داشتن روی آیتم، میشه جا به جاش کرد',
          child: listTile,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: listTile,
    );
  }

  Row _getListCountView(int i, BuildContext context) {
    const holdTimeout = 100;

    Widget addButton = HoldDetector(
      onHold: onAddHold,
      onCancel: onCancel,
      holdTimeout: const Duration(milliseconds: holdTimeout),
      child: IconButton(
        onPressed: onAddPressed,
        icon: Icon(
          Icons.add_circle_outline_rounded,
          color: Theme.of(context).primaryColor,
          size: 28.0,
        ),
      ),
    );

    if (!ShowcaseHelper.seen && i == 0) {
      addButton = ShowcaseHelper.getShowcase(
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
          onHold: onSubtractHold,
          onCancel: onCancel,
          holdTimeout: const Duration(milliseconds: holdTimeout),
          child: IconButton(
            onPressed: onSubtractPressed,
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
}
