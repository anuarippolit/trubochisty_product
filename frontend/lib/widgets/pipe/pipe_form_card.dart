import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/culvert_service.dart';
import 'package:frontend/widgets/pipe_card.dart';

class PipeFormCard extends StatefulWidget {
  final CulvertData? initialData;
  final User user;
  final bool isEditing;
  final void Function(CulvertData updatedCulvert)? onSave;

  const PipeFormCard({
    super.key,
    required this.user,
    this.initialData,
    this.isEditing = false,
    this.onSave,
  });

  @override
  State<PipeFormCard> createState() => _PipeFormCardState();
}

class _PipeFormCardState extends State<PipeFormCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController diameterController;
  late TextEditingController coordinatesController;
  List<File> _newPhotos = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.initialData?.address ?? '');
    diameterController = TextEditingController(text: widget.initialData?.diameter ?? '');
    coordinatesController = TextEditingController(text: widget.initialData?.coordinates ?? '');
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
      setState(() {
        widget.initialData!.photos.remove(url);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final edited = CulvertData(
      id: widget.initialData?.id ?? '',
      address: addressController.text,
      diameter: diameterController.text,
      coordinates: coordinatesController.text,
      photos: widget.initialData?.photos ?? [],
      strengthRating: widget.initialData?.strengthRating ?? 0.0,
      safetyRating: widget.initialData?.safetyRating ?? 0.0,
      maintainabilityRating: widget.initialData?.maintainabilityRating ?? 0.0,
      generalConditionRating: widget.initialData?.generalConditionRating ?? 0.0,
      users: [widget.user],
    );

    try {
      if (!widget.isEditing) {
        final created = await CulvertService().createCulvert(edited, _newPhotos, widget.user);
        widget.onSave?.call(created);
      } else {
        final updated = await CulvertService().updateCulvert(edited.id, edited, widget.user);
        if (_newPhotos.isNotEmpty) {
          await CulvertService().uploadPhotos(updated.id, _newPhotos, widget.user);
        }
        widget.onSave?.call(updated);
      }
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingPhotos = widget.initialData?.photos ?? [];

    return AlertDialog(
      title: Text(widget.isEditing ? 'Редактировать трубу' : 'Новая труба'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Адрес'),
                validator: (value) => value == null || value.isEmpty ? 'Введите адрес' : null,
              ),
              TextFormField(
                controller: diameterController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Диаметр'),
                validator: (value) => value == null || value.isEmpty ? 'Введите диаметр' : null,
              ),
              TextFormField(
                controller: coordinatesController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Координаты'),
                validator: (value) => value == null || value.isEmpty ? 'Введите координаты' : null,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...existingPhotos.map(
                    (url) => Stack(
                      children: [
                        Image.network(
                          'http://localhost:8080$url',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _deletePhoto(url),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._newPhotos.map(
                    (file) => Image.file(
                      file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: _pickPhoto,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:ui';
// import '../../models/culvert_data.dart';
// import 'pipe_header.dart';
// import 'identification_section.dart';
// import 'technical_section.dart';
// import 'additional_section.dart';
// import 'condition_section.dart';
// import 'action_buttons.dart';

// class PipeFormCard extends StatefulWidget {
//   final CulvertData? initialData;
//   final Function(CulvertData)? onDataChanged;
  
//   const PipeFormCard({
//     super.key,
//     this.initialData,
//     this.onDataChanged,
//   });

//   @override
//   State<PipeFormCard> createState() => _PipeFormCardState();
// }

// class _PipeFormCardState extends State<PipeFormCard> with TickerProviderStateMixin {
//   late CulvertData _culvertData;
//   late CulvertData _originalData; // Track original data to detect changes
  
//   // Animation controllers
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   // Use keys to access section states
//   final GlobalKey<IdentificationSectionState> _identificationKey = 
//       GlobalKey<IdentificationSectionState>();
//   final GlobalKey<TechnicalSectionState> _technicalKey = 
//       GlobalKey<TechnicalSectionState>();
//   final GlobalKey<AdditionalSectionState> _additionalKey = 
//       GlobalKey<AdditionalSectionState>();

//   @override
//   void initState() {
//     super.initState();
    
//     _culvertData = widget.initialData ?? CulvertData();
//     _originalData = _culvertData; // Store original for comparison
    
//     // Initialize animations
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void didUpdateWidget(PipeFormCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
//       setState(() {
//         _culvertData = widget.initialData!;
//         _originalData = widget.initialData!;
//       });
//     }
//   }

//   void _updateData(CulvertData updatedData) {
//     // Only update rating changes in real-time (sliders)
//     // Text field changes are handled on save only
//     setState(() {
//       _culvertData = updatedData;
//     });
//   }

//   void _handleSave() {
//     // Collect data from all sections
//     var updatedData = _culvertData;
    
//     if (_identificationKey.currentState != null) {
//       updatedData = _identificationKey.currentState!.getCurrentData();
//     }
//     if (_technicalKey.currentState != null) {
//       updatedData = _technicalKey.currentState!.getCurrentData();
//     }
//     if (_additionalKey.currentState != null) {
//       updatedData = _additionalKey.currentState!.getCurrentData();
//     }
    
//     setState(() {
//       _culvertData = updatedData;
//       _originalData = updatedData;
//     });
//     widget.onDataChanged?.call(updatedData);
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
    
//     return SafeArea(
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Container(
//             margin: const EdgeInsets.all(20),
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height - 100,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   colorScheme.surface.withOpacity(0.9),
//                   colorScheme.surfaceVariant.withOpacity(0.8),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: colorScheme.shadow.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//                 BoxShadow(
//                   color: colorScheme.primary.withOpacity(0.05),
//                   blurRadius: 40,
//                   offset: const Offset(0, 16),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: colorScheme.surface.withOpacity(0.7),
//                     border: Border.all(
//                       color: colorScheme.outline.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       // Scrollable Content (now includes header)
//                       Expanded(
//                         child: SingleChildScrollView(
//                           padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Header (now scrolls with content)
//                               PipeHeader(),
//                               const SizedBox(height: 24),
                              
//                               IdentificationSection(
//                                 data: _culvertData,
//                                 onDataChanged: _updateData,
//                                 key: _identificationKey,
//                               ),
//                               const SizedBox(height: 24),
//                               TechnicalSection(
//                                 data: _culvertData,
//                                 onDataChanged: _updateData,
//                                 key: _technicalKey,
//                               ),
//                               const SizedBox(height: 24),
//                               AdditionalSection(
//                                 data: _culvertData,
//                                 onDataChanged: _updateData,
//                                 key: _additionalKey,
//                               ),
//                               const SizedBox(height: 24),
//                               ConditionSection(
//                                 data: _culvertData,
//                                 onDataChanged: _updateData,
//                               ),
//                               const SizedBox(height: 32),
//                               ActionButtons(
//                                 data: _culvertData,
//                                 onSave: _handleSave,
//                               ),
//                               SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// } 