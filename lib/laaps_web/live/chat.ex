defmodule LaapsWeb.ChatLive do
  use LaapsWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      Chat temperature: {@temperature}°F <button phx-click="inc_temperature">+</button>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    # Let's assume a fixed temperature for now
    temperature = 70
    {:ok, assign(socket, temperature: temperature)}
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, request_path: URI.parse(url).path)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
