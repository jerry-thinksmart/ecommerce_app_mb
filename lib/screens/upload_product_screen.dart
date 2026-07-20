import 'package:ecommerce_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  static const routeName = '/upload-product';

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shipDateController = TextEditingController();

  String _title = '';
  String _description = '';
  double _price = 0;
  DateTime? _shipDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _shipDateController.dispose();
    super.dispose();
  }

  Future<void> _selectShipDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _shipDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (selectedDate == null) return;

    setState(() {
      _shipDate = selectedDate;
      _shipDateController.text = _formatDate(selectedDate);
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    try {
      await context.read<ProductsProvider>().addProduct(
        title: _title,
        description: _description,
        price: _price,
        shipDate: _shipDate!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully.')),
      );
      Navigator.of(context).pop();
    } on ProductProviderException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not upload the product. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Product')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Product details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the information customers need to see.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: _decoration('Product name', Icons.shopping_bag),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a product name.';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _decoration('Product price', Icons.attach_money),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final price = double.tryParse(value?.trim() ?? '');
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!.trim()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _decoration('Product description', Icons.notes),
                textCapitalization: TextCapitalization.sentences,
                minLines: 3,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a product description.';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shipDateController,
                decoration: _decoration(
                  'Product ship date',
                  Icons.calendar_month,
                ).copyWith(suffixIcon: const Icon(Icons.arrow_drop_down)),
                readOnly: true,
                onTap: _isSubmitting ? null : _selectShipDate,
                validator: (_) {
                  if (_shipDate == null) {
                    return 'Please select a ship date.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    _isSubmitting ? 'Uploading...' : 'Upload Product',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
