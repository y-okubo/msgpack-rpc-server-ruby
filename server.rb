require 'msgpack/rpc'

# RPCメソッドを実装したクラス
class Server

  def hello
    return "Hello, World!"
  end

  def method_with_argument(a)
    puts "Object Type: #{a.class.to_s}"
    puts "Object value: #{a}"
    puts ""
  end

  def method_return_fixnum
    return 100000
  end

  def method_return_bignum
    return 100000 * 100000
  end

  def method_return_string
    return 'ABC'
  end

  def method_return_boolean
    return true
  end

  def method_return_array
    return ['A', 'B' , 100]
  end

  def method_return_hash
    return {:a => 'aaa', 'b' => 'bbb', 1 => 1000}
  end

  def async_hello
    # MessagePack::RPC::AsyncResult のインスタンスを返すと遅延リターンに
    as = MessagePack::RPC::AsyncResult.new

    Thread.new do
      # たとえばスレッドプールに投入して非同期でタスクを実行し...
      sleep 10
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