// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

/// アプリと同じ設定でAPIをテスト
void main() async {
  const keyword = 'リポシー';

  print('=== デバッグ検索: $keyword ===\n');

  // 楽天API（アプリと同じエンドポイント）
  print('【楽天API】');
  print('  Base URL: https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601');

  final rakutenDio = Dio(BaseOptions(
    baseUrl: 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601',
  ));

  try {
    final res = await rakutenDio.get(
      '',
      queryParameters: {
        'applicationId': '1062173176194047294',
        'keyword': keyword,
        'hits': 30,
        'page': 1,
        'formatVersion': 2,
        'sort': 'standard',
      },
    );

    print('  Status: ${res.statusCode}');
    final items = res.data['Items'] as List? ?? [];
    print('  Items count: ${items.length}');
    print('  Total count: ${res.data['count']}');

    if (items.isNotEmpty) {
      final first = items[0]['Item'];
      print('  First item: ${first['itemName']?.toString().substring(0, 50)}...');
    }
  } catch (e) {
    print('  ERROR: $e');
  }

  print('');

  // Yahoo API（アプリと同じエンドポイント）
  print('【Yahoo API】');
  print('  Base URL: https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch');

  final yahooDio = Dio(BaseOptions(
    baseUrl: 'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch',
  ));

  try {
    final res = await yahooDio.get(
      '',
      queryParameters: {
        'appid': 'dj00aiZpPWxZVTRlc3hjSlM4MCZzPWNvbnN1bWVyc2VjcmV0Jng9Mjc-',
        'query': keyword,
        'results': 30,
        'start': 1,
      },
    );

    print('  Status: ${res.statusCode}');
    final hits = res.data['hits'] as List? ?? [];
    print('  Hits count: ${hits.length}');
    print('  Total: ${res.data['totalResultsAvailable']}');

    if (hits.isNotEmpty) {
      final first = hits[0];
      print('  First item: ${first['name']?.toString().substring(0, 50)}...');
    }
  } catch (e) {
    print('  ERROR: $e');
  }

  print('\n=== 完了 ===');
}
