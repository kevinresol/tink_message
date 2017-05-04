package;

import haxe.io.Bytes;
import tink.tcp.Connection;
import tink.tcp.Server;
import tink.url.Host;
import tink.streams.Stream;
import tink.streams.Accumulator;
import tink.protocol.websocket.Requester;
import tink.protocol.websocket.Responder;
import tink.protocol.websocket.Frame;
import tink.protocol.websocket.Parser;
import tink.Chunk;

using tink.io.Source;

@:asserts
class TestWebSocket {
	public function new() {
		// describe("WebSocket", {
		// 	describe("Parser", {
		// 		it("should parse consecutive frames", function(done) {
		// 			var frame = [129, 131, 61, 84, 35, 6, 112, 16, 109];
		// 			var source:Source = arrayToBytes(frame.concat(frame).concat(frame));
		// 			source.parseStream(new Parser()).forEach(function(bytes) {
		// 				bytes.toHex().should.be('81833d54230670106d');
		// 				var frame:Frame = bytes;
		// 				frame.fin.should.be(true);
		// 				frame.opcode.should.be(1);
		// 				frame.mask.should.be(true);
		// 				frame.maskingKey.toHex().should.be('3d542306');
		// 				frame.payload.toHex().should.be('70106d');
		// 				Frame.decode(frame.payload, frame.maskingKey).toString().should.be('MDN');
		// 				return true;
		// 			}).handle(function(_) done());
		// 		});
		// 	});
			
		// 	describe("Requester", {
		// 		it("should work with the echo server", function(done) {
		// 			var host = 'echo.websocket.org';
		// 			var connection = Connection.establish({host: host, port: 80});
		// 			var ws = new Requester(connection, 'http://$host');
					
		// 			var c = 0;
		// 			var n = 7;
		// 			var sender = new Accumulator();
		// 			ws.connect(sender).forEach(function(bytes) {
		// 				switch Frame.toMessage([Frame.fromBytes(bytes)]) {
		// 					case Some(Text(v)): v.should.be('payload' + ++c);
		// 					default: fail('Unexpected message');
		// 				}
		// 				if(c == n) done();
		// 				return c < n;
		// 			});
					
		// 			var key = Bytes.alloc(4);
		// 			for(i in 0...n) {
		// 				var frame = Frame.fromMessage(Text('payload' + (i + 1)));
		// 				frame.maskWith(key);
		// 				sender.yield(Data(frame.toBytes()));
		// 			}
		// 		});
		// 	});
			
		// 	describe("Responder", {
		// 		it("should work with the Requester", function(done) {
		// 			Server.bind(18088).handle(function(o) switch o {
		// 				case Success(server):
		// 					server.connected.handle(function(connection) {
		// 						var c = new Responder(connection);
		// 						var sender = new Accumulator();
		// 						c.connect(sender).forEach(function(bytes) {
		// 							// send back an identical but unmasked frame
		// 							var frame:Frame = bytes;
		// 							frame.unmask();
		// 							sender.yield(Data(frame.toBytes()));
		// 							return true;
		// 						});
		// 					});
							
		// 					var ws = new Requester(Connection.establish(18088), 'http://localhost');

		// 					var c = 0;
		// 					var n = 7;
		// 					var sender = new Accumulator();
		// 					ws.connect(sender).forEach(function(bytes) {
		// 						switch Frame.toMessage([Frame.fromBytes(bytes)]) {
		// 							case Some(Text(v)): v.should.be('payload' + ++c);
		// 							default: fail('Unexpected message');
		// 						}
		// 						if(c == n) done();
		// 						return c < n;
		// 					});
							
		// 					var key = Bytes.alloc(4);
		// 					for(i in 0...n) {
		// 						var frame = Frame.fromMessage(Text('payload' + (i + 1)));
		// 						frame.maskWith(key);
		// 						sender.yield(Data(frame.toBytes()));
		// 					}
							
		// 				case Failure(f): fail(f);
		// 			});
		// 		});
		// 	});
		// });
		
	}
	
	public function parseSingleFrame() {
		var source:IdealSource = arrayToBytes([129, 131, 61]);
		source = source.append(arrayToBytes([84, 35, 6, 112, 16, 109]));
		source.parseStream(new Parser()).forEach(function(chunk:tink.Chunk) {
			asserts.assert(chunk.toBytes().toHex() == '81833d54230670106d');
			var frame:Frame = chunk;
			asserts.assert(frame.fin == true);
			asserts.assert(frame.opcode == 1);
			asserts.assert(frame.mask == true);
			asserts.assert(frame.maskingKey.toHex() == '3d542306');
			asserts.assert(frame.maskedPayload.toHex() == '70106d');
			asserts.assert(frame.unmaskedPayload.toString() == 'MDN');
			return Resume;
		}).handle(function(o) {
			asserts.assert(o == Depleted);
			asserts.done();
		});
		return asserts;
	}
	
	function arrayToBytes(a:Array<Int>):Chunk {
		var bytes = Bytes.alloc(a.length);
		for(i in 0...a.length) bytes.set(i, a[i]);
		return bytes;
	}
}