class User {
  final String uid;

  User({this.uid}) {
    currUser = this;
  }
}

User currUser;
