import 'package:get_it/get_it.dart';
import 'package:labeling/onboard/presentation/cubit/onboard_cubit.dart';

final sl = GetIt.instance;

abstract final class LocatorGetIt {
  /// Responsible for registering all the dependencies
  static Future<void> setup() async {
    // Cubit
    sl.registerFactory<OnBoardCubit>(() => OnBoardCubit());
    print(
        'LocatorGetIt.setup() completed --------------------------------------------');
  }
}
