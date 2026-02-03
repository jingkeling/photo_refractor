import 'dart:io' show Platform;

bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
