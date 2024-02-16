import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:giphy_project/gif_bloc.dart';
import 'package:giphy_project/gif_state.dart';
import 'package:giphy_project/gif_event.dart';



class MockGifBloc extends MockBloc<GifEvent, GifState> implements GifBloc {}

  void main() {
    group('GifBloc Test', () {
      blocTest<GifBloc, GifState>(
    'emits [GifLoading, GifLoaded] when SearchGifEvent is added.',
    build: () => GifBloc(),
    act: (bloc) => bloc.add(SearchGifEvent('hello')),
    expect: () => [isA<GifLoading>(), isA<GifLoaded>()],
  );
  });
}


