

// Gets a random fact to be displayed when loading
Parse.Cloud.define("getRandomFact", function(request, response)
                   {
                   Parse.Cloud.run('getFactsCount', {}, {
                                   success: function(result) {
                                   
                                   
                                   var rnd = Math.floor(Math.random()*result) + 1;
                                
                                   var query = new Parse.Query("Facts");
                                   query.equalTo("index", rnd);
                                   query.find({
                                              success: function(result) {
                                              
                                              response.success(result);
                                              },
                                              error: function() {
                                              response.error("movie lookup failed");
                                              }
                                              });
                                   
                                   
                                   },
                                   error: function(error) {
                                   }
                                   });
                   
                   
                   });

Parse.Cloud.define("getFactsCount", function(request, response)
                   {
                   var countQuery = new Parse.Query("Facts");
                   var countResult = countQuery.count(
                                                      {
                                                      success: function(count)
                                                      {

                                                      response.success(count);
                                                      
                                                      },
                                                      error: function()
                                                      {
                                                      response.error("We should never get here from Cloud Code");
                                                      }
                                                      });
                   });




// Increments number of messages in the chatroom a message is sent to
Parse.Cloud.afterSave("Chat", function(request, response) {
                      query = new Parse.Query("ChatRooms");
                      query.get(request.object.get("roomId"), {
                                success: function(post) {
                                post.increment("numberOfMessages", 1);
                                post.set("lastUser", request.user);
                                post.set("lastMessageDate", new Date());
                                post.save();
                                response.success();
                                },
                                error: function(error) {
                                console.error("Got an error " + error.code + " : " + error.message);
                                response.error();
                                }
                                });
                      });



// Increment user profile view count
Parse.Cloud.define("incrementUserProfileViews", function(request, response) {
                   Parse.Cloud.useMasterKey();
                   var user = new Parse.User();
                   var query = new Parse.Query(Parse.User);
                   query.equalTo("objectId", request.params.userObjectId);
                   query.first({
                               success: function(object) {
                               object.increment("profileViews", 1);
                               object.save();
                               response.success();
                               },
                               error: function(error) {
                               console.error("Got an error " + error.code + " : " + error.message);
                               response.error();
                               }
                               });
                   });

// Increment number of reviews given by user
Parse.Cloud.define("incrementReviewsByUser", function(request, response) {
                   Parse.Cloud.useMasterKey();
                   var user = new Parse.User();
                   var query = new Parse.Query(Parse.User);
                   query.equalTo("objectId", request.params.userObjectId);
                   query.first({
                               success: function(object) {
                               object.increment("showReviews", 1);
                               object.save();
                               response.success();
                               },
                               error: function(error) {
                               console.error("Got an error " + error.code + " : " + error.message);
                               response.error();
                               }
                               });
                   });

// Delete an entire private chat conversation for a user
Parse.Cloud.define("deleteChat", function(request, response) {
                   var userID = request.params.userID;
                   
                   var query = new Parse.Query(Parse.Chat);
                   query.equalTo("roomId", params.roomId);
                   query.equalTo("belongsToUser", request.params.user);
                   query.find().then(function (messages) {
                                     
                                     //What do I do HERE to delete the posts?
                                     messages.forEach(function(message) {
                                                   message.destroy({
                                                                success: function() {
                                                                console.error("Success 1");
                                                                },
                                                                error: function() {
                                                               console.error("Got an error 2");
                                                                }
                                                                });
                                                   });
                                     }, function (error) {
                                     response.error(error);
                                     console.error("Got an error 1");
                                     });
                   });

Parse.Cloud.define("deletePosts", function(request, response) {
                   
                   //var userDeleting = new Parse.User({id:request.params.userId});
                   var query = new Parse.Query("Chat");
                   
                   query.equalTo("roomId", params.roomId);
                   //query.equalTo("belongsToUser", userDeleting);
                   query.find().then(function (users) {
                                     
                                     //What do I do HERE to delete the posts?
                                     users.forEach(function(user) {
                                                   user.destroy({
                                                                success: function() {
                                                                // SUCCESS CODE HERE, IF YOU WANT
                                                                },
                                                                error: function() {
                                                                // ERROR CODE HERE, IF YOU WANT
                                                                }
                                                                });
                                                   });
                                     }, function (error) {
                                     //response.error(error);
                                     });
                   });