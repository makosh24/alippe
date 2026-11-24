import 'dart:math' as math;

import 'package:alippe/src/components/AlphabetsComponents/ccard.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// How far a finger must travel to move the centered letter by one step.
const double coneSpacing = 120;

/// Friction used to guess where a flick would come to rest.
/// Smaller keeps less speed, so the row travels a shorter distance.
const double coneDrag = 0.2;

/// Index the strip should settle on after a flick.
/// [velocityItems] is in letters per second; positive moves toward later letters.
double coneSnapTarget({
  required double position,
  required double velocityItems,
  required int count,
}) {
  if (count <= 1) return 0;
  final last = (count - 1).toDouble();
  final projected = position - velocityItems / math.log(coneDrag);
  var target = projected.roundToDouble();
  if (velocityItems.abs() > 1.2 && (target - position).abs() < 0.5) {
    target = velocityItems > 0
        ? position.floorToDouble() + 1
        : position.ceilToDouble() - 1;
  }
  if (target < 0) return 0;
  if (target > last) return last;
  return target;
}

double _offsetX(double delta) {
  final distance = delta.abs();
  final direction = delta.sign;
  if (distance <= 1) return direction * distance * coneSpacing;
  return direction * (coneSpacing + (distance - 1) * 36);
}

double _angle(double delta) {
  return -delta.clamp(-1.0, 1.0) * 0.8;
}

double _scale(double delta) {
  final distance = delta.abs();
  if (distance <= 1) return 1.18 - distance * 0.28;
  return math.max(0.62, 0.9 - (distance - 1) * 0.06);
}

/// One horizontal Cover Flow row. The centered letter is flat and large.
/// Letters to either side shrink, turn away, and stack like a cone.
class LetterCone extends StatefulWidget {
  final List<Alphabets> letters;
  final ValueChanged<Alphabets> onOpen;

  const LetterCone({
    super.key,
    required this.letters,
    required this.onOpen,
  });

  @override
  State<LetterCone> createState() => _LetterConeState();
}

class _LetterConeState extends State<LetterCone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  double _position = 0;
  double _from = 0;
  double _to = 0;
  int _latched = 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this)
      ..addListener(() {
        final t = Curves.easeOutCubic.transform(_anim.value);
        setState(() => _setPosition(_from + (_to - _from) * t));
      });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  int _clampIndex(num value) {
    final last = math.max(0, widget.letters.length - 1);
    return value.round().clamp(0, last).toInt();
  }

  void _setPosition(double value) {
    final next = _clampIndex(value);
    if (next != _latched) {
      _latched = next;
      HapticFeedback.selectionClick();
    }
    _position = value;
  }

  void _stop() {
    if (_anim.isAnimating) _anim.stop();
  }

  void _dragBy(double dx) {
    _stop();
    final last = (widget.letters.length - 1).toDouble();
    var next = _position - dx / coneSpacing;
    if (next < 0) {
      next /= 3;
    } else if (next > last) {
      next = last + (next - last) / 3;
    }
    setState(() => _setPosition(next));
  }

  void _animateTo(double target) {
    final last = (widget.letters.length - 1).toDouble();
    final end = target.clamp(0.0, math.max(0, last)).toDouble();
    if ((_position - end).abs() < 0.001) {
      setState(() => _setPosition(end));
      return;
    }
    _from = _position;
    _to = end;
    final distance = (_to - _from).abs();
    final ms = (320 + distance * 75).round().clamp(280, 980);
    _anim.duration = Duration(milliseconds: ms);
    _anim.forward(from: 0);
  }

  void _fling(double pixelsPerSecond) {
    final velocity =
        (-pixelsPerSecond / coneSpacing).clamp(-20.0, 20.0).toDouble();
    final target = coneSnapTarget(
      position: _position,
      velocityItems: velocity,
      count: widget.letters.length,
    );
    _animateTo(target);
  }

  void _activate(int index) {
    final focused = _clampIndex(_position);
    if (index == focused && (_position - focused).abs() < 0.45) {
      widget.onOpen(widget.letters[index]);
      return;
    }
    _animateTo(index.toDouble());
  }

  int _indexAt(double localX, double width) {
    final dx = localX - width / 2;
    var best = _clampIndex(_position);
    var bestDistance = double.infinity;
    for (var i = 0; i < widget.letters.length; i++) {
      final gap = (_offsetX(i - _position) - dx).abs();
      if (gap < bestDistance) {
        bestDistance = gap;
        best = i;
      }
    }
    if (bestDistance > 110) return -1;
    return best;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.letters.isEmpty) return const SizedBox.expand();

    final order = List<int>.generate(widget.letters.length, (i) => i)
      ..sort(
        (a, b) => (b - _position).abs().compareTo((a - _position).abs()),
      );

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => _stop(),
          onHorizontalDragUpdate: (details) => _dragBy(details.delta.dx),
          onHorizontalDragEnd: (details) =>
              _fling(details.velocity.pixelsPerSecond.dx),
          onTapUp: (details) {
            final index = _indexAt(details.localPosition.dx, constraints.maxWidth);
            if (index >= 0) _activate(index);
          },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              for (final index in order)
                if ((index - _position).abs() < 8)
                  _letter(index, constraints.maxWidth, constraints.maxHeight),
            ],
          ),
        );
      },
    );
  }

  Widget _letter(int index, double width, double height) {
    final letter = widget.letters[index];
    final delta = index - _position;
    final distance = delta.abs();
    final scale = _scale(delta);
    // A bitmap filter flattens rotateY and hides every letter but the
    // center one. This stays a real 3D transform.
    final turn = Matrix4.identity()
      ..rotateY(_angle(delta))
      ..scaleByDouble(scale, scale, 1, 1);
    turn.setEntry(3, 2, 0.0012);
    const slot = 130.0;
    final dx = _offsetX(delta);
    final dy = -88 + math.min(distance * 16, 52);
    final color = Colors.primaries[index % Colors.primaries.length];

    return Positioned(
      left: width / 2 + dx - slot / 2,
      top: height / 2 + dy - slot / 2,
      width: slot,
      height: slot,
      child: Semantics(
        button: true,
        label: '${letter.name}${letter.smallName}',
        onTap: () => _activate(index),
        child: ExcludeSemantics(
          child: Transform(
            alignment: Alignment.center,
            transform: turn,
            child: Opacity(
              opacity: (1 - distance * 0.07).clamp(0.55, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E8),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: color, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 16,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: CCard(
                  letter: letter.name,
                  smallLetter: letter.smallName,
                  color: color,
                  filled: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
