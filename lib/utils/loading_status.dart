enum LoadingType {
  init, loading, done, error
}

class LoadingStatus {
  LoadingStatus({this.loadingType}) {
    loadingType = LoadingType.init;
  }

  LoadingType? loadingType = LoadingType.init;

  start() {
    loadingType = LoadingType.loading;
  }

  done() {
    loadingType = LoadingType.done;
  }

  bool isLoading() {
    return loadingType == LoadingType.loading;
  }

  bool isDone() {
    return loadingType == LoadingType.done;
  }

  LoadingType? check() {
    return loadingType;
  }
}