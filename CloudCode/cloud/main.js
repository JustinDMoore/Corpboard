

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
            
                   var queryChatMaster = new Parse.Query("Messages");
                   queryChatMaster.equalTo("roomId", request.params.roomId);
                   queryChatMaster.equalTo("belongsToUser", request.user);
                   queryChatMaster.find
                   
                   var queryChat = new Parse.Query("Chat");
                   queryChat.equalTo("roomId", request.params.roomId);
                   queryChat.equalTo("belongsToUser", request.user);
                   queryChat.find().then(function (users) {
                                         
                                         //What do I do HERE to delete the posts?
                                         users.forEach(function(user) {
                                                       
                                                       user.destroy({
                                                                    success: function() {
                                                                    // SUCCESS CODE HERE, IF YOU WANT
                                                                    
                                                                    
                                                                    },
                                                                    error: function(error) {
                                                                    // ERROR CODE HERE, IF YOU WANT
                                                                    //response.error();
                                                                    }
                                                                    });
                                                       });
                                         }, function (error) {
                                         response.error();
                                         });
                   });

Parse.Cloud.afterDelete("Messages", function(request) {
                        
                        var queryChat = new Parse.Query("Chat");
                        queryChat.equalTo("roomId", request.params.roomId);
                        queryChat.equalTo("belongsToUser", request.user);
                        
                        queryChat.find().then(function(messages) {
                                          return Parse.Object.destroyAll(messages);
                                          }).then(function(success) {
                                                  // The related comments were deleted
                                                  }, function(error) {
                                                  console.error("Error deleting related comments " + error.code + ": " + error.message);
                                                  });
                        });