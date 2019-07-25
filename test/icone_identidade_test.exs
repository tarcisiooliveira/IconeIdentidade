defmodule IconeIdentidadeTest do
  use ExUnit.Case
  doctest IconeIdentidade

  test "Check if main running and return thefout value" do
    assert IconeIdentidade.main("Elixir") == :ok
  end

  test "Should create a hexadecimal struct" do
    [p | _tail] = IconeIdentidade.hash_input("Elixir").hex
    assert p == 161
  end

  test "Check if was created correctly" do
    cor =
      IconeIdentidade.create_color(%IconeIdentidade.Imagem{
        color: nil,
        grid: nil,
        hex: [161, 46, 176, 98],
        pixel_map: nil
      }).color

    assert {161, 46, 176} == cor
  end

  test "Create table using ':grid' values, that who will be printed on screen" do
    grid =
      IconeIdentidade.create_table(%IconeIdentidade.Imagem{
        color: {161, 46, 176},
        grid: nil,
        hex: [161, 46, 176],
        pixel_map: nil
      }).grid

    assert grid == [{161, 0}, {46, 1}, {176, 2}, {46, 3}, {161, 4}]
  end

  test "Remov odd values" do
    grid =
      IconeIdentidade.odd_remove(%IconeIdentidade.Imagem{
        color: {161, 46, 176},
        grid: [{161, 0}, {46, 1}, {176, 2}, {46, 3}, {161, 4}],
        hex: [161, 46, 176],
        pixel_map: nil
      }).grid

    assert grid == [{46, 1}, {176, 2}, {46, 3}]
  end

  test " Generate pixels who will be printed on screen and store than in ':pixel_map'" do
    pixel_map =
      IconeIdentidade.constructor_pixel(%IconeIdentidade.Imagem{
        color: {161, 46, 176},
        grid: [{46, 1}, {176, 2}, {46, 3}],
        hex: [161, 46, 176],
        pixel_map: nil
      }).pixel_map

    assert pixel_map == [
             {{50, 0}, {100, 50}},
             {{100, 0}, {150, 50}},
             {{150, 0}, {200, 50}}
           ]
  end
end
