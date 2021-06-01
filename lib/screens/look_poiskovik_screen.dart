import 'package:flutter/material.dart';

class Movie {
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({
    this.imageName,
    this.title,
    this.time,
    this.description,
  });
}

class LookPoiskovikScreen extends StatefulWidget {
  LookPoiskovikScreen({Key key}) : super(key: key);
  static const routeName = '/look-poiskovik-screen';
  @override
  _LookPoiskovikScreenState createState() => _LookPoiskovikScreenState();
}

class _LookPoiskovikScreenState extends State<LookPoiskovikScreen> {
  final _movies = [
    Movie(
      title: 'Смертельная битва',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Прибытие',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Назад в будущее 1',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Назад в будущее 2',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Назад в будущее 3',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Первому игроку приготовится',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Пиксели',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Человек паук',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Лига справедливости',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Человек из стали',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Мстители',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Форд против феррари',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Джентельмены',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Тихие зори',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'В бой идут одни старики',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
    Movie(
      title: 'Дюна',
      time: 'April  7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage',
    ),
  ];

  var _filteredMovies = <Movie>[];

  final _searchController = TextEditingController();

  void _searchMovies() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelPadding: EdgeInsets.only(bottom: 10, top: 15),
            indicatorColor: Colors.green,
            tabs: [
              Text(
                'Рестораны',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              Text(
                'Блюда',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              Text(
                'Категории',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ],
            onTap: (value) {
              setState(() {});
            },
          ),
          actions: [
            Container(
              width: (MediaQuery.of(context).size.width - 60),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  filled: true,
                  fillColor: Colors.white.withAlpha(235),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        // body: ListView.builder(
        //   padding: EdgeInsets.only(top: 70),
        //   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //   itemCount: _filteredMovies.length,
        //   itemExtent: 163,
        //   itemBuilder: (BuildContext context, int index) {
        //     final movie = _filteredMovies[index];
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //       child: Stack(
        //         children: [
        //           Container(
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               border: Border.all(color: Colors.black.withOpacity(0.2)),
        //               borderRadius: BorderRadius.all(Radius.circular(10)),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.1),
        //                   blurRadius: 8,
        //                   offset: Offset(0, 2),
        //                 ),
        //               ],
        //             ),
        //             clipBehavior: Clip.hardEdge,
        //             child: Row(
        //               children: [
        //                 SizedBox(width: 15),
        //                 Expanded(
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       SizedBox(height: 20),
        //                       Text(
        //                         movie.title,
        //                         style: TextStyle(fontWeight: FontWeight.bold),
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                       SizedBox(height: 5),
        //                       Text(
        //                         movie.time,
        //                         style: TextStyle(color: Colors.grey),
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                       SizedBox(height: 20),
        //                       Text(
        //                         movie.description,
        //                         maxLines: 2,
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(width: 10),
        //               ],
        //             ),
        //           ),
        //           Material(
        //             color: Colors.transparent,
        //             child: InkWell(
        //               borderRadius: BorderRadius.circular(10),
        //               onTap: () {
        //                 print('11');
        //               },
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        body: TabBarView(children: [
          Text('a=b'),
          Text('c'),
        ]),
      ),
    );
  }
}
