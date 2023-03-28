import 'package:flutter/material.dart';

import '../data/counter_model.dart';
import '../data/edit_result_model.dart';
import '../widget/app_bar_title.dart';
import '../widget/my_outlined_button.dart';
import '../widget/my_text_form_field.dart';
import '../widget/scaffold_rtl.dart';
import 'home_page.dart';

class ListEditItemPage extends StatefulWidget {
  final CounterModel? model;
  final int? index;

  const ListEditItemPage({this.model, this.index, Key? key}) : super(key: key);

  @override
  State<ListEditItemPage> createState() => _ListEditItemPageState();
}

class _ListEditItemPageState extends State<ListEditItemPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController countController;
  // bool validateTitle = true;
  // bool validateCount = true;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.model?.title);
    countController =
        TextEditingController(text: widget.model?.count.toString() ?? '0');
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldRTL(
      appBar: AppBar(
        title: AppBarTitle(widget.model == null ? 'ایجاد' : 'ویرایش'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              MyTextFormField(
                placeholder: 'عنوان',
                icon: Icons.abc_rounded,
                controller: titleController,
                validator: _titleFieldValidator,
                keyboardType: TextInputType.text,
                onFieldSubmitted: _onSubmitPressed,
              ),
              const SizedBox(height: 16),
              MyTextFormField(
                placeholder: 'تعداد',
                icon: Icons.numbers_rounded,
                controller: countController,
                validator: _countFieldValidator,
                keyboardType: TextInputType.number,
                onFieldSubmitted: _onSubmitPressed,
              ),
              const SizedBox(height: 15),
              _getButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _getButtons(BuildContext context) {
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MyOutlinedButton(
          text: widget.model == null ? 'ایجاد' : 'ثبت',
          borderColor: null,
          textColor: null,
          onPressed: _onSubmitPressed,
        ),
      ],
    );

    if (widget.model != null) {
      row.children.add(MyOutlinedButton(
        text: 'حذف',
        textColor: Colors.red,
        borderColor: Colors.red,
        onPressed: _onDeletePressed,
      ));
    }

    return row;
  }

  String? _titleFieldValidator(String? text) {
    if (text == null || text.isEmpty || text == ' ') {
      return 'لطفا مقدار را وارد کنید';
    }

    return null;
  }

  String? _countFieldValidator(String? text) {
    if (text == null || text.isEmpty || text == ' ') {
      return 'لطفا مقدار را وارد کنید';
    }

    var count = int.tryParse(text);

    if (count == null) {
      return 'مقدار نامعتبر';
    }

    return null;
  }

  _onSubmitPressed() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var trimmedTitle = titleController.text.trim();

    if (trimmedTitle.isEmpty || trimmedTitle == ' ') {
      Navigator.pop(context);
      return;
    }

    final newModel = CounterModel(
      title: trimmedTitle, // maybe be empty
      count: int.parse(countController.text),
    );

    Navigator.pop(
      context,
      EditResultModel(
        editType: widget.model != null
            ? EditResultType.updated
            : EditResultType.newItem,
        model: newModel,
        index: widget.index,
      ),
    );
  }

  _onDeletePressed() {
    Navigator.pop(
        context,
        EditResultModel(
          editType: EditResultType.deleted,
          index: widget.index,
        ));
  }
}
