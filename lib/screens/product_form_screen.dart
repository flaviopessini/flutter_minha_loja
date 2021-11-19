import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/product.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  bool _isLoading = false;

  bool isValidImageUrl(String url) {
    url.toLowerCase();
    bool isValid = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWith =
        url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg');
    return isValid && endsWith;
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      debugPrint(e.toString());
      await showDialog<void>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Houve um erro ao salvar o novo registro'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Provider.of<ProductList>(context, listen: false).loadProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus
      ..removeListener(updateImage)
      ..dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produto'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (name) =>
                          _formData['name'] = name.toString().trim(),
                      validator: (v) {
                        final name = v.toString().trim();
                        if (name.isEmpty) {
                          return 'Nome obrigatório';
                        }
                        if (name.length < 2) {
                          return 'Nome deve conter pelo menos 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      focusNode: _priceFocus,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (v) {
                        final price =
                            double.tryParse(v.toString().trim()) ?? -1;
                        if (price < 0) {
                          return 'Informe um preço válido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      focusNode: _descriptionFocus,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) => _formData['description'] =
                          description.toString().trim(),
                    ),
                    TextFormField(
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Url da imagem',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl.toString().trim(),
                      validator: (v) {
                        final url = v.toString().trim();
                        if (!isValidImageUrl(url)) {
                          return 'Informe uma Url válida';
                        }
                        return null;
                      },
                    ),
                    Center(
                      child: Container(
                        height: 256.0,
                        width: 256.0,
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _imageUrlController.text.isEmpty
                            ? const Text('Informe a Url')
                            : FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: _imageUrlController.text,
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
