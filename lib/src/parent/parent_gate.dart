import 'dart:math';

import 'package:alippe/src/parent/parent_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> askParentGate(BuildContext context) async {
  final random = Random();
  final passed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return _ParentGateDialog(
        left: 6 + random.nextInt(4),
        right: 6 + random.nextInt(4),
      );
    },
  );
  return passed == true;
}

class _ParentGateDialog extends StatefulWidget {
  final int left;
  final int right;

  const _ParentGateDialog({required this.left, required this.right});

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  late int _left;
  late int _right;
  final _answer = TextEditingController();
  var _wrong = false;

  @override
  void initState() {
    super.initState();
    _left = widget.left;
    _right = widget.right;
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _check() {
    if (isRightProduct(_left, _right, _answer.text)) {
      Navigator.pop(context, true);
      return;
    }
    final random = Random();
    setState(() {
      _wrong = true;
      _left = 6 + random.nextInt(4);
      _right = 6 + random.nextInt(4);
      _answer.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ата-анаға өту'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_left × $_right = ?',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _answer,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Жауап',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _check(),
          ),
          if (_wrong) ...[
            const SizedBox(height: 8),
            const Text(
              'Қате. Жаңа мысал.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Болдырмау'),
        ),
        FilledButton(
          onPressed: _check,
          child: const Text('Тексеру'),
        ),
      ],
    );
  }
}
