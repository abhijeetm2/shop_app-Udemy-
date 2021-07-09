import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusMode = FocusNode();
  final _descriptionFocusMode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: null.toString(),
    price: 0.0,
    title: '',
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findByid(productId);

        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id == 'null' || _editProduct.id == null) {
      //... add a new product

      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editProduct, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      //.. update the existing product
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }

    // Navigator.of(context).pop();

    /*print(_editProduct.title);
    print(_editProduct.price);
    print(_editProduct.description);
    print(_editProduct.imageUrl);*/
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
    _priceFocusMode.dispose();
    _descriptionFocusMode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: buildListView(context),
              ),
            ),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          initialValue: _initValues['title'],
          decoration: InputDecoration(labelText: 'Title'),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_priceFocusMode);
          },
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Please Enter Title';
            }
            return null;
          },
          onSaved: (value) {
            _editProduct = Product(
              title: value.toString(),
              price: _editProduct.price,
              description: _editProduct.description,
              id: _editProduct.id,
              isFavourite: _editProduct.isFavourite,
              imageUrl: _editProduct.imageUrl,
            );
          },
        ),
        TextFormField(
          initialValue: _initValues['price'],
          decoration: InputDecoration(labelText: 'Price'),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          focusNode: _priceFocusMode,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_descriptionFocusMode);
          },
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Please enter price';
            }
            if (double.tryParse(value.toString()) == null) {
              return 'Please enter valid input';
            }
            if (double.parse(value.toString()) <= 0) {
              return 'Please enter a number greater than zero';
            }
            return null;
          },
          onSaved: (value) {
            _editProduct = Product(
              title: _editProduct.title,
              price: double.parse(value.toString()),
              description: _editProduct.description,
              id: _editProduct.id,
              isFavourite: _editProduct.isFavourite,
              imageUrl: _editProduct.imageUrl,
            );
          },
        ),
        TextFormField(
          initialValue: _initValues['description'],
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.multiline,
          focusNode: _descriptionFocusMode,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Please Enter Description';
            }
            return null;
          },
          onSaved: (value) {
            _editProduct = Product(
              title: _editProduct.title,
              price: _editProduct.price,
              description: value.toString(),
              id: _editProduct.id,
              isFavourite: _editProduct.isFavourite,
              imageUrl: _editProduct.imageUrl,
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 8, right: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: _imageUrlController.text.isEmpty
                  ? Text('Enter a URL')
                  : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Image Url'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: _imageUrlController,
                focusNode: _imageUrlFocusNode,
                onEditingComplete: () {
                  setState(() {});
                },
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please Enter Image Url';
                  }
                  if (!value.toString().startsWith('http') &&
                      !value.toString().startsWith('https')) {
                    return 'Please Enter Image Url';
                  }
                  /*        if (!value.toString().endsWith('.png') &&
                          !value.toString().endsWith('.jpg') &&
                          !value.toString().endsWith('.jpeg')) {
                        return 'Please enter valid image url';
                      }*/
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: _editProduct.price,
                    description: _editProduct.description,
                    id: _editProduct.id,
                    isFavourite: _editProduct.isFavourite,
                    imageUrl: value.toString(),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
