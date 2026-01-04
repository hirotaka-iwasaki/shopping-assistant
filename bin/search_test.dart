// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  const keyword = 'リポシー';

  print('検索キーワード: $keyword\n');

  // 楽天API
  print('【楽天API】');
  try {
    final res = await dio.get(
      'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601',
      queryParameters: {
        'applicationId': '1062173176194047294',
        'keyword': keyword,
        'hits': 3,
      },
    );
    print('  ヒット数: ${res.data['count']}');
    final items = res.data['Items'] as List;
    if (items.isNotEmpty) {
      print('  最初の商品: ${items[0]['Item']['itemName']}');
    } else {
      print('  結果なし');
    }
  } catch (e) {
    print('  エラー: $e');
  }

  // Yahoo API
  print('\n【Yahoo API】');
  try {
    final res = await dio.get(
      'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch',
      queryParameters: {
        'appid': 'dj00aiZpPWxZVTRlc3hjSlM4MCZzPWNvbnN1bWVyc2VjcmV0Jng9Mjc-',
        'query': keyword,
        'results': 3,
      },
    );
    print('  ヒット数: ${res.data['totalResultsAvailable']}');
    final hits = res.data['hits'] as List;
    if (hits.isNotEmpty) {
      print('  最初の商品: ${hits[0]['name']}');
    } else {
      print('  結果なし');
    }
  } catch (e) {
    print('  エラー: $e');
  }
}
