
class BaseCubitState {
  final bool isLoading;
  final String errorMsg;
  BaseCubitState(this.isLoading, this.errorMsg);
}

class CubitState<T> extends BaseCubitState {
  final T data;
  CubitState(bool isLoading, this.data, {String errorMsg=''}) : super(isLoading, errorMsg);
}
