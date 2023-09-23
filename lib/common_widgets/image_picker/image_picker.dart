import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() {
    return _ImagePicker();
  }
}

class _ImagePicker extends State<ImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.image),
            label: Text(
              'Add Image',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ))
      ],
    );
  }
}
