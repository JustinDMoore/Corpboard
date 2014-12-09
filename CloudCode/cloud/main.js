
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
//Parse.Cloud.afterSave("Chat", function(request, response) {
//  
//                       var a = new Parse.Query("ChatRooms");
//                      a.get(request.object.get("roomId").id, {
//                            
//                            })
//                      a.equalTo("objectId", request.object.get("roomId"));
//                       a.find({
//                              success: function(results)
//                              {
//                              
//                              
//                              response.success();
//                              }
//                           
//                              });
//                       
//});


//  Increase the answerCount of a question after save the answer
Parse.Cloud.afterSave("Chat", function(request) {
                      query = new Parse.Query("ChatRooms");
                      query.get(request.object.get("roomId").id, {
                                success: function(question) {
                                console.log("Get target question!: " + question.id);       // for debug
                                console.log("Before: " + question.get("answerCount"));     // for debug
                                question.increment("answerCount");
                                question.save();
                                console.log("After: " + question.get("answerCount"));      // for debug
                                },
                                
                                error: function(error) {
                                console.error("Fail to increase question's answerCount. ErrorCode ");
                                }
                                });
                      });
