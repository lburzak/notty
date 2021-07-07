import 'package:flutter/cupertino.dart';

class AnimatedListStreamAdapter <T> {
  final GlobalKey<AnimatedListState> stateKey;
  final Widget Function(
      BuildContext context,
      T model,
      Animation<double> animation
   ) itemBuilder;
  Set<T> _snapshot;
  List<T> items;

  AnimatedListStreamAdapter(
      {
        Key? key,
        required this.itemBuilder,
        required this.stateKey,
        required Stream<Set<T>> stream,
        Set<T> initialData = const {}
      }) :
        _snapshot = initialData,
        items = initialData.toList()
      {
        stream.listen(_onData);
      }

  void _onData(Set<T> data) {
    final addedItems = data.difference(_snapshot);
    final removedItems = _snapshot.difference(data);

    final List<T> source = List.from(data.toList());
    items = List.from(_snapshot.toList());

    removedItems
        .map(items.indexOf)
        .forEach((index) {
          final item = items.removeAt(index);
          stateKey.currentState!.removeItem(index, createPlaceholderBuilder(item));
        }
    );

    addedItems
        .map(source.indexOf)
        .forEach((index) {
          items.insert(index, source[index]);
          stateKey.currentState!.insertItem(index);
        });

    _snapshot = data;
  }

  Widget buildItem(BuildContext ctx, int index, Animation<double> animation) =>
    itemBuilder(ctx, items[index], animation);
  
  Widget Function(
      BuildContext context,
      Animation<double> animation
  ) createPlaceholderBuilder(T model) => (context, animation) =>
      FadeTransition(
        opacity: CurvedAnimation(
            parent: animation, curve: Interval(0.5, 1.0)
        ),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
              parent: animation, curve: Interval(0.0, 1.0)
          ),
          axisAlignment: 0.0,
          child: itemBuilder(context, model, animation),
        ),
      );
}