defmodule LaapsWeb.SettingsLive do
  use LaapsWeb, :live_view

  import Ecto.Changeset

  def settings_changeset(attrs \\ %{}) do
    types = %{firstname: :string, lastname: :string, count: :integer}

    {%{count: 1}, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required([:firstname, :lastname, :count],
      message: "Ce champ est obligatoire"
    )
    |> validate_length(:firstname,
      min: 1,
      max: 100,
      message: "Le prénom doit contenir entre 1 et 100 caractères"
    )
    |> validate_length(:lastname,
      min: 1,
      max: 100,
      message: "Le nom doit contenir entre 1 et 100 caractères"
    )
    |> validate_number(:count,
      greater_than: 0,
      message: "Le nombre de personnes doit être supérieur à 0"
    )
    |> validate_number(:count,
      less_than_or_equal_to: 10,
      message: "Le nombre de personnes ne peut pas dépasser 10"
    )
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h1 class="text-2xl font-bold mb-6">Paramètres</h1>

        <.form
          for={@settings_form}
          id="settings-form"
          phx-hook="LocalStorageForm"
          phx-change="validate_settings"
          phx-submit="save_settings"
          class="space-y-4"
        >
          <.input
            field={@settings_form[:firstname]}
            type="text"
            label="Prénom"
            placeholder="Votre prénom"
            class="input input-bordered w-full"
            required
          />
          <.input
            field={@settings_form[:lastname]}
            type="text"
            label="Nom"
            placeholder="Votre nom"
            class="input input-bordered w-full"
            required
          />
          <.input
            field={@settings_form[:count]}
            type="number"
            label="Nombre de personnes par défaut"
            placeholder="1"
            min="1"
            max="10"
            class="input input-bordered w-full"
            required
          />

          <div class="flex justify-end space-x-2 mt-6">
            <button
              type="button"
              class="btn btn-ghost"
              phx-click={
                JS.dispatch("clear:localstorage", to: "#settings-form") |> JS.push("reset_settings")
              }
              phx-disable-with="Réinitialisation..."
              aria-label="Réinitialiser les paramètres"
            >
              Réinitialiser
            </button>
            <button
              type="submit"
              class="btn btn-primary"
              phx-disable-with="Enregistrement..."
              aria-label="Enregistrer les paramètres"
            >
              Enregistrer
            </button>
          </div>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Paramètres - Soirée Jeux Montardon",
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

  def handle_event("reset_settings", _params, socket) do
    {:noreply,
     socket
     |> assign(
       settings_form:
         to_form(settings_changeset(%{firstname: "", lastname: "", count: 1}), as: :settings)
     )
     |> put_flash(:info, "Paramètres réinitialisés")}
  end
end
