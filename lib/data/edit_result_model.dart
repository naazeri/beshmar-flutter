import '../page/home_page.dart';
import 'counter_model.dart';

class EditResultModel {
  EditResultType editType;
  CounterModel? model;
  int? index;

  EditResultModel({required this.editType, this.model, this.index});
}
