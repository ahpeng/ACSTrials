var http = require("http");
var os = require("os");

var server = http.createServer(function(request, response){
    response.writeHead(200, {"Content-Type" : "text/html"});
    response.end("<body>" +
            "Hello, this is Jomit's [UPDATED] container running on kubernetes" +
            "<br>Serverd By : \n" + os.hostname() +  
            "</body");
    console.log("Reqeust handled: " + request.url);
});

server.listen(8000);

console.log("Server running at http://" + os.hostname() + ":8000/");