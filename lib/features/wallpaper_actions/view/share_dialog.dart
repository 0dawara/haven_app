import 'package:flutter/cupertino.dart';
import 'package:haven/l10n/l10n.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.onPressedFile,
    required this.onPressedLink,
    super.key,
  });

  final VoidCallback onPressedFile;
  final VoidCallback onPressedLink;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(context.l10n.shareTitle),
      content: Text(context.l10n.shareQuestion),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onPressedFile,
          child: Text(context.l10n.shareFile),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onPressedLink,
          child: Text(context.l10n.shareLink),
        ),
      ],
    );
  }
}
