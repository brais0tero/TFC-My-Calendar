import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

/// Empty Title & Subtite TextFields Warning
emptyFieldsWarning(context) {
  return FToast.toast(
    context,
    msg: "Please fill all the fields",
    subMsg: "You must fill all Fields!",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing Enter When user try to edit the current tesk
nothingEnterOnUpdateEventMode(context) {
  return FToast.toast(
    context,
    msg: "Nothing Enter",
    subMsg: "You must edit the even then try to update it!",
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task Warning Dialog
dynamic warningNoTask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: "No Task",
    message:
        "There is no Event For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// Delete All Task Dialog
dynamic deleteAllEvents(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: "Delete All Events",
    message:
        "Do You really want to delete all events? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}


