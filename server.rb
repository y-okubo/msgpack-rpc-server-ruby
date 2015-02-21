require 'msgpack/rpc'

# RPCメソッドを実装したクラス
class Server

  # helloメソッドを実装
  def hello
    return "Hello, World!"
  end

  def hello2
    return ["AAAA", "BBB日本語"]
  end

  # RPCの遅延リターン
  def async_hello
    # MessagePack::RPC::AsyncResult のインスタンスを返すと遅延リターンに
    as = MessagePack::RPC::AsyncResult.new

    Thread.new do
      # たとえばスレッドプールに投入して非同期でタスクを実行し...
      sleep 1
      # ...処理が終わったら結果を返す
      as.result "ok."
    end

    return as
  end
end

# 5000番ポートでlisten
svr = MessagePack::RPC::Server.new
svr.listen("127.0.0.1", 19850, Server.new)

# シグナルをキャッチしたら終了
Signal.trap(:TERM) { svr.stop }
Signal.trap(:INT)  { svr.stop }

puts 'Start MessagePack RPC Server'
svr.run