defmodule GenReport do
  alias GenReport.Parser

  @available_months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(
      %{
        "all_hours" => %{},
        "hours_per_month" => %{},
        "hours_per_year" => %{}
      },
      &sum_values(&1, &2)
    )
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp sum_values(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         } = report
       ) do
    %{
      sum_all_hours: sum_all_hours,
      sum_hours_per_month: sum_hours_per_month,
      sum_hours_per_year: sum_hours_per_year
    } =
      sum_map_values_by_name(
        name,
        %{
          all_hours: all_hours,
          hours_per_month: hours_per_month,
          hours_per_year: hours_per_year
        },
        %{month: month, year: year, hours: hours}
      )

    %{
      report
      | "all_hours" => Map.put(all_hours, name, sum_all_hours),
        "hours_per_month" =>
          Map.put(
            hours_per_month,
            name,
            sum_hours_per_month
          ),
        "hours_per_year" =>
          Map.put(
            hours_per_year,
            name,
            sum_hours_per_year
          )
    }
  end

  defp sum_map_values_by_name(
         name,
         %{
           all_hours: all_hours,
           hours_per_month: hours_per_month,
           hours_per_year: hours_per_year
         },
         %{month: month, year: year, hours: hours}
       ) do
    current_value_all_hours = Map.get(all_hours, name, 0)

    current_value_hours_per_month =
      Map.get(hours_per_month, name, Enum.into(@available_months, %{}, &{&1, 0}))

    current_value_hours_per_year =
      Map.get(hours_per_year, name, Enum.into(2016..2020, %{}, &{&1, 0}))

    value_hours_per_month = Map.get(current_value_hours_per_month, month, 0)
    value_hours_per_year = Map.get(current_value_hours_per_year, year, 0)

    %{
      sum_all_hours: current_value_all_hours + hours,
      sum_hours_per_month:
        Map.merge(
          current_value_hours_per_month,
          Map.new([month], fn m -> {m, hours + value_hours_per_month} end)
        ),
      sum_hours_per_year:
        Map.merge(
          current_value_hours_per_year,
          Map.new([year], fn y -> {y, hours + value_hours_per_year} end)
        )
    }
  end
end
