import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomCubit extends Cubit<int> {
  HomeBottomCubit() : super(0);

  void selectTab(int index) {
    if (index < 0 || index > 4 || index == state) return;
    emit(index);
  }
}
