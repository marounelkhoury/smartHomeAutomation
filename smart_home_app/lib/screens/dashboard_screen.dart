// Updated DashboardScreen with Settings Icon
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_plug_provider.dart';
import '../widgets/smart_plug_card.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<SmartPlugProvider>(context, listen: false).fetchPlugs());
  }

  @override
  Widget build(BuildContext context) {
    final smartPlugProvider = Provider.of<SmartPlugProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Plugs'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<SmartPlugProvider>(
        builder: (context, provider, child) {
          if (provider.plugs.isEmpty) {
            return Center(child: Text("No smart plugs found"));
          }

          return ListView.builder(
            itemCount: provider.plugs.length,
            itemBuilder: (context, index) {
              final plug = provider.plugs[index];
              return SmartPlugCard(plug: plug);
            },
          );
        },
      ),
    );
  }
}
