import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  final Set<int> _selectedIndices = {};

  Set<int> get selectedIndices => _selectedIndices;

  bool _enabled = false;
  
  bool get isEnabled => _enabled;

  void beginSelection(int initialIndex) {
    if (_enabled)
      return;

    _enabled = true;
    select(initialIndex);
  }

  void endSelection() {
    if (!_enabled)
      return;

    _enabled = false;
    unselectAll();
  }

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
