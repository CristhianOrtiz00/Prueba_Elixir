# ------------------------ Module attributes -------------------------------------------------
"""
Los atributos del módulo sirven para 3 propositos
  1. Sirven para anotar el módulo, a menudo con información para ser utilizada por el usuario o la máquina virtual.
  2. Funcionan como constantes.
  3. Funcionan como un módulo de almacenamiento temporal para ser utilizado durante la compilación.
"""

# ------------------------ As annotations -------------------------------------------------
defmodule MyServer do
  @moduledoc "My server code."  # Se define la documentación del módulo utilizando la sintaxis del atributo de módulo
end
"""
Elixir tiene varios atributos reservados, los más utilizados son:
  * @moduledoc - provides documentation for the current module.
  * @doc - provides documentation for the function or macro that follows the attribute.
  * @spec - provides a typespec for the function that follows the attribute.
  * @behaviour - (nótese la ortografía británica) se utiliza para especificar un comportamiento OTP o definido por el usuario.
"""
# Elixir trata la documentación como algo de primera clase y proporciona muchas funciones para acceder a la documentación
"""
h Math # Access the docs for the module Math
h Math.sum # Access the docs for the sum function
"""
# ---------------------- As "constants" ----------------------------------------------------------
defmodule MyServer do
  @initial_state %{host: "127.0.0.1", port: 3456}
  IO.inspect @initial_state

  @my_data 14
  def first_data, do: @my_data
  @my_data 13
  def second_data, do: @my_data
end
# MyServer.first_data     #=> 14
# MyServer.second_data    #=> 13

# Se puede llamar a funciones al definir un atributo de módulo:
defmodule MyApp.Status do
  @service URI.parse("https://example.com")
  def status(email) do
    SomeHttpClient.get(@service)
  end
end

# La función anterior se llamará en el momento de la compilación y su valor devuelto, es lo que se sustituirá
# por el atributo. Por lo tanto, lo anterior se compilará efectivamente en esto:
defmodule MyApp.Status do
  def status(email) do
    SomeHttpClient.get(%URI{
      authority: "example.com",
      host: "example.com",
      port: 443,
      scheme: "https"
    })
  end
end
# Esto puede ser útil para precómputo de valores constantes, pero también puede causar problemas si
# espera que se llame a la función en tiempo de ejecución

# ----- Accumulating attributes ------------
# Normalmente, repetir un atributo de módulo hará que se reasigne su valor, pero hay circunstancias en las
# que es posible que desee configurar el atributo de módulo para que se acumulen sus valores:
defmodule Foo do
  Module.register_attribute __MODULE__, :param, accumulate: true

  @param :foo
  @param :bar
  # here @param == [:bar, :foo]
end

# ------------------------- As temporary storage --------------------------------------------------------
defmodule MyTest do
  use ExUnit.Case, async: true

  @tag :external
  @tag os: :unix
  test "contacts external service" do
    # ...
  end
end
# En el ejemplo anterior, ExUnit almacena el valor de async: true en un atributo del módulo para cambiar
# cómo se compila el módulo. Las etiquetas también se definen como atributos accumulate: true, y almacenan
# etiquetas que pueden utilizarse para configurar y filtrar pruebas.
