import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedExperiencesNotifier extends StateNotifier<List<int>> {
  SelectedExperiencesNotifier() : super([]);

  void toggle(int id) {
    if (state.contains(id)) {
      state = state.where((element) => element != id).toList();
    } else {
      state = [...state, id];
    }
  }
}

final selectedExperiencesProvider = StateNotifierProvider<SelectedExperiencesNotifier, List<int>>((ref) => SelectedExperiencesNotifier());

final descriptionProvider = StateProvider<String>((ref) => '');