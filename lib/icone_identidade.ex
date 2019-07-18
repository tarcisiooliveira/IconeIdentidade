defmodule IconeIdentidade do
  @moduledoc """
  Documentation for IconeIdentidade.
  """

  def main(input) do
    input
    |> hash_input
    |> create_color
  end

  def create_color(imagem) do
    %IconeIdentidade.Imagem{hex: hex_list} = imagem
    [r, g, b | _tail] = hex_list #use the left tupla and using underscore"_" to say
                                 #to not use the variable in right side, to not allocating memory
                                 #atribut to R, G and B 3 first values of map
    %IconeIdentidade.Imagem{imagem | color: {r,g,b}} #unified old struct with the new, inserting
                                                     #the new color: value

  end

  # doubts in https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#binaries-and-bitstrings
  def hash_input(input) do
    hex = :crypto.hash(:md5, input) #create a md5 hash e input in hex <<numeber, number>>
    |> :binary.bin_to_list #transfor in a binary [number, number]
    %IconeIdentidade.Imagem{hex: hex}
  end

end
