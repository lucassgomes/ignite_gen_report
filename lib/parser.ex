defmodule GenReport.Parser do
  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> convert_tail_list()
  end

  defp convert_tail_list([head | tail]) do
    [hours, day, month, year] = Enum.map(tail, &String.to_integer/1)
    [transform_name(head) | [hours, day, convert_month(month), year]]
  end

  defp transform_name(name) do
    name
    |> String.trim()
    |> String.downcase()
  end

  defp convert_month(month) do
    case month do
      1 -> "janeiro"
      2 -> "fevereiro"
      3 -> "março"
      4 -> "abril"
      5 -> "maio"
      6 -> "junho"
      7 -> "julho"
      8 -> "agosto"
      9 -> "setembro"
      10 -> "outubro"
      11 -> "novembro"
      12 -> "dezembro"
      _ -> "marco"
    end
  end
end
