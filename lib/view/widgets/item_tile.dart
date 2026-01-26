import 'package:flutter/material.dart';
import 'package:kids_space_admin/model/tile_model.dart';
import 'package:kids_space_admin/utils/tile_helper.dart';

class Tile extends StatelessWidget {
  final TileModel model;
  final VoidCallback? onTap;

  const Tile({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = titleForType(model.type);

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Icon(model.icon, size: 24),),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}