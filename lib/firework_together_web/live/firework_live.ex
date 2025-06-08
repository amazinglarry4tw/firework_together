defmodule FireworkTogetherWeb.FireworkLive do
  use FireworkTogetherWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(FireworkTogether.PubSub, "fireworks")
    end

    {:ok, assign(socket, :fireworks, [])}
  end

  @impl true
  def handle_event("create_firework", %{"x" => x, "y" => y}, socket) do
    firework = %{
      id: System.unique_integer([:positive]),
      x: x,
      y: y,
      color: random_color(),
      created_at: System.system_time(:millisecond)
    }

    Phoenix.PubSub.broadcast(FireworkTogether.PubSub, "fireworks", {:new_firework, firework})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_firework, firework}, socket) do
    fireworks = [firework | socket.assigns.fireworks]
    {:noreply, assign(socket, :fireworks, fireworks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="firework-container" 
         class="h-screen w-screen bg-black overflow-hidden relative cursor-crosshair"
         phx-hook="ClickHandler">
      
      <div class="absolute top-4 left-4 text-white text-lg font-bold">
        Firework Together
      </div>
      
      <div class="absolute top-4 right-4 text-white text-sm">
        Click anywhere to create fireworks!
      </div>

      <%= for firework <- @fireworks do %>
        <div class="firework absolute pointer-events-none"
             style={"left: #{firework.x}px; top: #{firework.y}px; --firework-color: #{firework.color};"}>
          <div class="firework-explosion"></div>
        </div>
      <% end %>
    </div>
    """
  end

  defp random_color do
    colors = ["#ff0080", "#00ff80", "#8000ff", "#ff8000", "#0080ff", "#ffff00", "#ff0040", "#40ff00"]
    Enum.random(colors)
  end
end