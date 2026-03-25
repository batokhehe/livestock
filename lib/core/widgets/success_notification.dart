import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/router.dart';
import '../theme/AppColors.dart';
import '../theme/AppTypography.dart';

class SuccessNotification {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show({
    required String title,
    required String subtitle,
    Duration duration = const Duration(seconds: 5),
  }) {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    dismiss();

    _overlayEntry = OverlayEntry(
      builder: (context) => _NotificationWidget(
        title: title,
        subtitle: subtitle,
        onDismiss: dismiss,
      ),
    );

    overlay.insert(_overlayEntry!);

    _timer = Timer(duration, () {
      dismiss();
    });
  }

  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _timer?.cancel();
    _timer = null;
  }
}

class _NotificationWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDismiss;

  const _NotificationWidget({
    required this.title,
    required this.subtitle,
    required this.onDismiss,
  });

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: kElevationToShadow[4]
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppTypography.mediumBoldBlack,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: AppTypography.smallNormalGrey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.black, width: 1),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
