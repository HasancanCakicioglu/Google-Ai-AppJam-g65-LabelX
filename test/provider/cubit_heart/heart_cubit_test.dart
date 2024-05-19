import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labeling/provider/cubit_heart/heart_cubit.dart';

void main() {
  group('HeartCubit', () {
    late HeartCubit heartCubit;

    setUp(() {
      heartCubit = HeartCubit();
    });

    tearDown(() {
      heartCubit.close();
    });

    test('initial state contains three DateTime objects', () {
      expect(heartCubit.state.length, 3);
      expect(heartCubit.state.every((date) => date is DateTime), isTrue);
    });

    blocTest<HeartCubit, List<DateTime>>(
      'emits correct state when dead() is called and all hearts are alive',
      build: () => heartCubit,
      act: (cubit) {
        cubit.dead();
        cubit.dead();
        print("can = ${cubit.getAliveHeartCount()}");
        cubit.dead();
        print("can = ${cubit.getAliveHeartCount()}");
      },
      expect: () {
        final expectedState = List<DateTime>.from(heartCubit.state);
        expectedState[0] = DateTime.now().add(heartCubit.regenerationTime);
        return [expectedState];
      },
    );

    test('getIndexLatestHeartRegenerationTime returns correct index', () {
      final latestIndex = heartCubit.getIndexLatestHeartRegenerationTime();
      expect(latestIndex, 0);
      for (int i = 1; i < heartCubit.state.length; i++) {
        expect(
          heartCubit.state[latestIndex].isBefore(heartCubit.state[i]),
          isTrue,
        );
      }
    });

    test('getAliveHeartCount returns correct count', () {
      final aliveHeartCount = heartCubit.getAliveHeartCount();
      expect(aliveHeartCount, heartCubit.heartCount);
    });

    blocTest<HeartCubit, List<DateTime>>(
      'emits correct state when dead() is called and not all hearts are alive',
      build: () {
        // Make one of the hearts in the future
        heartCubit.state[0] = DateTime.now().add(const Duration(hours: 1));
        return heartCubit;
      },
      act: (cubit) {
        cubit.dead();
      },
      expect: () {
        final expectedState = List<DateTime>.from(heartCubit.state);
        final index = heartCubit.getIndexLatestHeartRegenerationTime();
        expectedState[index] = DateTime.now().add(heartCubit.regenerationTime);
        return [expectedState];
      },
    );
  });
}
