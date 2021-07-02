import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  final Set<int> _selectedIndices = {};

  bool get hasSelection => _selectedIndices.isNotEmpty;

  void select(int index) {
    _selectedIndices.add(index);
    notifyListeners();
  }

  void unselect(int index) {
    _selectedIndices.remove(index);
    notifyListeners();
  }

  void toggle(int index) {
    if (_selectedIndices.contains(index))
      _selectedIndices.remove(index);
    else
      _selectedIndices.add(index);
    notifyListeners();
  }

  void unselectAll() {
    _selectedIndices.clear();
    notifyListeners();
  }

  bool isSelected(int index) => _selectedIndices.contains(index);
}
