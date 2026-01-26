defmodule LaapsWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LaapsWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :request_path, :string, required: true, doc: "used for the dock"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="bg-white dark:bg-gray-800 shadow">
      <div class="max-w-4xl mx-auto px-4 py-6">
        <div class="flex">
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Laaps Jeux</h1>
          <div class="grow"></div>

          <Layouts.theme_toggle />
        </div>
      </div>
    </header>

    <main class="max-w-4xl mx-auto px-4 py-8">
      {render_slot(@inner_block)}
    </main>

    <footer class="dock">
      <Layouts.dock_button label="Accueil" path="/" icon="home" request_path={@request_path} />
      <Layouts.dock_button label="Soirées" path="/game" icon="game" request_path={@request_path} />
      <Layouts.dock_button label="Chat" path="/chat" icon="chat" request_path={@request_path} />
      <Layouts.dock_button
        label="Paramètres"
        path="/settings"
        icon="settings"
        request_path={@request_path}
      />
    </footer>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title="We can't find the internet"
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        Attempting to reconnect
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title="Something went wrong!"
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        Attempting to reconnect
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/2 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=dark]_&]:left-1/2 transition-[left]" />
      <button
        class="flex p-2 cursor-pointer w-1/2"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
      <button
        class="flex p-2 cursor-pointer w-1/2"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  def dock_button(assigns) do
    active_class =
      if assigns.request_path == assigns.path do
        "dock-active"
      else
        ""
      end

    svg =
      case assigns.icon do
        "home" -> icon_home(assigns)
        "game" -> icon_game(assigns)
        "chat" -> icon_chat(assigns)
        "settings" -> icon_settings(assigns)
      end

    assigns = assign(assigns, active_class: active_class, svg: svg)

    ~H"""
    <a class={@active_class} href={@path}>
      {@svg}
      <span class="dock-label">{@label}</span>
    </a>
    """
  end

  attr :date, DateTime, required: true

  def date(assigns) do
    ~H"""
    {Calendar.strftime(@date, "%d/%m à %H:%M")}
    """
  end

  def icon_home(assigns) do
    ~H"""
    <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <g fill="currentColor" stroke-linejoin="miter" stroke-linecap="butt">
        <polyline
          points="1 11 12 2 23 11"
          fill="none"
          stroke="currentColor"
          stroke-miterlimit="10"
          stroke-width="2"
        >
        </polyline>
        <path
          d="m5,13v7c0,1.105.895,2,2,2h10c1.105,0,2-.895,2-2v-7"
          fill="none"
          stroke="currentColor"
          stroke-linecap="square"
          stroke-miterlimit="10"
          stroke-width="2"
        >
        </path>
        <line
          x1="12"
          y1="22"
          x2="12"
          y2="18"
          fill="none"
          stroke="currentColor"
          stroke-linecap="square"
          stroke-miterlimit="10"
          stroke-width="2"
        >
        </line>
      </g>
    </svg>
    """
  end

  def icon_game(assigns) do
    ~H"""
    <svg
      class="size-[1.2em]"
      version="1.1"
      id="_x32_"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      viewBox="0 0 512 512"
      xml:space="preserve"
    >
      <style type="text/css">
        .st0{fill:currentColor;}
      </style>
      <g>
        <path
          class="st0"
          d="M392.292,0H119.707C95.28,0,75.506,19.791,75.506,44.202v423.597c0,24.41,19.775,44.193,44.202,44.202h272.585
    c24.419-0.008,44.194-19.783,44.202-44.202V44.202C436.486,19.783,416.711,0.008,392.292,0z M392.292,490.311H119.707
    c-12.434-0.024-22.488-10.079-22.512-22.512V44.202c0.024-12.434,10.078-22.488,22.512-22.512h272.585
    c12.426,0.024,22.488,10.087,22.513,22.512v423.597C414.78,480.224,404.718,490.286,392.292,490.311z"
        />
        <path
          class="st0"
          d="M293.532,231.202c-2.159,0-4.269,0.179-6.339,0.514c5.035-6.584,8.034-14.813,8.034-23.735
    c0-21.616-17.6-39.216-39.223-39.216c-21.624,0-39.224,17.6-39.224,39.216c0,8.922,2.999,17.151,8.034,23.735
    c-2.07-0.335-4.188-0.514-6.339-0.514c-21.633,0-39.224,17.599-39.224,39.215c0,21.633,17.591,39.232,39.224,39.232
    c12.091,0,22.912-5.508,30.106-14.137c-1.231,17.249-3.919,33.708-9.02,47.722h32.877c-5.093-14.014-7.781-30.473-9.02-47.722
    c7.203,8.629,18.023,14.137,30.114,14.137c21.633,0,39.216-17.6,39.216-39.232C332.748,248.801,315.165,231.202,293.532,231.202z"
        />
        <path
          class="st0"
          d="M374.188,421.25c-0.928,0-1.833,0.073-2.713,0.211c2.151-2.827,3.455-6.371,3.455-10.217
    c0-9.296-7.578-16.882-16.883-16.882c-9.321,0-16.89,7.586-16.89,16.882c0,3.846,1.296,7.39,3.455,10.217
    c-0.888-0.138-1.793-0.211-2.722-0.211c-9.321,0-16.89,7.569-16.89,16.874c0,9.321,7.569,16.89,16.89,16.89
    c5.198,0,9.851-2.379,12.955-6.086c-0.529,7.431-1.694,14.503-3.886,20.549h14.161c-2.192-6.046-3.357-13.118-3.886-20.549
    c3.104,3.708,7.764,6.086,12.955,6.086c9.322,0,16.882-7.569,16.882-16.89C391.07,428.819,383.509,421.25,374.188,421.25z"
        />
        <path
          class="st0"
          d="M187.008,96.429c0-9.304-7.578-16.874-16.89-16.874c-0.92,0-1.833,0.072-2.722,0.211
    c2.168-2.827,3.447-6.371,3.447-10.218c0-9.296-7.561-16.882-16.866-16.882c-9.321,0-16.898,7.586-16.898,16.882
    c0,3.846,1.287,7.391,3.455,10.218c-0.88-0.139-1.792-0.211-2.722-0.211c-9.304,0-16.882,7.569-16.882,16.874
    c0,9.321,7.578,16.89,16.882,16.89c5.207,0,9.86-2.379,12.956-6.087c-0.53,7.432-1.687,14.504-3.879,20.549h14.153
    c-2.192-6.046-3.349-13.118-3.886-20.549c3.105,3.708,7.757,6.087,12.963,6.087C179.43,113.32,187.008,105.75,187.008,96.429z"
        />
      </g>
    </svg>
    """
  end

  def icon_chat(assigns) do
    ~H"""
    <svg
      class="size-[1.2em]"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      x="0px"
      y="0px"
      viewBox="0 0 256 256"
      enable-background="new 0 0 256 256"
      xml:space="preserve"
    >
      <g>
        <g>
          <g>
            <path
              fill="currentColor"
              d="M25.1,21.1c-4.6,1.1-10.2,5.4-12.5,9.6C9.9,35.8,10,32.2,10,105c0,58.4,0.1,67,0.7,69.4c1.9,7,6.6,12.1,13.3,14.2c2.5,0.8,5.1,0.8,36.7,0.8h34l-0.3,1.5c-0.1,0.8-1.4,9.1-2.9,18.4c-2.3,14.9-2.5,17.1-2,19c1.4,5.6,7.5,8.5,12.7,6c1.3-0.6,9.3-8.3,23.8-22.9l21.9-22h40.7c39.7,0,40.7,0,43.5-0.9c6.8-2.3,11.3-7.2,13.1-14.1c0.6-2.4,0.7-11,0.7-69.4c0-72.8,0.1-69.3-2.6-74.4c-1.7-3.1-5.6-6.6-9.3-8.4l-3.1-1.5l-102-0.1C70.6,20.7,26.2,20.9,25.1,21.1z M231.7,31.3c1.9,1.2,2.8,2.1,3.8,4l1.3,2.5V105v67.2l-1.3,2.4c-1.6,3-4.2,4.9-7.5,5.6c-1.6,0.3-17.7,0.5-43.3,0.5H144l-22.7,22.7c-12.4,12.4-22.7,22.6-22.8,22.5c-0.1-0.1,6.1-42.1,6.6-44.1l0.2-1H67.9c-23.4,0-38.4-0.2-39.9-0.5c-3.3-0.6-5.9-2.5-7.5-5.6l-1.3-2.4V105V37.8l1.3-2.5c1-1.9,1.9-2.8,3.8-4l2.5-1.5H128h101.2L231.7,31.3z"
            /><path
              fill="currentColor"
              d="M90.3,95.3c-2.4,0.8-4,2.1-5.1,3.9c-2.2,3.7-1.8,8.1,1.1,11.3c2,2.3,3.9,3.1,7,3.1c5.5,0,9.4-3.8,9.4-9.3c0-4.4-2.7-8.1-6.9-9.2C93.5,94.5,92.6,94.5,90.3,95.3z"
            /><path
              fill="currentColor"
              d="M125.1,95.3c-3.7,1.3-5.4,3.2-6.4,6.9c-1.4,5.1,2.6,10.8,7.9,11.3c3.6,0.3,5.4-0.2,7.7-2.3c2.4-2.2,3.6-5.5,3.1-8.2c-0.4-2-1.7-4.6-2.8-5.6C132.1,95.1,128,94.2,125.1,95.3z"
            /><path
              fill="currentColor"
              d="M159.9,95.1c-9.9,3-8.4,17.6,1.9,18.4c3.6,0.3,5.6-0.5,7.8-2.9c2.9-3.1,3.4-7.3,1.4-11.2C169.1,95.9,164,93.9,159.9,95.1z"
            />
          </g>
        </g>
      </g>
    </svg>
    """
  end

  def icon_settings(assigns) do
    ~H"""
    <svg class="size-[1.2em]" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <g fill="currentColor" stroke-linejoin="miter" stroke-linecap="butt">
        <circle
          cx="12"
          cy="12"
          r="3"
          fill="none"
          stroke="currentColor"
          stroke-linecap="square"
          stroke-miterlimit="10"
          stroke-width="2"
        >
        </circle>
        <path
          d="m22,13.25v-2.5l-2.318-.966c-.167-.581-.395-1.135-.682-1.654l.954-2.318-1.768-1.768-2.318.954c-.518-.287-1.073-.515-1.654-.682l-.966-2.318h-2.5l-.966,2.318c-.581.167-1.135.395-1.654.682l-2.318-.954-1.768,1.768.954,2.318c-.287.518-.515,1.073-.682,1.654l-2.318.966v2.5l2.318.966c.167.581.395,1.135.682,1.654l-.954,2.318,1.768,1.768,2.318-.954c.518.287,1.073.515,1.654.682l.966,2.318h2.5l.966-2.318c.581-.167,1.135-.395,1.654-.682l2.318.954,1.768-1.768-.954-2.318c.287-.518.515-1.073.682-1.654l2.318-.966Z"
          fill="none"
          stroke="currentColor"
          stroke-linecap="square"
          stroke-miterlimit="10"
          stroke-width="2"
        >
        </path>
      </g>
    </svg>
    """
  end
end
