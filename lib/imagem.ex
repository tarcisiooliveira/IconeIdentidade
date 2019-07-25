defmodule IconeIdentidade.Imagem do
  @moduledoc """
  Documentação da estrutura de uma `Imagem`
  """

  @doc """
  Define a estrutura da `Imagem`

    * :hex - hexadecimal da imagem
    * :cor - a cor da imagem
    * :grid - a grid que gera a imagem
    * :pixel_map - gera onde será preenchido com a imagem
  """

  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
