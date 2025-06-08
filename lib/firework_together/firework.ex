defmodule FireworkTogether.Firework do
  @moduledoc """
  Defines the Firework struct and related functions.
  """

  defstruct [:id, :x, :y, :color, :created_at, :duration, :type]

  @type t :: %__MODULE__{
    id: String.t(),
    x: integer(),
    y: integer(),
    color: String.t(),
    created_at: integer(),
    duration: integer(),
    type: atom()
  }

  @doc """
  Creates a new firework with the given coordinates.
  """
  def new(x, y, opts \\ []) do
    firework_type = Keyword.get(opts, :type, random_type())
    
    %__MODULE__{
      id: Keyword.get(opts, :id, generate_id()),
      x: round(x),
      y: round(y),
      color: Keyword.get(opts, :color, random_color()),
      created_at: Keyword.get(opts, :created_at, System.system_time(:millisecond)),
      duration: Keyword.get(opts, :duration, 7000),
      type: firework_type
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
      "#80ff40", # Light green
      "#ff6600", # Bright orange
      "#ff0066", # Magenta
      "#66ff00", # Electric lime
      "#0066ff", # Royal blue
      "#ff3300", # Bright red
    ]
  end

  @doc """
  Returns a list of available firework types.
  """
  def types do
    [:burst, :sparkler, :fountain, :willow]
  end

  @doc """
  Gets the CSS class for a firework type.
  """
  def css_class(:burst), do: "firework-burst"
  def css_class(:sparkler), do: "firework-sparkler"
  def css_class(:fountain), do: "firework-fountain"
  def css_class(:willow), do: "firework-willow"
  def css_class(_), do: "firework-burst"

  defp generate_id do
    :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
  end

  defp random_color do
    Enum.random(colors())
  end

  defp random_type do
    Enum.random(types())
  end
end