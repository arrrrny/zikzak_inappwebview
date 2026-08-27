import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'android_resource.zorphy.dart';
part 'android_resource.g.dart';

///Class that represents an Android resource file.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $AndroidResource {
  ///Android resource name.
  ///
  ///A list of available `android.R.drawable` can be found
  ///[here](https://developer.android.com/reference/android/R.drawable).
  ///
  ///A list of available `android.R.anim` can be found
  ///[here](https://developer.android.com/reference/android/R.anim).
  ///
  ///A list of available `androidx.appcompat.R.anim` can be found
  ///[here](https://android.googlesource.com/platform/frameworks/support/+/HEAD/appcompat/appcompat/src/main/res/anim/)
  ///(abc_*.xml files).
  ///In this case, [defPackage] must match your App Android package name.
  String get name;

  ///Optional default resource type to find, if "type/" is not included in the name.
  ///Can be `null` to require an explicit type.
  ///
  ///Example: "anim"
  String? get defType;

  ///Optional default package to find, if "package:" is not included in the name.
  ///Can be `null` to require an explicit package.
  ///
  ///Example: "android" if you want use resources from `android.R.`
  String? get defPackage;
  static AndroidResource anim({required String name, String? defPackage}) {
    return AndroidResource(name: name, defType: "anim", defPackage: defPackage);
  }

  static AndroidResource layout({required String name, String? defPackage}) {
    return AndroidResource(
      name: name,
      defType: "layout",
      defPackage: defPackage,
    );
  }

  static AndroidResource id({required String name, String? defPackage}) {
    return AndroidResource(name: name, defType: "id", defPackage: defPackage);
  }

  static AndroidResource drawable({required String name, String? defPackage}) {
    return AndroidResource(
      name: name,
      defType: "drawable",
      defPackage: defPackage,
    );
  }
}
