import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateUsScreen extends StatefulWidget {
  const RateUsScreen({super.key});

  @override
  State<StatefulWidget> createState() => RateUsScreenState();
}

class RateUsScreenState extends State<RateUsScreen> {
  WidgetBuilder builder = buildProgressIndicator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Us'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: RateMyAppBuilder(
        rateMyApp: RateMyApp(
          googlePlayIdentifier: 'app.openauthenticator',
          appStoreIdentifier: '6479272927',
        ),
        builder: builder,
        onInitialized: (context, rateMyApp) {
          setState(() {
            builder = (context) => ContentWidget(rateMyApp: rateMyApp);
          });
          if (kDebugMode) {
            for (Condition condition in rateMyApp.conditions) {
              if (condition is DebuggableCondition) {
                condition.printToConsole();
              }
            }
            print(
              'Are all conditions met: ${rateMyApp.shouldOpenDialog ? 'Yes' : 'No'}',
            );
          }
          if (rateMyApp.shouldOpenDialog) {
            rateMyApp.showRateDialog(context);
          }
        },
      ),
    );
  }

  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ContentWidget extends StatefulWidget {
  final RateMyApp rateMyApp;

  const ContentWidget({super.key, required this.rateMyApp});

  @override
  State<StatefulWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  List<DebuggableCondition> debuggableConditions = [];
  bool shouldOpenDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                for (DebuggableCondition condition in debuggableConditions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      condition.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                Text(
                  'Are conditions met: ${shouldOpenDialog ? 'Yes' : 'No'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                buildButton(
                  context,
                  label: 'Launch "Rate Us" Dialog',
                  onPressed: () async {
                    await widget.rateMyApp.showRateDialog(
                      context,
                      ignoreNativeDialog: kDebugMode,
                    );
                    refresh();
                  },
                ),
                const SizedBox(height: 12),
                buildButton(
                  context,
                  label: 'Launch "Star Rating" Dialog',
                  onPressed: () async {
                    await widget.rateMyApp.showStarRateDialog(
                      context,
                      actionsBuilder:
                          (_, stars) =>
                              starRateDialogActionsBuilder(context, stars),
                      ignoreNativeDialog: kDebugMode,
                    );
                    refresh();
                  },
                ),
                const SizedBox(height: 12),
                buildButton(
                  context,
                  label: 'Reset Conditions',
                  onPressed: () async {
                    await widget.rateMyApp.reset();
                    refresh();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  void refresh() {
    setState(() {
      debuggableConditions =
          widget.rateMyApp.conditions.whereType<DebuggableCondition>().toList();
      shouldOpenDialog = widget.rateMyApp.shouldOpenDialog;
    });
  }

  List<Widget> starRateDialogActionsBuilder(
    BuildContext context,
    double? stars,
  ) {
    final cancelButton = RateMyAppNoButton(
      widget.rateMyApp,
      text: MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase(),
      callback: refresh,
    );

    if (stars == null || stars == 0) {
      return [cancelButton];
    }

    String message = 'You put ${stars.round()} star(s).';
    Color color = Colors.black;

    switch (stars.round()) {
      case 1:
        message += ' Did this app hurt you physically?';
        color = Colors.red;
        break;
      case 2:
        message += ' That\'s not really cool.';
        color = Colors.orange;
        break;
      case 3:
        message += ' Well, it\'s average.';
        color = Colors.amber;
        break;
      case 4:
        message += ' This is cool!';
        color = Colors.lightGreen;
        break;
      case 5:
        message += ' Great! Thank you!';
        color = Colors.green;
        break;
    }

    return [
      TextButton(
        onPressed: () async {
          if (kDebugMode) {
            print(message);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: color),
          );
          await widget.rateMyApp.callEvent(
            RateMyAppEventType.rateButtonPressed,
          );
          if (context.mounted) {
            Navigator.pop<RateMyAppDialogButton>(
              context,
              RateMyAppDialogButton.rate,
            );
            refresh();
          }
        },
        child: Text(
          MaterialLocalizations.of(context).okButtonLabel.toUpperCase(),
        ),
      ),
      cancelButton,
    ];
  }
}
