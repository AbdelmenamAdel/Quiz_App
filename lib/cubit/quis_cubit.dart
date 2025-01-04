import 'package:flutter_bloc/flutter_bloc.dart';

part 'quis_state.dart';

class QuisCubit extends Cubit<QuisState> {
  QuisCubit() : super(QuisInitial());
}
