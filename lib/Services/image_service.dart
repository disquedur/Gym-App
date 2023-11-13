import 'package:injectable/injectable.dart';

@injectable
class Images {
  static const double latitude = 45.50;
  static const double longitude = -73.56;

  static final Images _instance = Images._internal();
  factory Images() {
    return _instance;
  }

  Images._internal();



}
