import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
class EditProduct extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  Product editedProduct = Product(
      id: null, price: 0.0, title: null, imageUrl: null, description: null);
  var _isValue=true;
  var _isLoading=false;
  Map<String,String> _initialization={
    'Title': '',
    'Price': '',
    'Description': '',
    //'ImageUrl': '',
  };

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
@override
  void didChangeDependencies() {
    if (_isValue)
    {
      final productId= ModalRoute.of(context).settings.arguments as String;
      if(productId!=null) {
        final editProduct = Provider.of<Products>(context).findById(productId);
        _initialization = {
          'Title': editProduct.title,
          'Price': editProduct.price.toString(),
          'Description': editProduct.description,
          //'ImageUrl': editProduct.imageUrl,
        };
        editedProduct=Product(
            id: editProduct.id, price: 0.0, title: null, imageUrl: null, description: null,isFavorite: editProduct.isFavorite);
        _imageUrlController.text=editProduct.imageUrl;
      }
    }
    _isValue=false;


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if((_imageUrlController.text.isEmpty) || (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https'))
        || (!_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg') && !_imageUrlController.text.endsWith('.png')))
        return;
      setState(() {});
    }
  }

  Future<void> _onSave() async{
    final _isValid= _form.currentState.validate();
    if(!_isValid)
        return;
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if(editedProduct.id!=null)
    {
      await Provider.of<Products>(context, listen: false).editProduct(editedProduct.id,editedProduct);
//      setState(() {
//        _isLoading=false;
//      });
//      Navigator.of(context).pop();
    }
    else {
      try{
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      }catch (error){
          showDialog(context: context,builder: (ctx)=>AlertDialog(
            title: Text('An error accored'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(child: Text('Okay'),onPressed: (){
                Navigator.of(ctx).pop();
              },),
            ],
          ));
        }
    }
    setState(() {
      _isLoading=false;
    });
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    final dSize=MediaQuery.of(context).size;
    final _hintStyle = TextStyle(
      fontSize: dSize.height * 0.020,
      color: Color(0xFF191C3D),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products',style: TextStyle(fontWeight: FontWeight.w500),),
        elevation: 1,
        backgroundColor: Color(0xFFf6f5f5),
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios,color:  Color(0xFFFE7262),size: 18,),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save,color: Theme.of(context).primaryColor,),
            onPressed: () => _onSave(),
          ),
        ],
      ),
      body: _isLoading? Center(
        child: CircularProgressIndicator(),
      ):Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Wrap(
              runSpacing: 20,
              children: <Widget>[
                TextFormField(
                  style: _hintStyle,
                  initialValue: _initialization['Title'],
                  decoration: InputDecoration(labelText: 'Title', contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      price: editedProduct.price,
                      title: value,
                      description: editedProduct.description,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite,
                    );
                  },
                  validator: (val){
                    if (val.isEmpty)
                      return "Please provide Title!";
                    return null;
                  },
                ),
                TextFormField(
                    initialValue: _initialization['Price'],
                    decoration: InputDecoration(labelText: 'Price',contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      price: double.parse(value),
                      title: editedProduct.title,
                      description: editedProduct.description,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite,
                    );
                  },
                  validator: (val){
                    if (val.isEmpty)
                      return "Amount is Required!";
                    if(double.tryParse(val)==null)
                      return "Please Enter Correct Number!";
                    if(double.parse(val)<0)
                      return "Please Enter Positive Number!";
                    return null;

                  },
                    ),
                TextFormField(
                  initialValue: _initialization['Description'],
                  decoration: InputDecoration(labelText: 'Description',contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
                  //textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    editedProduct = Product(
                      id: editedProduct.id,
                      price: editedProduct.price,
                      title: editedProduct.title,
                      description: value,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite,
                    );
                  },
                  validator: (val){
                    if (val.isEmpty)
                      return "Please Provide Description!";
                    if(val.length<10)
                      return "Please Provide Description of length greater than 10";
                    return null;

                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.3))),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter Url')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                       // initialValue: _initialization['ImageUrl'],
                        decoration: InputDecoration(labelText: 'Image Url',contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0)),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _onSave(),
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            price: editedProduct.price,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            imageUrl: value,
                            isFavorite: editedProduct.isFavorite,
                          );
                        },
                        validator: (val){
                          if (val.isEmpty)
                            return "Iamge Url is Required!";
                          if(!val.startsWith('http') && !val.startsWith('https'))
                            return "Please Enter Corrent URL!";
                          if(!val.endsWith('.jpg') && !val.endsWith('.jpeg') && !val.endsWith('.png'))
                            return "Image extension is not accptatble!";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
