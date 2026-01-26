defmodule LaapsWeb.GameLive do
  use LaapsWeb, :live_view

  import Ecto.Changeset

  def participant_changeset(attrs \\ %{}) do
    types = %{firstname: :string, lastname: :string, count: :integer}

    {%{}, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required([:firstname, :lastname, :count])
    |> validate_number(:count, greater_than: 0)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      <%= if @loading do %>
        <span class="loading loading-ball loading-xl"></span>
      <% else %>
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
          <%= for e <- @events do %>
            <% total = Laaps.Game.participants(e) %>
            <div class="mb-4">
              <div class="flex mb-4">
                <h2 class="font-bold text-xl"><Layouts.date date={e.date} /> {e.label}</h2>
                <div class="grow"></div>

                <button
                  class="btn btn-primary"
                  phx-click="open_modal"
                  phx-value-event_id={e.id}
                >
                  S'inscrire
                </button>
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

        <%= if @show_modal and @selected_event_id do %>
          <div class="fixed inset-0 z-50">
            <div class="absolute inset-0 bg-black/50" phx-click="close_modal"></div>
            <div class="relative flex items-center justify-center h-full pointer-events-none">
              <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl p-6 max-w-md w-full mx-4 pointer-events-auto">
                <h3 class="text-lg font-bold mb-4">
                  <% event = Enum.find(@events, &(&1.id == @selected_event_id)) %>
                  <%= if event do %>
                    S'inscrire à {event.label} du {Calendar.strftime(event.date, "%d/%m à %H:%M")}
                  <% else %>
                    S'inscrire à la soirée
                  <% end %>
                </h3>
                <.form
                  for={@participant_form}
                  id="participant-form"
                  phx-hook="LocalStorageForm"
                  phx-change="validate_participant"
                  phx-submit="submit_participant"
                >
                  <.input field={@participant_form[:firstname]} type="text" label="Prénom" />
                  <.input field={@participant_form[:lastname]} type="text" label="Nom" />
                  <.input
                    field={@participant_form[:count]}
                    type="number"
                    label="Nombre de personnes"
                    min="1"
                  />
                  <div class="flex justify-end space-x-2 mt-6">
                    <button type="button" class="btn btn-ghost" phx-click="close_modal">
                      Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">Valider</button>
                  </div>
                </.form>
                <script :type={Phoenix.LiveView.ColocatedHook} name=".LocalStorageForm">
                  export default {
                    mounted() {
                      // Load saved form data from localStorage
                      const savedData = localStorage.getItem('laaps_participant_form')
                      if (savedData) {
                        try {
                          const data = JSON.parse(savedData)
                          // Set form values
                          const firstnameInput = this.el.querySelector('[name="participant[firstname]"]')
                          const lastnameInput = this.el.querySelector('[name="participant[lastname]"]')
                          const countInput = this.el.querySelector('[name="participant[count]"]')
                          
                          if (firstnameInput && data.firstname) firstnameInput.value = data.firstname
                          if (lastnameInput && data.lastname) lastnameInput.value = data.lastname
                          if (countInput && data.count) countInput.value = data.count
                          
                          // Trigger change event to update LiveView state
                          if (firstnameInput && data.firstname) firstnameInput.dispatchEvent(new Event('input', { bubbles: true }))
                          if (lastnameInput && data.lastname) lastnameInput.dispatchEvent(new Event('input', { bubbles: true }))
                          if (countInput && data.count) countInput.dispatchEvent(new Event('input', { bubbles: true }))
                        } catch (e) {
                          console.error('Failed to parse saved form data:', e)
                        }
                      }
                    },
                    
                    // Save form data on submit
                    beforeDestroy() {
                      const firstnameInput = this.el.querySelector('[name="participant[firstname]"]')
                      const lastnameInput = this.el.querySelector('[name="participant[lastname]"]')
                      const countInput = this.el.querySelector('[name="participant[count]"]')
                      
                      if (firstnameInput && lastnameInput && countInput) {
                        const formData = {
                          firstname: firstnameInput.value || '',
                          lastname: lastnameInput.value || '',
                          count: countInput.value || '1'
                        }
                        
                        localStorage.setItem('laaps_participant_form', JSON.stringify(formData))
                      }
                    }
                  }
                </script>
              </div>
            </div>
          </div>
        <% end %>
      <% end %>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      events = Laaps.Game.future_events()

      {:ok,
       assign(socket,
         events: events,
         loading: false,
         show_modal: false,
         selected_event_id: nil,
         participant_form: to_form(participant_changeset(), as: :participant)
       )}
    else
      {:ok,
       assign(socket,
         events: [],
         loading: true,
         show_modal: false,
         selected_event_id: nil,
         participant_form: to_form(participant_changeset(), as: :participant)
       )}
    end
  end

  def handle_event("open_modal", %{"event_id" => event_id}, socket) do
    {:noreply,
     assign(socket,
       show_modal: true,
       selected_event_id: String.to_integer(event_id),
       participant_form: to_form(participant_changeset(), as: :participant)
     )}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply,
     assign(socket,
       show_modal: false,
       selected_event_id: nil,
       participant_form: to_form(participant_changeset(), as: :participant)
     )}
  end

  def handle_event("validate_participant", %{"participant" => params}, socket) do
    changeset = participant_changeset(params)
    {:noreply, assign(socket, participant_form: to_form(changeset, as: :participant))}
  end

  def handle_event("submit_participant", %{"participant" => params}, socket) do
    changeset = participant_changeset(params)

    if changeset.valid? do
      event = Enum.find(socket.assigns.events, &(&1.id == socket.assigns.selected_event_id))

      if event do
        firstname = get_field(changeset, :firstname)
        lastname = get_field(changeset, :lastname)
        count = get_field(changeset, :count)
        name = "#{firstname} #{lastname}"
        Laaps.Game.add_participant(event, name, count)
        events = Laaps.Game.future_events()

        {:noreply,
         assign(socket,
           events: events,
           show_modal: false,
           selected_event_id: nil,
           participant_form: to_form(participant_changeset(), as: :participant)
         )}
      else
        {:noreply,
         assign(socket,
           show_modal: false,
           selected_event_id: nil,
           participant_form: to_form(participant_changeset(), as: :participant)
         )}
      end
    else
      {:noreply, assign(socket, participant_form: to_form(changeset, as: :participant))}
    end
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, request_path: URI.parse(url).path)}
  end
end
