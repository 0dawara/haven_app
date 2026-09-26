import 'package:flutter/cupertino.dart';

class SaveDialog extends StatelessWidget {
  const SaveDialog({required this.stream, super.key});

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Save'),
      content: StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              const SizedBox(height: 10),
              if (snapshot.hasError) ...[
                Text(snapshot.error.toString()),
              ] else ...[
                switch (snapshot.connectionState) {
                  ConnectionState.none => const CupertinoActivityIndicator(),
                  ConnectionState.waiting => const CupertinoActivityIndicator(),
                  ConnectionState.active => const CupertinoActivityIndicator(),
                  ConnectionState.done => Container(),
                },
                const SizedBox(height: 10),
                Text('${snapshot.data}'),
              ],
            ],
          );
        },
      ),
    );
  }
}
