defmodule FireworkTogether.Firework do
  @moduledoc """
  Defines the Firework struct and related functions.
  """

  defstruct [:id, :x, :y, :color, :created_at, :duration]

  @type t :: %__MODULE__{
    id: String.t(),
    x: integer(),
    y: integer(),
    color: String.t(),
    created_at: integer(),
    duration: integer()
  }

  @doc """
  Creates a new firework with the given coordinates.
  """
  def new(x, y, opts \\ []) do
    %__MODULE__{
      id: Keyword.get(opts, :id, generate_id()),
      x: round(x),
      y: round(y),
      color: Keyword.get(opts, :color, random_color()),
      created_at: Keyword.get(opts, :created_at, System.system_time(:millisecond)),
      duration: Keyword.get(opts, :duration, 3000)
    }
  end

  @doc """
  Checks if a firework has expired based on its duration.
  """
  def expired?(%__MODULE__{created_at: created_at, duration: duration}) do
    System.system_time(:millisecond) - created_at > duration
  end

  @doc """
  Returns a list of available firework colors.
  """
  def colors do
    [
      "#ff0080", # Hot pink
      "#00ff80", # Green
      "#8000ff", # Purple
      "#ff8000", # Orange
      "#0080ff", # Blue
      "#ffff00", # Yellow
      "#ff0040", # Red
      "#40ff00", # Lime
      "#ff4080", # Pink
      "#80ff40"  # Light green
    ]
  end

  defp generate_id do
    :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
  end

  defp random_color do
    Enum.random(colors())
  end
end