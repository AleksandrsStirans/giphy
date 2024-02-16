
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gif_event.dart';
import 'gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  int _currentPage = 1;
  bool _hasMore = true;
  List<String> _gifUrls = [];
  final int _limit = 10; // Number of GIFs per page
  String _currentQuery = '';

  GifBloc() : super(GifInitial());

  @override
  Stream<GifState> mapEventToState(GifEvent event) async* {
    if (event is ResetSearch) {
      _currentPage = 1;
      _hasMore = true;
      _gifUrls = [];
      _currentQuery = '';
      yield GifInitial();
    } else if (event is SearchGifEvent) {
      _currentPage = 1; // Reset to first page for new search
      _gifUrls = []; // Clearing previous results
      _currentQuery = event.query;
      yield GifLoading();
      yield* _fetchGifs(event.query);
    } else if (event is LoadMoreGifs && _hasMore) {
      yield* _fetchGifs(_currentQuery);
    }
  }

  Stream<GifState> _fetchGifs(String query) async* {
  if (!_hasMore) {
    // print('No more data to load.');
    yield GifLoaded(gifUrls: _gifUrls, timeStamp: DateTime.now().millisecondsSinceEpoch);
    return;
  }
  await Future.delayed(Duration(milliseconds: 500)); // delay
  // print('Fetching GIFs for query: $query, page: $_currentPage');

  try {
    final uri = Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=QBPSRkO1vlrw4wU7xYakfLBfM9hGslcX&q=$query&limit=$_limit&offset=${(_currentPage - 1) * _limit}');
    // print('Making HTTP request to $uri');
    final response = await http.get(uri);

    // print('HTTP response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null) {
        var newGifs = data['data'].map<String>((gif) => gif['images']['fixed_height']['url'] as String).toList();
        _gifUrls.addAll(newGifs);
        _hasMore = data['pagination']['total_count'] > _currentPage * _limit;
        _currentPage++;
        print('Loaded ${newGifs.length} GIFs, has more: $_hasMore');
        yield GifLoaded(gifUrls: _gifUrls, timeStamp: DateTime.now().millisecondsSinceEpoch);
      } else {
        _hasMore = false;
        print('No new data was loaded. Current GIF count: ${_gifUrls.length}');
        yield GifLoaded(gifUrls: _gifUrls, timeStamp: DateTime.now().millisecondsSinceEpoch);
      }
    } else {
      print('Error loading data: Status ${response.statusCode}');
      yield GifError(errorMessage: "Error loading data: Status ${response.statusCode}");
    }
  } catch (e) {
    print('Exception during API call: $e');
    yield GifError(errorMessage: "Exception during API call: $e");
  }
}
}
