class User {
 
  String lastname, firstname, id, email, username;
  int[] badges;
  
  User(String lastname, String firstname, String id, String username, String email) {
    this.lastname  = lastname;
    this.firstname = firstname;
    this.id        = id;
    this.username  = username;
    this.email     = email;
    badges = new int[numbadges+1];
    validUserIds.add(id);
  }
  
  //void export()
  
  void addBadge(String badgeid) {
    String badgename = badgeInfo.get(badgeid);
    int i = badgeIndex.get(badgename);
    badges[i]++;
  }
}
