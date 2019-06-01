import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class MainLocalizations {
  static Future<MainLocalizations> load(Locale locale) {
//    final String name =
//        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(locale.toString());

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return MainLocalizations();
    });
  }

  static MainLocalizations of(BuildContext context) {
    return Localizations.of<MainLocalizations>(context, MainLocalizations);
  }

  String get title {
    return Intl.message(
      'Todo2Wish',
      name: 'title',
      desc: 'Title of the application',
    );
  }

  String get actionCancel {
    return Intl.message(
      'CANCEL',
      name: 'actionCancel',
    );
  }

  String get actionDelete {
    return Intl.message(
      'DELETE',
      name: 'actionDelete',
    );
  }

  String get actionDone {
    return Intl.message(
      'DONE',
      name: 'actionDone',
    );
  }

  String get actionUndone {
    return Intl.message(
      'UNDONE',
      name: 'actionUndone',
    );
  }

  String get actionFulfill {
    return Intl.message(
      'FULFILL',
      name: 'actionFulfill',
    );
  }

  String get actionUnfulfilled {
    return Intl.message(
      'UNFULFILLED',
      name: 'actionUnfulfilled',
    );
  }

  String get tasksTitle {
    return Intl.message(
      'Tasks',
      name: 'tasksTitle',
      desc: 'Title of the tasks tab',
    );
  }

  String get tasksDone {
    return Intl.message(
      'Done',
      name: 'tasksDone',
      desc: 'Title of the tasks done expandable',
    );
  }

  String get tasksNewTitleHint {
    return Intl.message(
      'What to get done?',
      name: 'tasksNewTitleHint',
      desc: 'Placeholder text',
    );
  }

  String get tasksNewCreationDateHint {
    return Intl.message(
      'Since when?',
      name: 'tasksNewCreationDateHint',
      desc: 'Placeholder text',
    );
  }

  String tasksConfirmDone(taskTitle) {
    return Intl.message(
      'Mark task "$taskTitle" as done?',
      name: 'tasksConfirmDone',
      args: [taskTitle],
      desc: 'Confirmation modal question',
    );
  }

  String tasksConfirmDelete(taskTitle) {
    return Intl.message(
      'Delete task "$taskTitle"?',
      name: 'tasksConfirmDelete',
      args: [taskTitle],
      desc: 'Confirmation modal question',
    );
  }

  String get wishesTitle {
    return Intl.message(
      'Wishes',
      name: 'wishesTitle',
      desc: 'Title of the wishes tab',
    );
  }

  String get wishesFulfilled {
    return Intl.message(
      'Fulfilled',
      name: 'wishesFulfilled',
      desc: 'Title of the wishes fulfilled expandable',
    );
  }

  String get wishesNewTitleHint {
    return Intl.message(
      'What\'s your wish?',
      name: 'wishesNewTitleHint',
      desc: 'Placeholder text',
    );
  }

  String get wishesNewValueHint {
    return Intl.message(
      'How much is it worth to you?',
      name: 'wishesNewValueHint',
      desc: 'Placeholder text',
    );
  }

  String wishesConfirmFulfill(wishTitle) {
    return Intl.message(
      'Mark wish "$wishTitle" as fulfilled?',
      name: 'wishesConfirmFulfill',
      args: [wishTitle],
      desc: 'Confirmation modal question',
    );
  }

  String wishesConfirmUnfulfilled(wishTitle) {
    return Intl.message(
      'Mark wish "$wishTitle" as unfulfilled?',
      name: 'wishesConfirmUnfulfilled',
      args: [wishTitle],
      desc: 'Confirmation modal question',
    );
  }

  String wishesConfirmDelete(wishTitle) {
    return Intl.message(
      'Delete wish "$wishTitle"?',
      name: 'wishesConfirmDelete',
      args: [wishTitle],
      desc: 'Confirmation modal question',
    );
  }
}

class MainLocalizationsDelegate
    extends LocalizationsDelegate<MainLocalizations> {
  const MainLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<MainLocalizations> load(Locale locale) =>
      MainLocalizations.load(locale);

  @override
  bool shouldReload(MainLocalizationsDelegate old) => false;
}
