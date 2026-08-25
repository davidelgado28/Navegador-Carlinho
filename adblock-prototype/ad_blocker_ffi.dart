import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef CCreate = Pointer<Void> Function();
typedef DartCreate = Pointer<Void> Function();
typedef CDestroy = Void Function(Pointer<Void>);
typedef DartDestroy = void Function(Pointer<Void>);
typedef CShouldBlock = Int32 Function(Pointer<Void>, Pointer<Utf8>);
typedef DartShouldBlock = int Function(Pointer<Void>, Pointer<Utf8>);

class AdBlockerEngine {
  late final DynamicLibrary _dylib;
  late final DartCreate _create;
  late final DartDestroy _destroy;
  late final DartShouldBlock _shouldBlock;
  
  Pointer<Void>? _instance;

  AdBlockerEngine() {
    _dylib = _loadLibrary();
    _create = _dylib.lookupFunction<CCreate, DartCreate>('ad_blocker_create');
    _destroy = _dylib.lookupFunction<CDestroy, DartDestroy>('ad_blocker_destroy');
    _shouldBlock = _dylib.lookupFunction<CShouldBlock, DartShouldBlock>('ad_blocker_should_block');

    _instance = _create();
  }

  DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libadblock.so');
    } else if (Platform.isIOS || Platform.isMacOS) {
      return DynamicLibrary.process(); 
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('adblock.dll');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('libadblock.so');
    }
    throw UnsupportedError('Plataforma não suportada para FFI.');
  }

  bool shouldBlock(String url) {
    if (_instance == null) return false;

    final Pointer<Utf8> urlNativePtr = url.toNativeUtf8();
    
    try {
      final int result = _shouldBlock(_instance!, urlNativePtr);
      return result == 1;
    } finally {
      calloc.free(urlNativePtr);
    }
  }

  void dispose() {
    if (_instance != null) {
      _destroy(_instance!);
      _instance = null;
    }
  }
}
