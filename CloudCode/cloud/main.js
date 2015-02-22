

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
                                console.error("Got an error");
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

// Delete all private chat messages -- called by deleteChat
Parse.Cloud.define("deleteChatMessages", function(request, response) {
                   
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

// Delete a private chat room - then calls deleteChatMessages
Parse.Cloud.define("deleteChat", function(request, response) {
                   
                   var queryChatMaster = new Parse.Query("Messages");
                   queryChatMaster.equalTo("roomId", request.params.roomId);
                   queryChatMaster.equalTo("belongsToUser", request.user);
                   queryChatMaster.find().then(function (users) {
                                               
                                               //What do I do HERE to delete the posts?
                                               users.forEach(function(user) {
                                                             
                                                             user.destroy({
                                                                          success: function() {
                                                                          // SUCCESS CODE HERE, IF YOU WANT
                                                                          Parse.Cloud.run('deleteChatMessages', { roomId: request.params.roomId }, {
                                                                                          success: function(ratings) {
                                                                                          // ratings should be 4.5
                                                                                          },
                                                                                          error: function(error) {
                                                                                          }
                                                                                          });
                                                                          
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

// Admin functions
Parse.Cloud.afterSave("feedback", function(request, response) {
                      Parse.Cloud.useMasterKey();
                      var query = new Parse.Query("admin");
                      query.equalTo("objectId", "IjplBNRNjj");
                      query.first({
                                  success: function(object) {
                                  object.increment("feedback", 1);
                                  object.save();
                                  Parse.Push.send({
                                                  channels: [ "admin" ],
                                                  data: {
                                                  alert: "New Feedback Received"
                                                  }
                                                  }, { success: function() { 
                                                  // success!
                                                  }, error: function(err) { 
                                                  console.log(err);
                                                  }
                                                  });

                                  response.success();
                                  },
                                  error: function(error) {
                                  console.error("Got an error " + error.code + " : " + error.message);
                                  response.error();
                                  }
                                  });
                      });

Parse.Cloud.afterSave("photos", function(request, response) {
                      Parse.Cloud.useMasterKey();
                      var userSubmitted = request.object.get("isUserSubmitted");
                      if (userSubmitted) {
                      var query = new Parse.Query("admin");
                      query.equalTo("objectId", "IjplBNRNjj");
                      query.first({
                                  success: function(object) {
                                  object.increment("photos", 1);
                                  object.save();
                                  Parse.Push.send({
                                                  channels: [ "admin" ],
                                                  data: {
                                                  alert: "New cover photo for review"
                                                  }
                                                  }, { success: function() {
                                                  // success!
                                                  }, error: function(err) {
                                                  console.log(err);
                                                  }
                                                  });
                                  
                                  response.success();
                                  },
                                  error: function(error) {
                                  console.error("Got an error " + error.code + " : " + error.message);
                                  response.error();
                                  }
                                  });
                      }
                      
                      });

Parse.Cloud.afterSave("reportUsers", function(request, response) {
                      Parse.Cloud.useMasterKey();
                      var query = new Parse.Query("admin");
                      query.equalTo("objectId", "IjplBNRNjj");
                      query.first({
                                  success: function(object) {
                                  object.increment("usersReported", 1);
                                  object.save();
                                  Parse.Push.send({
                                                  channels: [ "admin" ],
                                                  data: {
                                                  alert: "A user has been reported"
                                                  }
                                                  }, { success: function() {
                                                  // success!
                                                  }, error: function(err) {
                                                  console.log(err);
                                                  }
                                                  });
                                  
                                  response.success();
                                  },
                                  error: function(error) {
                                  console.error("Got an error " + error.code + " : " + error.message);
                                  response.error();
                                  }
                                  });
                      });

Parse.Cloud.afterSave("problems", function(request, response) {
                      Parse.Cloud.useMasterKey();
                      var type = request.object.get("type");
                      
                      var query = new Parse.Query("admin");
                      query.equalTo("objectId", "IjplBNRNjj");
                      query.first({
                                  success: function(object) {
                                  object.increment("problems", 1);
                                  object.save();
                                  Parse.Push.send({
                                                  channels: [ "admin" ],
                                                  data: {
                                                  alert: type + " reported"
                                                  }
                                                  }, { success: function() {
                                                  // success!
                                                  }, error: function(err) {
                                                  console.log(err);
                                                  }
                                                  });
                                  
                                  response.success();
                                  },
                                  error: function(error) {
                                  console.error("Got an error " + error.code + " : " + error.message);
                                  response.error();
                                  }
                                  });
                      });