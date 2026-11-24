import 'package:flutter/widgets.dart';

class ParentSession extends ChangeNotifier {
  bool isParent = false;

  void enter() {
    if (isParent) return;
    isParent = true;
    notifyListeners();
  }

  void leave() {
    if (!isParent) return;
    isParent = false;
    notifyListeners();
  }
}

class ParentScope extends InheritedNotifier<ParentSession> {
  const ParentScope({
    Key? key,
    required ParentSession session,
    required Widget child,
  }) : super(key: key, notifier: session, child: child);

  static ParentSession of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ParentScope>();
    assert(scope != null, 'ParentScope is missing above this widget');
    return scope!.notifier!;
  }
}

bool isRightProduct(int left, int right, String input) {
  return int.tryParse(input.trim()) == left * right;
}
