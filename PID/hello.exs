# 2. Hello関数が呼び出される
defmodule Hello do
  def greet do
  receive do
   {sender, name} ->
     send(sender, {:ok, "Hello, #{name}"})
       #IO.inspect(binding(),label: "Hello.great receive message")
        #再帰処理
        #greet()
     end
   end
  end

  # 1. ⼦プロセスを⽣成
    pid = spawn(Hello, :greet, [])
     #IO.inspect(binding(),label: "After the child process is called")
     send(pid, {self(), "Thewaggle"})
     receive do
       {:ok, message} -> IO.puts(message)
     end

   send(pid, {self(), "world"})
   #IO.inspect(binding(),label: "After Send/2 sent to self process")
    # 3秒待つ
    # :timer.sleep(3000)

  # マッチするメッセージ（ここでは{:ok, "Hello, world"}）を受信した場合、IO.putsで受取ったメッセージ"Hello, world"を出⼒する。
   receive do
    {:ok, message} -> IO.puts(message)
    # IO.inspect(binding(),label: "receive message")
    # after ミリ秒でタイムアウトする時間を指定できる
  after
    3000 ->
      IO.puts("Nothing happened.")
  end


  # 3. 親プロセスからのメッセージをreceive/1で待ち受ける
  # 4. 親プロセスが⼦プロセスにメッセージを送信。⼦プロセスに対し、self()で親プロセス自身のPIDを送ることで、どこに返事すればいいか分かる。
  # 5. マッチするメッセージ（ここでは親のプロセスIDと"world"）を受信した場合、親のプロセスに{:ok, "Hello, world"}を送信する
  # 6. ⼦プロセスからのメッセージをreceive/1で待ち受ける
