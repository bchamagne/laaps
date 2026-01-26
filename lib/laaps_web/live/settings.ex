defmodule LaapsWeb.SettingsLive do
  use LaapsWeb, :live_view

  import Ecto.Changeset

  def settings_changeset(attrs \\ %{}) do
    types = %{firstname: :string, lastname: :string, count: :integer}

    {%{}, types}
    |> cast(attrs, Map.keys(types))
    |> validate_number(:count, greater_than: 0)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h1 class="text-2xl font-bold mb-6">Paramètres</h1>

        <.form
          for={@settings_form}
          id="settings-form"
          phx-hook="SettingsLocalStorage"
          phx-change="validate_settings"
          phx-submit="save_settings"
        >
          <div class="space-y-4">
            <.input field={@settings_form[:firstname]} type="text" label="Prénom" />
            <.input field={@settings_form[:lastname]} type="text" label="Nom" />
            <.input
              field={@settings_form[:count]}
              type="number"
              label="Nombre de personnes par défaut"
              min="1"
            />

            <div class="flex justify-end space-x-2 mt-6">
              <button type="submit" class="btn btn-primary">Enregistrer</button>
            </div>
          </div>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       settings_form: to_form(settings_changeset(), as: :settings)
     )}
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, request_path: URI.parse(url).path)}
  end

  def handle_event("validate_settings", %{"settings" => params}, socket) do
    changeset = settings_changeset(params)
    {:noreply, assign(socket, settings_form: to_form(changeset, as: :settings))}
  end

  def handle_event("save_settings", %{"settings" => params}, socket) do
    changeset = settings_changeset(params)

    if changeset.valid? do
      {:noreply,
       socket
       |> assign(settings_form: to_form(changeset, as: :settings))
       |> put_flash(:info, "Paramètres enregistrés")}
    else
      {:noreply, assign(socket, settings_form: to_form(changeset, as: :settings))}
    end
  end
end
