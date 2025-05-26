import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/widgets/categoria_model.dart';
import 'package:labart/widgets/seleccionar_categorias_screen.dart';

class CategoriasDialog extends StatefulWidget {
  final List<Categoria> categoriasSeleccionadas;
  final Function(List<Categoria>) onCategoriasUpdated;

  const CategoriasDialog({
    Key? key,
    required this.categoriasSeleccionadas,
    required this.onCategoriasUpdated,
  }) : super(key: key);

  @override
  State<CategoriasDialog> createState() => _CategoriasDialogState();
}

class _CategoriasDialogState extends State<CategoriasDialog> {
  late List<Categoria> _categoriasSeleccionadas;

  @override
  void initState() {
    super.initState();
    _categoriasSeleccionadas = List.from(widget.categoriasSeleccionadas);
  }

  void _removeCategoria(Categoria categoria) {
    setState(() {
      _categoriasSeleccionadas.remove(categoria);
    });
    widget.onCategoriasUpdated(_categoriasSeleccionadas);
  }

  Future<void> _editCategorias() async {
    final result = await Navigator.push<List<Categoria>>(
      context,
      MaterialPageRoute(
        builder: (context) => SeleccionarCategoriasScreen(
          categoriasSeleccionadas: _categoriasSeleccionadas,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _categoriasSeleccionadas = result;
      });
      widget.onCategoriasUpdated(_categoriasSeleccionadas);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 4,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tus categorías',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () => Navigator.pop(context),
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Lista de categorías
            if (_categoriasSeleccionadas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.tag_copy,
                      size: 48,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No has seleccionado categorías',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: _categoriasSeleccionadas.map((categoria) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isDark 
                          ? const Color.fromARGB(255, 25, 29, 31)
                          : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            categoria.imagenUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          categoria.nombre,
                          style: theme.textTheme.bodyLarge,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Iconsax.trash_copy,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: () => _removeCategoria(categoria),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onPressed: _editCategorias,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.edit_2_copy, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Editar',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Confirmar',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}