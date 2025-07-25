import 'package:flutter/material.dart';
import 'package:frontend/models/culvert_data.dart';

class PipeCard extends StatelessWidget {
  final CulvertData culvert;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PipeCard({
    super.key,
    required this.culvert,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          culvert.address,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          'Диаметр: ${culvert.diameter ?? '—'} мм\n'
          'Координаты: ${culvert.coordinates ?? '—'}',
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Удалить',
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../models/culvert_data.dart';
// import 'pipe/pipe_form_card.dart';
// import '../models/user.dart';

// class PipeCard extends StatelessWidget {
//   final CulvertData? initialData;
//   final Function(CulvertData)? onDataChanged;
//   final VoidCallback? onEdit;
//   final User user;

//   const PipeCard({
//     super.key,
//     required this.user,
//     this.initialData,
//     this.onDataChanged,
//     this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PipeFormCard(
//       user: user,
//       culvert: initialData,
//       onSave: onDataChanged,
//       onEdit: onEdit,
//     );
//   }
// }
