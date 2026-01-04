// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();

  print('=== 楽天APIレスポンス構造確認 ===\n');

  final res = await dio.get(
    'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601',
    queryParameters: {
      'applicationId': '1062173176194047294',
      'keyword': 'iPhone',
      'hits': 1,
      'formatVersion': 2,
    },
  );

  final items = res.data['Items'] as List;
  print('Items type: ${items.runtimeType}');
  print('First item type: ${items[0].runtimeType}');
  print('');
  print('First item structure:');
  print(const JsonEncoder.withIndent('  ').convert(items[0]));
}
