

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
                   console.log("here i am");
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








