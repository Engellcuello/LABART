import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/layer/layer_change_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/add_item_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/background_image_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/custom_widget_actions/custom_widget_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/draw_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/erase_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/image_actions/image_change_value_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/position_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/remove_item_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/rotate_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/shape_actions/shape_change_value_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/size_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_actions.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/text_actions/text_change_value_action.dart';
import 'package:labart/features/paint_drawing/lib/src/models/brush_model.dart';

part 'actions/actions_service_main.dart';
part 'actions/actions_service_action.dart';
part 'actions/actions_service_item.dart';
part 'actions/actions_service_size.dart';
part 'actions/actions_service_position.dart';
part 'actions/actions_service_layer.dart';
part 'actions/actions_service_rotation.dart';
part 'actions/actions_service_brush.dart';

class ActionsService {
  // Keeps track of the list of actions performed.
  List<PaintAction> currentActions = [];
  // The current index in the actions list.
  int currentIndex = 0;
  // List of items in the painting, representing the objects being manipulated.
  List<PainterItem> items = [];
  // Stores the painting paths for drawing or erasing.
  List<List<DrawModel?>> currentPaintPath = [];

  Uint8List? backgroundImage;
}
