// Enum that defines the various types of actions that can be performed.
enum ActionType {
  addedTextItem, // Action to add a text item.
  addedImageItem, // Action to add an image item.
  addedShapeItem, // Action to add a shape item.
  addedCustomWidgetItem, // Action to add a custom widget item.
  positionItem, // Action to change the position of an item.
  sizeItem, // Action to change the size of an item.
  rotationItem, // Action to rotate an item.
  changedLayerIndex, // Action to change the layer index of an item.
  removedItem, // Action to remove an item.
  draw, // Action to draw something on the canvas.
  erase, // Action to erase something from the canvas.
  changeTextValue, // Action to change the value of a text item.
  changeImageValue, // Action to change the value of an image item.
  changeShapeValue, // Action to change the value of a shape item.
  changeCustomWidgetValue, // Action to change the value of a
  //custom widget item.
  changeBackgroundImage, // Action to change the value of a background image.
}
