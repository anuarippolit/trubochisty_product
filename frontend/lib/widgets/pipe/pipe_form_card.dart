import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/culvert_service.dart';

class PipeFormCard extends StatefulWidget {
  final CulvertData? initialData;
  final User user;
  final bool isEditing;
  final Future<void> Function(CulvertData updatedCulvert)? onSave;

  const PipeFormCard({
    Key? key,
    required this.user,
    this.initialData,
    this.isEditing = false,
    this.onSave,
  }) : super(key: key);

  @override
  _PipeFormCardState createState() => _PipeFormCardState();
}

class _PipeFormCardState extends State<PipeFormCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController roadController;
  late TextEditingController serialController;
  late TextEditingController pipeTypeController;
  late TextEditingController materialController;
  late TextEditingController diameterController;
  late TextEditingController lengthController;
  late TextEditingController headTypeController;
  late TextEditingController foundationTypeController;
  late TextEditingController workTypeController;
  late TextEditingController coordinatesController;
  late TextEditingController defectsController;

  List<File> _newPhotos = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    addressController = TextEditingController(text: d?.address ?? '');
    roadController = TextEditingController(text: d?.road ?? '');
    serialController = TextEditingController(text: d?.serialNumber ?? '');
    pipeTypeController = TextEditingController(text: d?.pipeType ?? '');
    materialController = TextEditingController(text: d?.material ?? '');
    diameterController = TextEditingController(text: d?.diameter ?? '');
    lengthController = TextEditingController(text: d?.length ?? '');
    headTypeController = TextEditingController(text: d?.headType ?? '');
    foundationTypeController = TextEditingController(text: d?.foundationType ?? '');
    workTypeController = TextEditingController(text: d?.workType ?? '');
    coordinatesController = TextEditingController(text: d?.coordinates ?? '');
    defectsController = TextEditingController(
      text: (d?.defects.isNotEmpty == true) ? d!.defects.join(', ') : '',
    );
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 70);
    if (picked.isNotEmpty) {
      setState(() {
        _newPhotos.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _deletePhoto(String url) async {
    if (widget.initialData != null) {
      await CulvertService().deletePhoto(widget.initialData!.id, url, widget.user);
      setState(() => widget.initialData!.photos.remove(url));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final defectsList = defectsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final culvert = CulvertData(
      id: widget.initialData?.id ?? '',
      users: [widget.user],
      address: addressController.text.trim(),
      coordinates: coordinatesController.text.trim(),
      road: roadController.text.trim().isNotEmpty ? roadController.text.trim() : null,
      serialNumber: serialController.text.trim().isNotEmpty ? serialController.text.trim() : null,
      pipeType: pipeTypeController.text.trim().isNotEmpty ? pipeTypeController.text.trim() : null,
      material: materialController.text.trim().isNotEmpty ? materialController.text.trim() : null,
      diameter: diameterController.text.trim().isNotEmpty ? diameterController.text.trim() : null,
      length: lengthController.text.trim().isNotEmpty ? lengthController.text.trim() : null,
      headType: headTypeController.text.trim().isNotEmpty ? headTypeController.text.trim() : null,
      foundationType: foundationTypeController.text.trim().isNotEmpty ? foundationTypeController.text.trim() : null,
      workType: workTypeController.text.trim().isNotEmpty ? workTypeController.text.trim() : null,
      constructionDate: widget.initialData?.constructionDate,
      lastRepairDate: widget.initialData?.lastRepairDate,
      lastInspectionDate: widget.initialData?.lastInspectionDate,
      strengthRating: widget.initialData?.strengthRating ?? 0,
      safetyRating: widget.initialData?.safetyRating ?? 0,
      maintainabilityRating: widget.initialData?.maintainabilityRating ?? 0,
      generalConditionRating: widget.initialData?.generalConditionRating ?? 0,
      defects: defectsList,
      photos: widget.initialData?.photos ?? [],
      createdAt: widget.initialData?.createdAt,
      updatedAt: widget.initialData?.updatedAt,
    );

    try {
      await widget.onSave?.call(culvert);
      // if you need to upload new photos separately, do it here via
      // CulvertService().uploadPhotos(...)
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.initialData?.photos ?? [];
    return AlertDialog(
      title: Text(widget.isEditing ? 'Редактировать трубу' : 'Новая труба'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Адрес'),
              validator: (v) => v == null || v.isEmpty ? 'Введите адрес' : null,
            ),
            TextFormField(
              controller: roadController,
              decoration: const InputDecoration(labelText: 'Дорога'),
            ),
            TextFormField(
              controller: serialController,
              decoration: const InputDecoration(labelText: 'Серийный номер'),
            ),
            TextFormField(
              controller: pipeTypeController,
              decoration: const InputDecoration(labelText: 'Тип трубы'),
            ),
            TextFormField(
              controller: materialController,
              decoration: const InputDecoration(labelText: 'Материал'),
            ),
            TextFormField(
              controller: diameterController,
              decoration: const InputDecoration(labelText: 'Диаметр'),
            ),
            TextFormField(
              controller: lengthController,
              decoration: const InputDecoration(labelText: 'Длина'),
            ),
            TextFormField(
              controller: headTypeController,
              decoration: const InputDecoration(labelText: 'Тип головки'),
            ),
            TextFormField(
              controller: foundationTypeController,
              decoration: const InputDecoration(labelText: 'Тип основания'),
            ),
            TextFormField(
              controller: workTypeController,
              decoration: const InputDecoration(labelText: 'Тип работы'),
            ),
            TextFormField(
              controller: coordinatesController,
              decoration: const InputDecoration(labelText: 'Координаты'),
              validator: (v) => v == null || v.isEmpty ? 'Введите координаты' : null,
            ),
            TextFormField(
              controller: defectsController,
              decoration: const InputDecoration(labelText: 'Дефекты (через запятую)'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...existing.map((url) => Stack(
                      children: [
                        Image.network('http://localhost:8080$url', width: 80, height: 80, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _deletePhoto(url),
                          ),
                        ),
                      ],
                    )),
                ..._newPhotos.map((f) => Image.file(f, width: 80, height: 80, fit: BoxFit.cover)),
                IconButton(icon: const Icon(Icons.add_a_photo), onPressed: _pickPhoto),
              ],
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
        ElevatedButton(onPressed: _isSaving ? null : _save, child: const Text('Сохранить')),
      ],
    );
  }
}
