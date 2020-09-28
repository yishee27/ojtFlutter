class QueryMutation {
  static String deletePost(String postId) {
    return """ 
    mutation{ 
      deletePosts(
        No:$postId
      ){
        resultCount
      }
    }
    """;
  }

  static String editPosts(String postId, String title, String contents) {
    return """ 
    mutation{ 
      editPosts(
        No:$postId
        Title: "'$title'"
        Contents: "'$contents'"
        ModifiedDate: ""
      ){
        resultCount
      }
    }
    """;
  }

  static String createReply(
      String contents, String userId, String postId, int corpId) {
    return """ 
    mutation{ 
      createReply(
        Contents: "'$contents'"
        UserId: "'$userId'"
        ParentPost: $postId
        Company: $corpId
        CreatedDate: ""
      ){
          resultCount
        }
    }
    """;
  }

  static String getReply(String postId) {
    return """ 
    query{ 
      getReply(No: $postId)
      {
        UserId
        Contents
      }
    }
    """;
  }

  static String createPosts(
      String title, String contents, String userId, int corpId) {
    return """
    mutation{
      createPosts(
        Title: "'$title'"
        Contents: "'$contents'"
        UserId: "'$userId'"
        Company: "$corpId"
      ){
        resultCount
      }
    }
    """;
  }

  static String readPosts(String postId) {
    return """ 
    query{ 
      readPosts(No:$postId){
        No
        Title
        UserId
        Contents
      }
    }
    """;
  }

  static String getPosts(corpId) {
    return """ 
    query{ 
      getPosts(Company:$corpId){
        No
        Title
        UserId
        Counter
        CreatedDate
      }
    }
    """;
  }

  static String fetchUser = """ 
    query{ 
      getUsers{
        no
        userId
        userName
        createdDate
        modifiedDate
        password
        corpId{
          corpId
          corpName
          corpContactNumber
        }
      }
    }
  """;

  static String loginUser(String userId, String userPw) {
    return """
    query{
      login(
      UserId: "$userId"
      UserPW: "$userPw"
      ){
        token
        user{
          No
          UserId
          Company
        }
      }
    }
    """;
  }

  static String deleteUser(String userId) {
    return """
    mutation{
      deleteUser(
        userId: "$userId"
      ){
        resultCount
      }
    }
    """;
  }

  static String createUsers(String userId, String userPW, String userName,
      String userEmail, String userMobile, String corpId) {
    return """
    mutation{
      createUsers(
        UserId: "'$userId'"
        UserPW: "'$userPW'"
        Company: $corpId
        UserName: "'$userName'"
        UserEmail: "'$userEmail'"
        UserMobile: "'$userMobile'"
        CreatedDate: ""
      ){
        resultCount
      }
    }
    """;
  }

  static String updateUser(
      int no, String userId, String userName, String corpId, String password) {
    return """
    mutation{
      createUser(
        no: "$no"
        userId: "$userId"
        userName: "$userName"
        corpId: "$corpId"
        password: "$password"
      ){
        resultCount
      }
    }
    """;
  }
}
