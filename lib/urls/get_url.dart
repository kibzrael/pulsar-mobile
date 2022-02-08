import 'package:pulsar/urls/base_domain.dart';

String getUrl(String url) {
  String baseDormain = BaseDomain.baseDormain;
  return '$baseDormain$url';
}
