// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

/// API動作確認スクリプト
/// 実行: fvm dart run bin/api_test.dart
void main() async {
  print('=== API動作確認 ===\n');

  // 楽天API テスト
  await testRakutenApi();

  // Yahoo API テスト
  await testYahooApi();

  print('\n=== テスト完了 ===');
}

Future<void> testRakutenApi() async {
  print('【楽天API】');

  const appId = '1062173176194047294';
  const keyword = 'iPhone';

  final dio = Dio();

  try {
    final response = await dio.get(
      'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601',
      queryParameters: {
        'applicationId': appId,
        'keyword': keyword,
        'hits': 3,
        'format': 'json',
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final count = data['count'] ?? 0;
      final items = data['Items'] as List? ?? [];

      print('  ✅ 成功！');
      print('  検索キーワード: $keyword');
      print('  ヒット件数: $count');
      print('  取得件数: ${items.length}');

      if (items.isNotEmpty) {
        final firstItem = items[0]['Item'];
        print('  最初の商品: ${firstItem['itemName']?.toString().substring(0, 50) ?? 'N/A'}...');
        print('  価格: ¥${firstItem['itemPrice']}');
      }
    }
  } on DioException catch (e) {
    print('  ❌ エラー: ${e.response?.statusCode} - ${e.message}');
    if (e.response?.data != null) {
      print('  詳細: ${e.response?.data}');
    }
  } catch (e) {
    print('  ❌ エラー: $e');
  }

  print('');
}

Future<void> testYahooApi() async {
  print('【Yahoo!ショッピングAPI】');

  const appId = 'dj00aiZpPWxZVTRlc3hjSlM4MCZzPWNvbnN1bWVyc2VjcmV0Jng9Mjc-';
  const keyword = 'iPhone';

  final dio = Dio();

  try {
    final response = await dio.get(
      'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch',
      queryParameters: {
        'appid': appId,
        'query': keyword,
        'results': 3,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final totalCount = data['totalResultsAvailable'] ?? 0;
      final hits = data['hits'] as List? ?? [];

      print('  ✅ 成功！');
      print('  検索キーワード: $keyword');
      print('  総ヒット件数: $totalCount');
      print('  取得件数: ${hits.length}');

      if (hits.isNotEmpty) {
        final firstItem = hits[0];
        final name = firstItem['name']?.toString() ?? 'N/A';
        print('  最初の商品: ${name.length > 50 ? name.substring(0, 50) : name}...');
        print('  価格: ¥${firstItem['price']}');
      }
    }
  } on DioException catch (e) {
    print('  ❌ エラー: ${e.response?.statusCode} - ${e.message}');
    if (e.response?.data != null) {
      print('  詳細: ${e.response?.data}');
    }
  } catch (e) {
    print('  ❌ エラー: $e');
  }

  print('');
}
