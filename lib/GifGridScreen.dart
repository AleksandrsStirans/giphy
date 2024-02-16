
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gif_bloc.dart'; 
import 'gif_event.dart';
import 'gif_detail_screen.dart'; 

class GifGridScreen extends StatefulWidget {
  final List<String> gifUrls;
  final ScrollController? scrollController;

  GifGridScreen({Key? key, required this.gifUrls, this.scrollController}) : super(key: key);

  @override
  _GifGridScreenState createState() => _GifGridScreenState();
}

class _GifGridScreenState extends State<GifGridScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if(widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      BlocProvider.of<GifBloc>(context).add(LoadMoreGifs(widget.gifUrls.last));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: widget.gifUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GifDetailScreen(gifUrl: widget.gifUrls[index]),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              widget.gifUrls[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

