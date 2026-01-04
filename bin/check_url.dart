// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final res = await dio.get(
    "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601",
    queryParameters: {
      "applicationId": "1062173176194047294",
      "keyword": "リポシー",
      "hits": 2,
      "page": 1,
      "formatVersion": 2,
    },
  );

  final items = res.data["Items"] as List;
  for (final item in items) {
    print("--- Item ---");
    print("Keys: ${item.keys.toList()}");
    print("itemName: ${item["itemName"]}");
    print("itemUrl: ${item["itemUrl"]}");
    print("affiliateUrl: ${item["affiliateUrl"]}");
    print("");
  }
}
