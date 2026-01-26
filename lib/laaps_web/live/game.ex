defmodule LaapsWeb.GameLive do
  use LaapsWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      <%= if @loading do %>
        <span class="loading loading-ball loading-xl"></span>
      <% else %>
        <dialog id="my_modal_1" class="modal">
          <div class="modal-box">
            <h3 class="text-lg font-bold">Inscription</h3>

            <div class="my-2">
              <label class="input w-full">
                <span class="label">Nom</span>
                <input type="text" name="lastname" />
              </label>
            </div>

            <div class="my-2">
              <label class="input w-full">
                <span class="label">Prénom</span>
                <input type="text" name="firstname" />
              </label>
            </div>

            <div class="my-2">
              <label class="input w-full">
                <span class="label">À combien ?</span>
                <input type="number" value="1" />
              </label>
            </div>

            <div class="modal-action">
              <form method="dialog">
                <!-- if there is a button in form, it will close the modal -->
                <button class="btn btn-primary">Valider</button>
                <button class="btn">Annuler</button>
              </form>
            </div>
          </div>
        </dialog>

        <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <%= for e <- @events do %>
            <% total = Laaps.Game.participants(e) %>
            <div class="mb-4">
              <div class="flex mb-4">
                <h2 class="font-bold text-xl"><Layouts.date date={e.date} /> {e.label}</h2>
                <div class="grow"></div>

                <button class="btn btn-primary" onclick="my_modal_1.showModal()">S'inscrire</button>
              </div>

              <p>
                <%= cond do %>
                  <% total == 0 -> %>
                    Il n'y a pas encore de participants inscrits.
                  <% total == 1 -> %>
                    Il y a 1 participant inscrit :
                  <% true -> %>
                    Il y a {total} participants inscrits :
                <% end %>
              </p>

              <ul class="list bg-base-100 rounded-box shadow-md">
                <%= for p <- e.participants do %>
                  <% {name, count} = Laaps.Game.Event.decode_participant(p) %>

                  <li class="list-row">
                    <div>
                      <img
                        class="size-10 rounded-box"
                        src="https://img.daisyui.com/images/profile/demo/1@94.webp"
                      />
                    </div>
                    <div>
                      <div>{name}</div>
                      <div class="text-xs uppercase font-semibold opacity-60">{count} personnes</div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      events = Laaps.Game.future_events()
      {:ok, assign(socket, events: events, loading: false)}
    else
      {:ok, assign(socket, events: [], loading: true)}
    end
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, request_path: URI.parse(url).path)}
  end
end
