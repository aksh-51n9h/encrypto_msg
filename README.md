# encrypto_msg
- Encrypted web socket terminal messaging implemented using dart-lang.
- RSA encryption and AES encryption algorithms are used for encryption.

### Screenshots : 
- work in progress

### Web socket implementaion in dart-lang :
> WebSocket is a communications protocol for a persistent, bi-directional, full duplex TCP connection from a user’s web browser to a server.
#### Server side implementation :
1. Add shelf package in your project.
  * Add this to your package's **pubspec.yaml** file.
  ```
  dependencies:
    shelf: ^0.7.9
  ```
  
 2. Create web server in **main.dart** file.
 ```
 void main() async{
  var address = InternetAddress.loopbackIPv4;
  var port = 4042;
  
  var server = await HttpServer.bind(address, port);

  print('Sever started at ${server.address.address}:${server.port}');
 }
 ```
 
 3. Add request listener to it.
 ```
 server.listen(
  (HttpRequest request) async {
    print("Incoming request from ${request.connectionInfo.remoteAddress}");
 );
 ```
 
 4. Upgrade http request to web socket.
 ```
 var webSocket = await WebSocketTransformer.upgrade(request);
 ```
 
 5. Add web socket request listener.
 ```
 webSocket.listen(
  (data) {
    print('Request from ${request?.connectionInfo?.remoteAddress}  --> ${utf8.decode(data)}');      
    }
  },
 );
 ```
 
#### Client side implementation :
1. Create another file **client.dart**.
```
 void main() async{
  var webSocket = await WebSocket.connect('ws://127.0.0.1:4042');
 }
```

2. Add handler to it.
 ```
 webSocket.listen(
  (data) {
    print('Message received --> ${utf8.decode(data)}');      
    }
  },
 );
 ```
 
 3. Use **send** method to send message to server.
 ```
  webSocket.send('Hello World!');
 ```
 _Message will be send in the form of utf encodes list._

[For more documented info](https://api.dart.dev/stable/2.9.1/dart-io/WebSocket-class.html)
