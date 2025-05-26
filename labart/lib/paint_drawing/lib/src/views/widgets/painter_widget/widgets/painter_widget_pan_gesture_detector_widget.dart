part of '../painter_widget.dart';

// A simple stateless widget that detects pan gestures on its child.
class _PanGestureDetector extends StatelessWidget {
  const _PanGestureDetector({
    this.child,
    this.touchSlop,
    this.onPanEnd,
    this.onPanUpdate,
  });

  final Widget? child;

  // The touch slop (distance the pointer must move to be recognized as a drag).
  final double? touchSlop;

  final GestureDragEndCallback? onPanEnd;
  final GestureDragUpdateCallback? onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        PanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          // Create a PanGestureRecognizer with optional custom touch slop.
          () => PanGestureRecognizer()
            ..gestureSettings = DeviceGestureSettings(touchSlop: touchSlop),

          // Set up the recognizer's callbacks.
          (PanGestureRecognizer detector) {
            detector
              ..onUpdate = onPanUpdate
              ..onEnd = onPanEnd;
          },
        ),
      },
      child: child,
    );
  }
}
