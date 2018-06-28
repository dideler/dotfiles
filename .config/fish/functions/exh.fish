function exh -d "Gives help for an Elixir/Erlang module or function"
  iex -e "require IEx.Helpers; IEx.Helpers.h($argv); :erlang.halt" | cat
end
