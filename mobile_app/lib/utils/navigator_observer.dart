import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  static final List<Route<dynamic>> _routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    _printStack();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _printStack();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _printStack();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _routeStack.remove(oldRoute);
    if (newRoute != null) _routeStack.add(newRoute);
    _printStack();
  }

  static void _printStack() {
    print('=== Navigator Stack ===');
    for (int i = 0; i < _routeStack.length; i++) {
      final route = _routeStack[i];
      print('[$i] ${route.settings.name ?? route.runtimeType}');
    }
    print('=====================');
  }

  static List<Route<dynamic>> get routeStack => List.from(_routeStack);
}