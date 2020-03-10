import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safejourney/enums/connectivity_status.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  final double opacity;
  const NetworkSensitive({this.child, this.opacity = 0.8});
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.WiFi) {
      return child;
    }
    if (connectionStatus == ConnectivityStatus.Cellular) {
      return Opacity(
        opacity: opacity,
        child: child,
      );
    }

     return Opacity(
        opacity: 0.4,
        child: child,
      );
    
  }
}
