import 'package:flutter/material.dart';

class DraggableBottomSheetDemo extends StatelessWidget {
  const DraggableBottomSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.25,
                minChildSize: 0.2,
                maxChildSize: 1,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item ${index + 1}'),
                        );
                      },
                      itemCount: 20,
                    ),
                  );
                },
              ),
            );
          },
          child: const Text("Show BottomSheet"),
        ),
      ),
    );
  }
}
