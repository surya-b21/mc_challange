import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_challange/cubit/product_cubit.dart';
import 'package:mc_challange/model/product.dart';
import 'package:shimmer/shimmer.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    context.read<ProductCubit>().getProducts();
    _scrollController.addListener(_scrollListener);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ProductCubit>().getMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Monster Code Challange"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: state is ProductSuccess
                    ? topItems(categories: state.categories)
                    : topItemsLoading(context),
              ),
              state is ProductSuccess
                  ? listProduct(products: state.products)
                  : loadingList(),
              state is ProductSuccess
                  ? (state.loading == true ? loadingList() : Container())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget listProduct({required List<Product> products}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: CachedNetworkImage(
                imageUrl: products[index].thumbnail,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.black.withOpacity(0.25),
                  highlightColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    width: 180,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black.withOpacity(0.25),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(products[index].title),
            )
          ],
        ),
      ),
    );
  }

  Widget loadingList() {
    List<int> items = List<int>.generate(10, (index) => index + 1);

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: const ScrollPhysics(),
      children: items
          .map(
            (_) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.black.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(
                        width: 180,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Shimmer.fromColors(
                      baseColor: Colors.black.withOpacity(0.25),
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(
                        width: 180,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget topItems({required List<String> categories}) {
    String dropdownValue = categories.first;
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Pencarian",
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) => DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: dropdownValue,
                  isExpanded: true,
                  items: categories
                      .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topItemsLoading(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.black.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Shimmer.fromColors(
            baseColor: Colors.black.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loadingItem() {
    return Card(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            width: 380,
            height: 100,
            decoration: const BoxDecoration(color: Colors.grey),
          ),
          const ListTile(
            title: Text("Loading"),
          )
        ],
      ),
    );
  }
}
