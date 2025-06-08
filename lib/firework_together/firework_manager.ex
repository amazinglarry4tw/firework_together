defmodule FireworkTogether.FireworkManager do
  @moduledoc """
  GenServer for managing firework state and automatic cleanup.
  """

  use GenServer
  alias FireworkTogether.Firework

  @cleanup_interval 1000
  @max_fireworks 100

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Creates a new firework and broadcasts it to all subscribers.
  """
  def create_firework(x, y, opts \\ []) do
    GenServer.call(__MODULE__, {:create_firework, x, y, opts})
  end

  @doc """
  Gets all active fireworks.
  """
  def get_fireworks do
    GenServer.call(__MODULE__, :get_fireworks)
  end

  @doc """
  Gets the count of active fireworks.
  """
  def count_fireworks do
    GenServer.call(__MODULE__, :count_fireworks)
  end

  # Server callbacks

  @impl true
  def init(_opts) do
    schedule_cleanup()
    {:ok, %{fireworks: []}}
  end

  @impl true
  def handle_call({:create_firework, x, y, opts}, _from, state) do
    firework = Firework.new(x, y, opts)
    
    # Add to state and limit total fireworks
    fireworks = [firework | state.fireworks] |> Enum.take(@max_fireworks)
    
    # Broadcast to all subscribers
    Phoenix.PubSub.broadcast(FireworkTogether.PubSub, "fireworks", {:new_firework, firework})
    
    {:reply, firework, %{state | fireworks: fireworks}}
  end

  @impl true
  def handle_call(:get_fireworks, _from, state) do
    {:reply, state.fireworks, state}
  end

  @impl true
  def handle_call(:count_fireworks, _from, state) do
    {:reply, length(state.fireworks), state}
  end

  @impl true
  def handle_info(:cleanup_expired, state) do
    # Remove expired fireworks
    active_fireworks = Enum.reject(state.fireworks, &Firework.expired?/1)
    
    # Schedule next cleanup
    schedule_cleanup()
    
    {:noreply, %{state | fireworks: active_fireworks}}
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup_expired, @cleanup_interval)
  end
end