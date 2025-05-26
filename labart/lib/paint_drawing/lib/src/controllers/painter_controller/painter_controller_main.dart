part of 'painter_controller.dart';

extension PainterControllerMain on PainterController {
  /// Sets a background image for the painter.
  Future<void> setBackgroundImage(Uint8List? imageData) async {
    final oldBackgroundImage = background.image;
    cacheBackgroundImage = null;
    background.image = imageData;

    addAction(
      ActionChangeBackgroundImage(
        newImage: imageData,
        oldImage: oldBackgroundImage,
        timestamp: DateTime.now(),
        actionType: ActionType.changeBackgroundImage,
      ),
    );
  }

  /// Triggers an event for all listeners of the event stream.
  void triggerEvent(ControllerEvent event) {
    _eventController.add(event);
  }

  /// Listens to events triggered by the controller
  /// and executes the provided callback.
  /// Returns a subscription that can be used to manage the listener.
  StreamSubscription<ControllerEvent> eventListener(
    void Function(ControllerEvent) onData,
  ) {
    return _eventController.stream.listen(onData);
  }

  void refreshValue() {
    value = value.copyWith();
  }
}
