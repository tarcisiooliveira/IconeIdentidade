defmodule IconeIdentidade do
  @moduledoc """
  Documentation for IconeIdentidade.
  """
  @doc """
  Main function, insert any string to generate a pixel_map refering the text
  # Exemple
      iex> IconeIdentidade.main("Elixir")
      :ok

  """
  def main(input) do
    input
    |> hash_input
    |> create_color
    |> create_table
    |> odd_remove
    |> constructor_pixel
    |> draw_pixel
    |> save_image(input)
  end

  @spec create_color(IconeIdentidade.Imagem.t()) :: IconeIdentidade.Imagem.t()

  # doubts in https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#binaries-and-bitstrings

  @doc """
    Function receve text and past Struct 'IconeIdentidade.Imagem' with text buffered at atom :hex in a list after have been md5 coded

      ##Exemple
        iex> IconeIdentidade.hash_input("Elixir")
        %IconeIdentidade.Imagem{
          color: nil,
          grid: nil,
          hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135,
          195],
          pixel_map: nil
        }
  """
  def hash_input(input) do
    # create a md5 hash e input in hex <<numeber, number>>
    hex =
      :crypto.hash(:md5, input)
      # transfor in a binary [number, number]
      |> :binary.bin_to_list()

    %IconeIdentidade.Imagem{hex: hex}
  end

  @doc """
    Create color who will fill generated image
    Use to this, 3 first numbers generated of :grid list, use :color to record this
      ##Exemple
        iex> IconeIdentidade.create_color(%IconeIdentidade.Imagem{color: nil, grid: nil, hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135,195], pixel_map: nil})
        %IconeIdentidade.Imagem{
          color: {161, 46, 176},
          grid: nil,
          hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135,
          195],
          pixel_map: nil
        }

  """
  def create_color(image) do
    %IconeIdentidade.Imagem{hex: hex_list} = image
    # use the left tupla and using underscore"_" to say
    [r, g, b | _tail] = hex_list
    # to not use the variable in right side, to not allocat memory
    # atribut to R, G and B 3 first values of map
    # unified old struct with the new, inserting
    %IconeIdentidade.Imagem{image | color: {r, g, b}}
    # the new color: value
  end

  @doc """
    'create_table' receive an '%IconeIdentidade.Imagem' and create a grid, where will be maped the print screen
      ##Exemple
        iex> IconeIdentidade.create_table(%IconeIdentidade.Imagem{color: {161, 46, 176}, grid: nil, hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135, 195], pixel_map: nil})
        %IconeIdentidade.Imagem{
          color: {161, 46, 176},
          grid: [
            {161, 0},
            {46, 1},
            {176, 2},
            {46, 3},
            {161, 4},
            {98, 5},
            {236, 6},
            {169, 7},
            {236, 8},
            {98, 9},
            {209, 10},
            {230, 11},
            {198, 12},
            {230, 13},
            {209, 14},
            {159, 15},
            {207, 16},
            {139, 17},
            {207, 18},
            {159, 19},
            {96, 20},
            {55, 21},
            {135, 22},
            {55, 23},
            {96, 24}
          ],
          hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135,
          195],
          pixel_map: nil
        }

  """

  def create_table(image) do
    %IconeIdentidade.Imagem{hex: hexa} = image

    grid =
      hexa
      # Chunk_every short the collection to groups of 3 itens, it will be used by 'to_mirror' to create a perfect square on grid
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&to_mirror/1)
      # To use a function as parameter use "&"
      # turn a map in a unique list [[1],[2, 3], 4] to [1 ,2 ,3 ,4]
      |> List.flatten()
      |> Enum.with_index()

    %IconeIdentidade.Imagem{image | grid: grid}
  end

  @doc """
    To mirror two first position in a list to the lestest position in the same list

    ##Exemple
      iex> IconeIdentidade.to_mirror([1,2,3])
      [1,2,3,2,1]

      iex> IconeIdentidade.to_mirror([Pedro, Paulo, Carlos])
      [Pedro, Paulo, Carlos, Paulo, Pedro]
  """
  def to_mirror(linha) do
    [first, second | _tail] = linha
    linha ++ [second, first]
  end

  @doc """
    Function used to remove grids who has odd value
      ##Exemple
        iex> IconeIdentidade.odd_remove(%IconeIdentidade.Imagem{ color: {161, 46, 176}, grid: [ {161, 0}, {46, 1}, {176, 2}, {46, 3}, {161, 4}, {98, 5}, {236, 6}, {169, 7}, {236, 8}, {98, 9}, {209, 10}, {230, 11}, {198, 12}, {230, 13}, {209, 14}, {159, 15}, {207, 16}, {139, 17}, {207, 18}, {159, 19}, {96, 20}, {55, 21}, {135, 22}, {55, 23}, {96, 24} ], hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135, 195], pixel_map: nil })
        %IconeIdentidade.Imagem{
          color: {161, 46, 176},
          grid: [
            {46, 1},
            {176, 2},
            {46, 3},
            {98, 5},
            {236, 6},
            {236, 8},
            {98, 9},
            {230, 11},
            {198, 12},
            {230, 13},
            {96, 20},
            {96, 24}
          ],
          hex: [161, 46, 176, 98, 236, 169, 209, 230, 198, 159, 207, 139, 96, 55, 135,
          195],
          pixel_map: nil
        }
  """
  def odd_remove(image) do
    %IconeIdentidade.Imagem{grid: grid} = image

    new_grid =
      Enum.filter(grid, fn {value, _indice} ->
        rem(value, 2) == 0
      end)

    # so retorna o que for verdadeiro na funcao
    %IconeIdentidade.Imagem{image | grid: new_grid}
  end

  @doc """
    Receive an 'Imagem' anda based on ':grid' value, generate start and final pixels position
      ##Exemple
        iex> IconeIdentidade.constructor_pixel(%IconeIdentidade.Imagem{color: nil,grid: [{46, 1},{176, 2},{46, 3}, {98, 5},{236, 6},{236, 8}, {98, 9},],hex: nil,pixel_map: nil})
        %IconeIdentidade.Imagem{
          color: nil,
          grid: [{46, 1}, {176, 2}, {46, 3}, {98, 5}, {236, 6}, {236, 8}, {98, 9}],
          hex: nil,
          pixel_map: [
            {{50, 0}, {100, 50}},
            {{100, 0}, {150, 50}},
            {{150, 0}, {200, 50}},
            {{0, 50}, {50, 100}},
            {{50, 50}, {100, 100}},
            {{150, 50}, {200, 100}},
            {{200, 50}, {250, 100}}
          ]
        }
  """
  def constructor_pixel(%IconeIdentidade.Imagem{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_valor, indice} ->
        h = rem(indice, 5) * 50
        v = div(indice, 5) * 50
        t_esquerda = {h, v}
        i_direita = {h + 50, v + 50}
        {t_esquerda, i_direita}
      end)

    %IconeIdentidade.Imagem{image | pixel_map: pixel_map}
  end

  @doc """
    Generate image joining all previous information
      ##Exemple

  """
  def draw_pixel(%IconeIdentidade.Imagem{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Save the file in project directory using the initial input as name.
  """
  def save_image(image, input_inicial) do
    File.write("#{input_inicial}.png", image)
  end

  @doc """
    Print the firsts letters in each word in the phrase
         ##Expemple
          iex> IconeIdentidade.shorter("your won phrase with many words")
          "YWPWMW"
  """
  def shorter(phrase) do
    String.split(phrase)
    |> Enum.map(fn n ->
      String.first(n)
      |> String.capitalize()
    end)
    |> Enum.join()
  end
end
