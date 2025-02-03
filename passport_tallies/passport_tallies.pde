ArrayList<User> users;
ArrayList<String> validUserIds;
StringDict badgeInfo;
StringDict userInfo;
IntDict    badgeIndex;
IntDict    userIndex;

String[] badgesjson;
String[] usersjson;
String[] userbadgesjson;

ArrayList<String> sortedNames;

int numbadges;

void setup() {
  //this is an arraylist of our users
  users = new ArrayList<User>(1000);
  validUserIds = new ArrayList<String>(1000);

  //this relates badge id to badge name
  badgeInfo  = new StringDict();
  badgeIndex = new IntDict();
  userIndex  = new IntDict();


  //load json files
  badgesjson     = loadStrings("badges.json");
  usersjson      = loadStrings("users.json");
  userbadgesjson = loadStrings("userbadges.json");

  loadBadges();
  println(" .... done loading badges .... ");
  loadUsers();
  println(" .... done loading users .... ");
  countBadges();
  println(" .... done counting badges .... ");

  String output = "First Name, Last Name, Username, Email,";

  for (String badge : sortedNames) {
    output += badge + ",";
  }
  output += "\n";



  for (User u : users) {
    output += u.firstname + "," + u.lastname + "," + u.username + "," + u.email + ",";
    for (int k : u.badges) {
      output += k+",";
    }
    output += "\n";
  }
  String[] outputarray = output.split("\n");
  saveStrings("output.csv", outputarray);
  println("DONE!");
}

void loadBadges() {
  //find a badge
  ArrayList<String> tempNames = new ArrayList<String>(30);
  //will load names into this list. at end, we will sort it and that will determine
  //the order that the badges go in the user object's badge array. To remember which
  //index belongs to which badge, will will store that in a IntDict.
  int i = 0;
  String id = "";
  String name = "";
  while (!"theEnd".equals(badgesjson[i])) {
    while (!"}".equals(badgesjson[i])) {
      if (badgesjson[i].contains("_id")) {
        i++;
        int start = badgesjson[i].indexOf(" ");
        int end   = badgesjson[i].lastIndexOf("\"");
        id = badgesjson[i].substring(start+2, end);
        id = id.trim();
        println(id);
      }
      if (badgesjson[i].contains("name\"")) {
        int start = badgesjson[i].indexOf(" ");
        int end   = badgesjson[i].lastIndexOf("\"");
        name = badgesjson[i].substring(start+2, end);
        name = name.trim();
        name = name.replace(",", "");
        println(name);
        tempNames.add(name);
      }
      i++;
    }
    badgeInfo.set(id, name);
    println("");
    i++;
  }
  numbadges = badgeInfo.size();
  sortedNames = sortBadges(tempNames);

  //store the indices of the array in the IntDict based on the alphabetical order of the name of the badge so we
  //can look up the index based on just the name later.
  int j = 0;
  for (String thename : sortedNames) {
    badgeIndex.set(thename, j);
    j++;
  }
}

//returns a sorted list of badge names, ignoring case
ArrayList<String> sortBadges(ArrayList<String> oldlist) {
  ArrayList<String> newlist = new ArrayList<String>(oldlist.size());
  while (oldlist.size()>0) {
    String smallestSoFar = oldlist.get(0);
    int indexSmallest = 0;
    for (int i = 0; i < oldlist.size(); i++) {
      int compare = smallestSoFar.compareToIgnoreCase(oldlist.get(i));
      if (compare > 0) {
        smallestSoFar =  oldlist.get(i);
        indexSmallest = i;
      }
    }
    println(oldlist.get(indexSmallest));
    newlist.add( oldlist.remove(indexSmallest));
  }
  return newlist;
}


void loadUsers() {
  String lastname  = "";
  String firstname = "";
  String id        = "";
  String username  = "";
  String email     = "";
  int i = 0;

  while (!"theEnd".equals(usersjson[i])) {
    while (!"}".equals(usersjson[i])) {
      if (usersjson[i].contains("_id")) {
        i++;
        int start = usersjson[i].indexOf(" ");
        int end   = usersjson[i].lastIndexOf("\"");
        id = usersjson[i].substring(start+2, end);
        id = id.trim();
      }
      if (usersjson[i].contains("lastName")) {
        int start = usersjson[i].indexOf(" ");
        int end   = usersjson[i].lastIndexOf("\"");
        lastname  = usersjson[i].substring(start+2, end);
        lastname  = lastname.trim();
      }
      if (usersjson[i].contains("firstName")) {
        int start = usersjson[i].indexOf(" ");
        int end   = usersjson[i].lastIndexOf("\"");
        firstname = usersjson[i].substring(start+2, end);
        firstname = firstname.trim();
      }
      if (usersjson[i].contains("username")) {
        int start = usersjson[i].indexOf(" ");
        int end   = usersjson[i].lastIndexOf("\"");
        username = usersjson[i].substring(start+2, end);
        username = username.trim();
      }
      if (usersjson[i].contains("email")) {
        int start = usersjson[i].indexOf(" ");
        int end   = usersjson[i].lastIndexOf("\"");
        email = usersjson[i].substring(start+2, end);
        email = email.trim();
      }

      i++;
    }
    users.add(new User(lastname, firstname, id, username, email));
    i++;
  }

  int j = 0;
  for (User u : users) {
    userIndex.set(u.id, j);
    j++;
  }
}

void countBadges() {
  int i = 0;
  while (!"theEnd".equals(userbadgesjson[i])) {
    String badgeid = "";
    String userid  = "";
    while (!"}".equals(userbadgesjson[i])) {
      if (userbadgesjson[i].contains("badge")) {
        i++;
        int start = userbadgesjson[i].indexOf(" ");
        int end   = userbadgesjson[i].lastIndexOf("\"");
        badgeid = userbadgesjson[i].substring(start+2, end);
        badgeid = badgeid.trim();
      }
      if (userbadgesjson[i].contains("user")) {
        i++;
        int start = userbadgesjson[i].indexOf(" ");
        int end   = userbadgesjson[i].lastIndexOf("\"");
        userid = userbadgesjson[i].substring(start+2, end);
        userid = userid.trim();
      }
      i++;
    }
    if (validUserIds.contains(userid)) {
      int idx = userIndex.get(userid);
      User x = users.get(idx);
      x.addBadge(badgeid);
    }
    i++;
  }
}
