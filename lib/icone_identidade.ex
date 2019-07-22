defmodule IconeIdentidade do
  @moduledoc """
  Documentation for IconeIdentidade.
  """

  def main(input) do
    input
    |> hash_input
    |> create_color
    |> create_table
    |> renover_impar
    |> constroi_pixel
    |> desenhar
    |> salvar(input)
  end

  @spec create_color(IconeIdentidade.Imagem.t()) :: IconeIdentidade.Imagem.t()


  # doubts in https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#binaries-and-bitstrings
  def hash_input(input) do
    hex = :crypto.hash(:md5, input) #create a md5 hash e input in hex <<numeber, number>>
    |> :binary.bin_to_list #transfor in a binary [number, number]
    %IconeIdentidade.Imagem{hex: hex}
  end

  def create_color(imagem) do
    %IconeIdentidade.Imagem{hex: hex_list} = imagem
    [r, g, b | _tail] = hex_list #use the left tupla and using underscore"_" to say
                                 #to not use the variable in right side, to not allocat memory
                                 #atribut to R, G and B 3 first values of map
    %IconeIdentidade.Imagem{imagem | color: {r,g,b}} #unified old struct with the new, inserting
                                                     #the new color: value

  end
  def create_table(imagem) do
    %IconeIdentidade.Imagem{hex: hexa} = imagem
    grid = hexa
    |> Enum.chunk(3) #Encurta a colecao para um grupo grupo de 3
    |> Enum.map(&espelhar/1) #passa cada linha do map como paramentro para o map realizar a função espelhar
                              #To use a function as parameter use "&"
    |> List.flatten # Pega o map e transforma em uma unica lista de caracteres [[1],[2]] se torna [1,2]
    |> Enum.with_index
    %IconeIdentidade.Imagem{imagem | grid: grid} #concatena à estrutura um grid
  end

  def espelhar(linha)do
    [first, second | _tail] = linha
    linha ++ [second, first]
  end

  def renover_impar(imagem) do
    %IconeIdentidade.Imagem{grid: grid} = imagem
    new_grid = Enum.filter(grid, fn({valor, _indice}) ->
      rem(valor, 2) == 0
      end ) #so retorna o que for verdadeiro na funcao
      %IconeIdentidade.Imagem{imagem | grid: new_grid}

  end

  def constroi_pixel(%IconeIdentidade.Imagem{grid: grid}=imagem)do
    pixel_map = Enum.map(grid, fn{_valor, indice}->
      h = rem(indice, 5) * 50
      v = div(indice, 5) * 50
      t_esquerda = {h, v}
      i_direita = {h+50, v+50}
      {t_esquerda,i_direita}
      end)
      %IconeIdentidade.Imagem{imagem | pixel_map:  pixel_map}
  end

  def desenhar(%IconeIdentidade.Imagem{color: cor, pixel_map: pixel_map}) do
    imagem = :egd.create(250, 250)
    preencha = :egd.color(cor)

    Enum.each(pixel_map, fn{start, stop} ->
      :egd.filledRectangle(imagem, start, stop, preencha)
    end)
    :egd.render(imagem)
  end

  def salvar(imagem, input_inicial) do
    File.write("#{input_inicial}.png", imagem)
  end
end
