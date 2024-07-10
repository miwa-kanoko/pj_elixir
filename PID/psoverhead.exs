defmodule Psoverhead do
  def counter(next_pid) do
    receive do
      n -> send(next_pid, n + 1)
    end
  end

  def create_processes(n) do
    code_to_run =
      fn (_,send_to) ->
        spawn(Psoverhead, :counter, [send_to])
      end

      lastPID =
        Enum.reduce(1..n, self(), fn num, pid ->
           spawn(Psoverhead, :counter, [pid]) end)
      #最後に作ったプロセスIDへ0を送り、カウントを開始
      send(lastPID, 0)

      receive do
        final_answer -> "Result is #{inspect(final_answer)}"
      end
  end

  def run(n) do
    IO.inspect(:timer.tc(Psoverhead, :create_processes, [n] ))
  end
 end
