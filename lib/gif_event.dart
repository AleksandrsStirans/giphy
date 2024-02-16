abstract class GifEvent {}

class ResetSearch extends GifEvent {}

class SearchGifEvent extends GifEvent {
  final String query;

  SearchGifEvent(this.query);
}

class LoadMoreGifs extends GifEvent {
  final String query;

  LoadMoreGifs(this.query);
}
