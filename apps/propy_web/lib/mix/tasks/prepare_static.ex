defmodule Mix.Tasks.PrepareStatic do
  use Mix.Task
  use OkJose
  @shortdoc "Custom!"
  
  # Because mix always runs from root, File.cwd will return root of the project
  @destination "#{File.cwd!}/priv/static/"
  
  def run(args) do
    # todo, we could pipe even more
    case prepare(args) do
      {:ok, data} -> transfer(data) |> output_result
      {:error, error} -> IO.puts(error)
    end
  end

  defp output_result({_, result}), do: IO.inspect(result)

  defp transfer(%{source: source, destination: destination}) do
    IO.puts "Clean destination..."
    File.rm_rf!(destination)
    File.mkdir!(destination)  # because with rm_rf we remove also folder itslef
    IO.puts "Copying from #{source} to #{destination}..."
    result = File.cp_r(source, destination)
  end

  defp prepare(args) do
    {:ok, %{}}
    |> put_change(:destination, {:ok, @destination})
    |> validate_file(:destination)
    |> put_change(:source, get_source_directory(args))
    |> validate_file(:source)
    |> Pipe.ok
  end

  defp put_change(data, key, {:ok, value} = tupple) do
    {:ok, Map.put(data, key, value)}
  end

  defp put_change(data, key, {:error, error} = tupple) do
    tupple
  end

  defp validate_file(data, key) do
    value = Map.get(data, key)
    if File.exists?(value) do
      {:ok, data}
    else
      {:error, "#{value} is not a valid file!"}
    end
  end

  defp get_source_directory(args) do
    {valid, _, _} = OptionParser.parse(args, strict: [s: :string])
    if valid[:s] do
      {:ok, valid[:s]}
    else
      {:error, "Unknown source as argument!"}
    end
  end
end