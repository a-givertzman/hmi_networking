import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/auth/user_group/app_user_group.dart';
import 'package:hmi_networking/src/auth/user_group/user_group.dart';
import 'package:hmi_networking/src/core/entities/data_object.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'package:hmi_networking/src/datasource/data_set.dart';
import 'package:hmi_networking/src/datasource/data_source.dart';
import 'app_user.dart';
part 'guest_app_user_single.dart';
part 'local_asset_app_user_single.dart';
part 'remote_app_user_single.dart';

///
abstract class AppUserSingle extends AppUser {
  ///
  Map<String, dynamic> asMap();
  ///
  const factory AppUserSingle.guest() = _GuestAppUserSingle;
  ///
  factory AppUserSingle.remote({
    DataSet<Map<String, String>>? remote, 
  }) = _RemoteAppUserSingle;
  ///
  factory AppUserSingle.localAsset(String assetPath) = _LocalAssetAppUserSingle;
}