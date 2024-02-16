
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gif_bloc.dart';
import 'gif_event.dart';
import 'gif_state.dart'; 
import 'GifGridScreen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GIF Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => GifBloc(),
        child: GifSearchScreen(),
      ),
    );
  }
}

class GifSearchScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  GifSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GIF Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter search keyword',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                BlocProvider.of<GifBloc>(context).add(ResetSearch());
                BlocProvider.of<GifBloc>(context).add(SearchGifEvent(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<GifBloc, GifState>(
              builder: (context, state) {
                if (state is GifInitial) {
                  return Center(
                    child: Text('Enter a search query'),
                  );
                } else if (state is GifLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GifLoaded) {
                  if (state.gifUrls.isEmpty) {
                    return Center(
                      child: Text('No GIFs found'),
                    );
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        // loading next page
                        BlocProvider.of<GifBloc>(context).add(LoadMoreGifs(_searchController.text));
                      }
                      return true;
                    },
                    child: GifGridScreen(gifUrls: state.gifUrls, scrollController: _scrollController),
                  );
                } else if (state is GifError) {
                  return Center(
                    child: Text('Failed to load GIFs'),
                  );
                } else {
                  return Center(
                    child: Text('Unknown state'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

