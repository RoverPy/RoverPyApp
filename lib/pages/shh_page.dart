import 'package:flutter/material.dart';
import 'ssh.dart';

class SSHPage extends StatefulWidget {
  @override
  _SSHPageState createState() => _SSHPageState();
}

class _SSHPageState extends State<SSHPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Click'),
          onPressed: () {
            var client = SSHClient(
              host: 'ip_address',
              port: 3000,
              username: '',
              passwordOrKey: '',
            );
            client.connect();
            client.execute('ps');
          },
        ),
      ),
    );
  }
}
