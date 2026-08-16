# Generator Notes

All `.zorphy.dart` and `.g.dart` files in this package are generated from the
`@Zorphy` entities under `lib/src/domain/entities/` by `zorphy` +
`json_serializable` via `build_runner` (see `build.yaml`).

To regenerate:

```bash
cd zikzak_inappwebview_platform_interface
flutter pub run build_runner build
```

The former `@ExchangeableObject`/`@ExchangeableEnum` codegen toolchain
(`dev_packages/generators` + `zikzak_inappwebview_internal_annotations`) was
removed with the Zorphy migration.
