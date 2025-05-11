import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';

class AuthPageContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showAppBar;

  const AuthPageContainer({
    super.key,
    required this.child,
    this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          showAppBar && title != null
              ? AppBar(title: Text(title!), centerTitle: true)
              : null,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing * 2),
          child: SizedBox(
            width:
                context.isDesktop
                    ? context.wp(0.3)
                    : context.isTablet
                    ? context.wp(0.5)
                    : context.wp(0.9),
            child: child,
          ),
        ),
      ),
    );
  }
}
