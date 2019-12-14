//class Post {
//  final int userId;
//  final int id;
//  final String title;
//  final String body;
//
//  Post({this.userId, this.id, this.title, this.body});
//
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return Post(
//      userId: json['userId'],
//      id: json['id'],
//      title: json['title'],
//      body: json['body'],
//    );
//  }
//}

class Post {
  final String name;
  final int x;
  final int y;
  final int step;

  Post({this.name, this.x, this.y, this.step});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      x: json['x'],
      y: json['y'],
      step: json['step'],
    );
  }
}
