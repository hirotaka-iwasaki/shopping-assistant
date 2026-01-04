import 'package:flutter/material.dart';

/// Privacy policy screen.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('はじめに'),
            _SectionBody(
              'ヨコダン（以下「本アプリ」）は、ユーザーの皆様のプライバシーを尊重し、'
              '個人情報の保護に努めています。本プライバシーポリシーでは、本アプリがどのような情報を'
              '収集し、どのように利用するかについて説明します。',
            ),
            _SectionTitle('収集する情報'),
            _SectionBody(
              '本アプリは以下の情報を収集する場合があります：\n\n'
              '• 検索履歴：商品検索に使用したキーワード\n'
              '• アプリ設定：選択した検索サイト、表示設定など\n'
              '• 利用状況データ：アプリの使用状況（匿名化済み）\n\n'
              'これらの情報はお客様のデバイス内に保存され、外部サーバーには送信されません。',
            ),
            _SectionTitle('情報の利用目的'),
            _SectionBody(
              '収集した情報は以下の目的で利用します：\n\n'
              '• 検索機能の提供と改善\n'
              '• ユーザー体験の向上\n'
              '• アプリの機能改善\n',
            ),
            _SectionTitle('第三者への提供'),
            _SectionBody(
              '本アプリは、法令に基づく場合を除き、収集した情報を第三者に提供することはありません。',
            ),
            _SectionTitle('外部サービスへの接続'),
            _SectionBody(
              '本アプリは商品情報の取得のため、以下の外部サービスに接続します：\n\n'
              '• Amazon Product Advertising API\n'
              '• 楽天ウェブサービス\n'
              '• Yahoo!ショッピングAPI\n\n'
              'これらのサービスへの接続時には、検索キーワードのみが送信されます。',
            ),
            _SectionTitle('アフィリエイトについて'),
            _SectionBody(
              '本アプリはアフィリエイトプログラムに参加しています。商品リンクから購入された場合、'
              'アプリ運営者に報酬が支払われることがあります。これによりユーザーに追加費用が'
              '発生することはありません。',
            ),
            _SectionTitle('お問い合わせ'),
            _SectionBody(
              'プライバシーポリシーに関するお問い合わせは、アプリ内のお問い合わせフォームよりご連絡ください。',
            ),
            _SectionTitle('改定について'),
            _SectionBody(
              '本プライバシーポリシーは、必要に応じて改定されることがあります。'
              '重要な変更がある場合は、アプリ内でお知らせします。',
            ),
            SizedBox(height: 16),
            Text(
              '最終更新日：2025年1月',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Terms of service screen.
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('第1条（適用）'),
            _SectionBody(
              '本規約は、ヨコダン（以下「本アプリ」）の利用に関する条件を定めるものです。'
              'ユーザーは本アプリを利用することにより、本規約に同意したものとみなされます。',
            ),
            _SectionTitle('第2条（サービス内容）'),
            _SectionBody(
              '本アプリは、複数のECサイトの商品情報を横断検索し、価格比較を行うサービスを提供します。\n\n'
              '• 商品情報は各ECサイトのAPIを通じて取得しています\n'
              '• 価格・在庫情報はリアルタイムで変動する可能性があります\n'
              '• 実際の購入は各ECサイトで行われます',
            ),
            _SectionTitle('第3条（免責事項）'),
            _SectionBody(
              '1. 本アプリで表示される商品情報の正確性について、当方は一切の責任を負いません。\n\n'
              '2. 商品の購入に関するトラブルについては、各ECサイトにお問い合わせください。\n\n'
              '3. 本アプリの利用により生じた損害について、当方は一切の責任を負いません。\n\n'
              '4. 予告なくサービスを変更・終了する場合があります。',
            ),
            _SectionTitle('第4条（禁止事項）'),
            _SectionBody(
              'ユーザーは以下の行為を行ってはなりません：\n\n'
              '• 本アプリの不正利用\n'
              '• APIへの過度なアクセス\n'
              '• 本アプリのリバースエンジニアリング\n'
              '• その他、運営に支障をきたす行為',
            ),
            _SectionTitle('第5条（知的財産権）'),
            _SectionBody(
              '本アプリに関する著作権、商標権その他の知的財産権は、当方または正当な権利者に帰属します。'
              '各ECサイトのロゴ・商標は各社に帰属します。',
            ),
            _SectionTitle('第6条（規約の変更）'),
            _SectionBody(
              '当方は、必要と判断した場合には、本規約を変更することができるものとします。'
              '変更後の規約は、本アプリ内に掲示した時点から効力を生じるものとします。',
            ),
            _SectionTitle('第7条（準拠法・管轄）'),
            _SectionBody(
              '本規約の解釈にあたっては、日本法を準拠法とします。',
            ),
            SizedBox(height: 16),
            Text(
              '最終更新日：2025年1月',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
          ),
    );
  }
}
