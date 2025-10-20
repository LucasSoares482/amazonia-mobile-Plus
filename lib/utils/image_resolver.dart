export 'image_resolver_stub.dart'
    if (dart.library.html) 'image_resolver_web.dart'
    if (dart.library.io) 'image_resolver_io.dart';
