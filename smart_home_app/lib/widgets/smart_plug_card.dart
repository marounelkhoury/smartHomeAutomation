import 'package:flutter/material.dart';
import '../models/smart_plug.dart';
import 'package:provider/provider.dart';
import '../providers/smart_plug_provider.dart';

class SmartPlugCard extends StatefulWidget {
  final SmartPlug plug;

  SmartPlugCard({required this.plug});

  @override
  _SmartPlugCardState createState() => _SmartPlugCardState();
}

class _SmartPlugCardState extends State<SmartPlugCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final smartPlugProvider = Provider.of<SmartPlugProvider>(context, listen: false);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: Icon(
              widget.plug.status ? Icons.power : Icons.power_off,
              color: widget.plug.status ? Colors.green : Colors.red,
              size: 30,
            ),
            title: Text(
              widget.plug.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.plug.status ? 'Status: ON' : 'Status: OFF',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: Switch(
              value: widget.plug.status,
              onChanged: (val) => smartPlugProvider.togglePlug(widget.plug.id, val),
              activeColor: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
