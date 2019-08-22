import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_param.dart';

typedef void NativeAdViewCreatedCallback(NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    Key key,
    this.onParentViewCreated,
    this.nativeAdParam,
  }) : super(key: key);

  final NativeAdViewCreatedCallback onParentViewCreated;
  final NativeAdParam nativeAdParam;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAdView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.nativeAdParam.toMap(),
        creationParamsCodec: StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onParentViewCreated == null) {
      return;
    }
    widget.onParentViewCreated(NativeAdViewController._(id));
  }
}

class NativeAdViewController {
  NativeAdViewController._(int id)
      : _channel = MethodChannel('com.github.sakebook/unified_ad_layout_$id');

  final MethodChannel _channel;

  Future<void> setNativeAd() async {
    return _channel.invokeMethod('setNativeAd');
  }
}