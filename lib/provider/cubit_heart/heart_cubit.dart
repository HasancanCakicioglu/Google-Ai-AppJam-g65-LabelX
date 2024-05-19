import 'package:hydrated_bloc/hydrated_bloc.dart';

class HeartCubit extends HydratedCubit<List<DateTime>> {
  HeartCubit()
      : super([...List<DateTime>.generate(3, (index) => DateTime.now())]);

  // Kalp yenilenme süresi (15 dakika)
  final Duration regenerationTime = const Duration(minutes: 15);
  final heartCount = 3;

  @override
  List<DateTime>? fromJson(Map<String, dynamic> json) {
    return List<DateTime>.from(json['heart']?.map((x) => DateTime.parse(x)));
  }

  @override
  Map<String, dynamic>? toJson(List<DateTime> state) {
    return {
      'heart': state.map((x) => x.toIso8601String()).toList(),
    };
  }

  void dead() {
    if (getAliveHeartCount() == heartCount) {
      state[0] = DateTime.now().add(regenerationTime);
      emit(List<DateTime>.from(state));
      return;
    }

    DateTime newRegenerationTime = DateTime.now().add(regenerationTime);
    for (DateTime time in state) {
      if (time.isAfter(DateTime.now())) {
        newRegenerationTime =
            newRegenerationTime.add(time.difference(DateTime.now()));
      }
    }

    state[getIndexLatestHeartRegenerationTime()] = newRegenerationTime;
    emit(List<DateTime>.from(state));
  }

  int getIndexLatestHeartRegenerationTime() {
    int minIndex = -1;
    DateTime? minValue;

    for (int i = 0; i < state.length; i++) {
      if (minValue == null || state[i].isBefore(minValue)) {
        minValue = state[i];
        minIndex = i;
      }
    }

    return minIndex;
  }

  int getAliveHeartCount() {
    int aliveHeartCount = 0;
    for (var heart in state) {
      if (heart.isBefore(DateTime.now())) {
        aliveHeartCount++;
      }
    }

    return aliveHeartCount;
  }


  void refreshHearts() {
    emit([...List<DateTime>.generate(3, (index) => DateTime.now())]);
  }
}
