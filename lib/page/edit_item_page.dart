import 'package:beshmar/utils/styles.dart';
import 'package:flutter/material.dart';

import '../data/counter_model.dart';
import '../data/edit_result_model.dart';
import '../widget/app_bar_title.dart';
import '../widget/color_list_picker.dart';
import '../widget/my_outlined_button.dart';
import '../widget/my_text_form_field.dart';
import '../widget/scaffold_rtl.dart';
import 'home_page.dart';

class EditItemPage extends StatefulWidget {
  final CounterModel? model;
  final int? index;

  const EditItemPage({this.model, this.index, Key? key}) : super(key: key);

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController countController;
  int? selectedColor;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.model?.title);
    countController =
        TextEditingController(text: widget.model?.count.toString());
    selectedColor = widget.model?.color;
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
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                MyTextFormField(
                  placeholder: 'عنوان',
                  icon: Icons.abc_rounded,
                  controller: titleController,
                  maxLength: 120,
                  validator: _titleFieldValidator,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: _onSubmitPressed,
                ),
                const SizedBox(height: 16),
                MyTextFormField(
                  placeholder: 'تعداد',
                  icon: Icons.numbers_rounded,
                  controller: countController,
                  maxLength: 7,
                  textAlign: TextAlign.center,
                  validator: _countFieldValidator,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: _onSubmitPressed,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text('رنگ', style: Styles.textNormalBold),
                  ],
                ),
                const SizedBox(height: 15),
                ColorListPicker(
                  currentColor:
                      selectedColor != null ? Color(selectedColor!) : null,
                  onTap: (color) {
                    selectedColor = color?.value;
                  },
                ),
                const SizedBox(height: 50),
                _getButtons(context),
              ],
            ),
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
      row.children.add(
        MyOutlinedButton(
          text: 'حذف',
          textColor: Colors.red,
          borderColor: Colors.red,
          onPressed: _onDeletePressed,
        ),
      );
    }

    return row;
  }

  String? _titleFieldValidator(String? text) {
    if (text == null || text.isEmpty || text.trim().isEmpty) {
      return 'لطفا مقدار را وارد کنید';
    }

    return null;
  }

  String? _countFieldValidator(String? text) {
    if (text == null || text.isEmpty || text.trim().isEmpty) {
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

    final newModel = CounterModel(
      title: titleController.text,
      count: int.parse(countController.text),
      color: selectedColor,
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
      ),
    );
  }
}
