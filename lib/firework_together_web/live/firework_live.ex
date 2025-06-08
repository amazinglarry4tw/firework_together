defmodule FireworkTogetherWeb.FireworkLive do
  use FireworkTogetherWeb, :live_view
  alias FireworkTogether.FireworkManager

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(FireworkTogether.PubSub, "fireworks")
    end

    {:ok, stream(socket, :fireworks, [])}
  end

  @impl true
  def handle_event("create_firework", %{"x" => x, "y" => y}, socket) do
    FireworkManager.create_firework(x, y)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_firework, firework}, socket) do
    # Use stream to append new fireworks without re-rendering existing ones
    {:noreply, stream_insert(socket, :fireworks, firework)}
  end

  @impl true
  def handle_info({:cleanup_firework, firework}, socket) do
    # Remove expired firework from the stream
    {:noreply, stream_delete(socket, :fireworks, firework)}
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

      <div id="fireworks" phx-update="stream">
        <%= for {id, firework} <- @streams.fireworks do %>
          <div class={["firework", "absolute", "pointer-events-none", FireworkTogether.Firework.css_class(firework.type)]}
               id={id}
               style={"left: #{firework.x}px; top: #{firework.y}px; --firework-color: #{firework.color};"}>
            <!-- Create multiple particles for realistic circular explosion -->
            <div class="firework-explosion">
              <!-- First ring - 8 particles -->
              <%= for i <- 1..8 do %>
                <div class="particle" style={"--angle: #{i * 45}deg; --delay: #{rem(i, 4) * 0.05}s; --distance: 120px;"}></div>
              <% end %>
              <!-- Second ring - 12 particles -->
              <%= for i <- 1..12 do %>
                <div class="particle secondary" style={"--angle: #{i * 30}deg; --delay: #{0.2 + rem(i, 3) * 0.1}s; --distance: 100px;"}></div>
              <% end %>
              <!-- Third ring - 16 particles -->
              <%= for i <- 1..16 do %>
                <div class="particle tertiary" style={"--angle: #{i * 22.5}deg; --delay: #{0.4 + rem(i, 4) * 0.1}s; --distance: 80px;"}></div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

end