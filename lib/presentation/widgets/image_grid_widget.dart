import 'package:flutter/material.dart';

import '../pages/image_page.dart';

class ImageGridWidget extends StatelessWidget {
  const ImageGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = <String>[
      'https://photo.tuchong.com/4870004/f/298584322.jpg',
      'https://photo.tuchong.com/16389644/f/1303840119.jpg',
      'https://photo.tuchong.com/1924454/f/153280211.jpg',
      'https://photo.tuchong.com/2353448/f/147183522.jpg',
      'https://photo.tuchong.com/2732194/f/514055506.jpg',
      'https://photo.tuchong.com/12772247/f/950208723.jpg',
      'https://photo.tuchong.com/4870004/f/298584322.jpg',
      'https://photo.tuchong.com/16389644/f/1303840119.jpg',
      'https://photo.tuchong.com/1924454/f/153280211.jpg',
      'https://photo.tuchong.com/2353448/f/147183522.jpg',
      'https://photo.tuchong.com/2732194/f/514055506.jpg',
      'https://photo.tuchong.com/12772247/f/950208723.jpg',
      'https://photo.tuchong.com/4870004/f/298584322.jpg',
      'https://photo.tuchong.com/16389644/f/1303840119.jpg',
      'https://photo.tuchong.com/1924454/f/153280211.jpg',
      'https://photo.tuchong.com/2353448/f/147183522.jpg',
      'https://photo.tuchong.com/2732194/f/514055506.jpg',
      'https://photo.tuchong.com/12772247/f/950208723.jpg',
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemBuilder: (BuildContext s, int index) {
        return _imageBody(context: context, imageUrl: images[index]);
      },
      itemCount: images.length,
      // shrinkWrap: true,
    );
  }

  Widget _imageBody({required BuildContext context, required String imageUrl}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ImagePage.routeName, arguments: {'imageUrl': imageUrl, 'title': 'test'}),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
