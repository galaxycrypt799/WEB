import 'package:coffee_admin/src/components/my_text_field.dart';
import 'package:coffee_admin/src/modules/operations/blocs/create_coffee_bloc/create_coffee_bloc.dart';
import 'package:coffee_admin/src/modules/operations/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:coffee_admin/src/modules/operations/components/macro.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreateCoffeeScreen extends StatefulWidget {
  const CreateCoffeeScreen({super.key});

  @override
  State<CreateCoffeeScreen> createState() => _CreateCoffeeScreenState();
}

class _CreateCoffeeScreenState extends State<CreateCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _originController = TextEditingController();
  final _roastLevelController = TextEditingController();
  final _volumeController = TextEditingController();
  final _calorieController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  bool _isSubmitting = false;
  String _pictureUrl = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateCoffeeBloc, CreateCoffeeState>(
          listener: (context, state) {
            if (state is CreateCoffeeLoading) {
              setState(() => _isSubmitting = true);
            } else {
              setState(() => _isSubmitting = false);
            }

            if (state is CreateCoffeeSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tạo đồ uống thành công')),
              );
              context.go('/home');
            }
          },
        ),
        BlocListener<UploadPictureBloc, UploadPictureState>(
          listener: (context, state) {
            if (state is UploadPictureSuccess) {
              setState(() => _pictureUrl = state.url);
            }
          },
        ),
      ],
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePicker(context),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: _nameController,
                    hintText: 'Tên đồ uống',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateRequired(value, 'Tên đồ uống'),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _descriptionController,
                    hintText: 'Mô tả',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateRequired(value, 'Mô tả'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _priceController,
                          hintText: 'Giá',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          validator: _validateNumber,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          controller: _discountController,
                          hintText: 'Giảm giá (%)',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          validator: _validateNumber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _originController,
                    hintText: 'Nguồn gốc',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _roastLevelController,
                    hintText: 'Mức rang',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _volumeController,
                    hintText: 'Dung tích (ml)',
                    obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      MyMacroWidget(
                        title: 'Calories',
                        value: 0,
                        icon: FontAwesomeIcons.fire,
                        controller: _calorieController,
                      ),
                      const SizedBox(width: 8),
                      MyMacroWidget(
                        title: 'Protein',
                        value: 0,
                        icon: FontAwesomeIcons.dumbbell,
                        controller: _proteinController,
                      ),
                      const SizedBox(width: 8),
                      MyMacroWidget(
                        title: 'Fat',
                        value: 0,
                        icon: FontAwesomeIcons.oilWell,
                        controller: _fatController,
                      ),
                      const SizedBox(width: 8),
                      MyMacroWidget(
                        title: 'Carbs',
                        value: 0,
                        icon: FontAwesomeIcons.breadSlice,
                        controller: _carbsController,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : () => _submit(context),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Tạo đồ uống'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null && context.mounted) {
          context
              .read<UploadPictureBloc>()
              .add(UploadPicture(await image.readAsBytes(), basename(image.path)));
        }
      },
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          image: _pictureUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(_pictureUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _pictureUrl.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.photo, size: 46, color: Colors.grey),
                  SizedBox(height: 6),
                  Text('Thêm ảnh đồ uống'),
                ],
              )
            : null,
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final coffee = Coffee(
      sortOrder: DateTime.now().millisecondsSinceEpoch,
      coffeeId: '',
      picture: _pictureUrl,
      name: _nameController.text.trim(),
      tagline: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: 'signature',
      origin: _originController.text.trim(),
      roastLevel: _roastLevelController.text.trim(),
      intensity: 3,
      brewMinutes: 4,
      volumeMl: int.tryParse(_volumeController.text.trim()) ?? 0,
      rating: 4.5,
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      discount: int.tryParse(_discountController.text.trim()) ?? 0,
      tastingNotes: const [],
      macros: Macros(
        calories: int.tryParse(_calorieController.text.trim()) ?? 0,
        proteins: int.tryParse(_proteinController.text.trim()) ?? 0,
        fat: int.tryParse(_fatController.text.trim()) ?? 0,
        carbs: int.tryParse(_carbsController.text.trim()) ?? 0,
      ),
    );

    context.read<CreateCoffeeBloc>().add(CreateCoffeeRequested(coffee));
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số';
    }
    if (num.tryParse(value.trim()) == null) {
      return 'Giá trị không hợp lệ';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _originController.dispose();
    _roastLevelController.dispose();
    _volumeController.dispose();
    _calorieController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }
}
