import 'dart:async';
import 'package:flutter/material.dart';

/// Franja inferior con texto desplazándose horizontalmente, usada en T-02 y T-03.
class TickerBar extends StatefulWidget {
  final String text;
  const TickerBar({super.key, required this.text});

  @override
  State<TickerBar> createState() => _TickerBarState();
}

class _TickerBarState extends State<TickerBar> {
  final _controller = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      final next = _controller.offset + 1.2;
      _controller.jumpTo(next >= max ? 0 : next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
