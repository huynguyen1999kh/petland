import 'package:petland/repo/record_repo.dart';
import 'package:petland/services/base_response.dart';
import 'package:petland/share/import.dart';

class RecordBloc extends ChangeNotifier {
  RecordBloc._privateConstructor() {
    //init();
  }
  static final RecordBloc instance = RecordBloc._privateConstructor();

  // List<RecordCategoryModel> categories;
  // List<TypeOfRecordModel> wikiTypes;

  void reload() {
    notifyListeners();
  }

  Future<BaseResponse> init() async {
    try {} catch (e) {} finally {}
  }

  // Future<BaseResponse> getListVaccineRecord() async {
  //   try {
  //     final res = await RecordRepo().getListVaccineRecord();
  //     final List listRaw = res['data'];
  //     final list = listRaw.map((e) => RecordCategoryModel.fromJson(e)).toList();
  //     categories = list;
  //     return BaseResponse.success(list);
  //   } catch (e) {
  //     return BaseResponse.fail(e.message?.toString());
  //   } finally {}
  // }

  Future<BaseResponse> createBirthdayRecord(
      String petId,
      List<String> listImage,
      List<String> listVideo,
      String date,
      bool publicity) async {
    try {
      final res = await RecordRepo()
          .createBirthdayRecord(petId, listImage, listVideo, date, publicity);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }
}
