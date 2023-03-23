import 'package:flutter/material.dart';

import 'catalog_form.dart';
import 'product_form.dart';

class CatalogDialog extends StatefulWidget {
  const CatalogDialog({super.key});

  @override
  State<CatalogDialog> createState() => _CatalogDialogState();
}

class _CatalogDialogState extends State<CatalogDialog> {
  bool? _isProductForm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Wrap(children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isProductForm == null) ...[
                      InkWell(
                        onTap: () => setState(() {
                          _isProductForm = true;
                        }),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text("Product", textAlign: TextAlign.center),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() {
                          _isProductForm = false;
                        }),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child:
                              Text("Gruppierung", textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                    if (_isProductForm != null)
                      _isProductForm!
                          ? const ProductForm()
                          : const CatalogForm()
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
