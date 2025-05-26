import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/helpers/listener_service.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/pages/add_edit_text_page.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/pages/result_page.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/changes_list.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/select_image.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/settings/settings.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:universal_io/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const FlutterPainterExample(),
    );
  }
}

class FlutterPainterExample extends StatefulWidget {
  const FlutterPainterExample({super.key});

  @override
  State<FlutterPainterExample> createState() => _FlutterPainterExampleState();
}

class _FlutterPainterExampleState extends State<FlutterPainterExample> {
  late PainterController controller;
  bool ifOpenChangeList = true;
  bool openSettings = false;
  bool openLayers = false;
  bool openShapes = false;
  @override
  void initState() {
    super.initState();
    controller = PainterController();
    ListenerService().listen(controller, context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade800.withValues(alpha: 0.6),
      appBar: appBar,
      bottomNavigationBar: bottomBar,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            child: PainterWidget(controller: controller),
          ),
          if (ifOpenChangeList)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: ChangesList(controller: controller),
              ),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ColoredBox(
                color: Colors.grey.shade900,
                child: Options(
                  controller: controller,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: settings,
            ),
          ),
        ],
      ),
    );
  }

  Widget get settings {
    return Settings(
      controller: controller,
      openSettings: openSettings,
      openLayers: openLayers,
      openShapes: openShapes,
      changeSettings: ({bool value = false}) {
        setState(() {
          openSettings = value;
        });
      },
      changeLayers: ({bool value = false}) {
        setState(() {
          openLayers = value;
        });
      },
      changeShapes: ({bool value = false}) {
        setState(() {
          openShapes = value;
        });
      },
      setNewState: () => setState(() {}),
    );
  }

  PreferredSize get appBar {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Delete the selected drawable
            IconButton(
              icon: const Icon(
                PhosphorIconsRegular.listNumbers,
              ),
              onPressed: () {
                setState(() {
                  ifOpenChangeList = !ifOpenChangeList;
                });
              },
            ),

            IconButton(
              icon: Icon(
                PhosphorIconsRegular.trash,
                color: controller.value.selectedItem != null
                    ? Colors.white
                    : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  controller.removeItem();
                });
              },
            ),
            IconButton(
              icon: Icon(
                PhosphorIconsRegular.arrowCounterClockwise,
                color: (controller.changeActions.value.index == -1)
                    ? Colors.grey
                    : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  controller.undo();
                });
              },
            ),
            IconButton(
              icon: Icon(
                PhosphorIconsRegular.arrowClockwise,
                color: (controller.changeActions.value.index ==
                        controller.changeActions.value.changeList.length - 1)
                    ? Colors.grey
                    : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  controller.redo();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () async {
                  final image = await controller.renderImage();
                  if (image != null && context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => ResultPage(image: image),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.image,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get bottomBar {
    return Container(
      color: const Color(0xFF232323),
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 20 : 10,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button(
              PhosphorIconsRegular.eraser,
              () {
                setState(() {
                  controller.toggleErasing();
                });
              },
              enabled: controller.isErasing,
            ),
            button(
              PhosphorIconsRegular.scribble,
              () {
                setState(() {
                  controller.toggleDrawing();
                });
              },
              enabled: controller.isDrawing,
            ),
            button(
              PhosphorIconsRegular.textT,
              () async {
                var text = '';
                await Navigator.push(
                  context,
                  PageRouteBuilder<Object>(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AddEditTextPage(
                      onDone: (String textFunction) {
                        text = textFunction;
                      },
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
                await controller.addText(text);
                setState(() {});
              },
              enabled: controller.editingText || controller.addingText,
            ),
            button(
              PhosphorIconsRegular.image,
              () async {
                final imageUint8List = await showDialog<Uint8List>(
                  context: context,
                  builder: (context) => const SelectImageDialog(
                    title: 'Select Image',
                  ),
                );
                if (imageUint8List == null) return;
                controller.addImage(imageUint8List);
                setState(() {});
              },
            ),
            button(
              PhosphorIconsRegular.listBullets,
              () {
                setState(() {
                  openSettings = !openSettings;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget button(
    IconData icon,
    void Function()? onPressed, {
    bool enabled = false,
  }) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 6),
            decoration: BoxDecoration(
              color: enabled ? const Color(0xFF2580eb) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: enabled ? Colors.white : Colors.grey.shade500,
              ),
              onPressed: onPressed,
            ),
          ),
          Opacity(
            opacity: enabled ? 1 : 0,
            child: Container(
              height: 2,
              width: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
