defmodule LaapsWeb.HomeLive do
  use LaapsWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} request_path={@request_path}>
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 my-4 max-h-40 overflow-y-auto">
        <h2 class="text-xl font-bold mb-2">News</h2>
        <%= if @loading do %>
          <div class="text-center"><span class="loading loading-ball loading-xl"></span></div>
        <% else %>
          <%= if @news == [] do %>
            <p>Il n'y a pas de news</p>
          <% else %>
            <%= for n <- @news do %>
              <div class="my-4">
                <h3 class="text-l font-bold">
                  [<Layouts.date date={n.inserted_at} format="%d/%m" />] {n.title}
                </h3>
                <p class="whitespace-pre-wrap">{n.content}</p>
              </div>
            <% end %>
          <% end %>
        <% end %>
      </div>
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow p-6 my-4 text-justify">
        <h2 class="text-xl font-bold pb-2">Qui sommes-nous ?</h2>
        <p class="my-2">
          Bienvenue ! Chaque mois (hors vacances scolaires), nous nous retrouvons à la salle du Laaps'Art à Montardon pour partager des moments conviviaux autour de nos jeux préférés 🎲. Que vous soyez amateur de stratégie, fan de jeux d'ambiance ou simplement curieux de découvrir de nouveaux univers ludiques, vous êtes les bienvenus !
        </p>

        <img class="m-auto rounded-md h-30" src={~p"/images/laaps-art-logo.png"} />
        <p class="text-xs faded italic text-center">
          Image 1 : Laaps'Art - Logo mural
        </p>

        <p class="my-2">
          Nos soirées se déroulent de <strong>20h30 à 23h00</strong>, rythmées par diverses parties adaptées à tous les niveaux. L'ambiance est chaleureuse et nous faisons en sorte que chacun trouve sa place, des plus jeunes aux plus expérimentés. Et pour clôturer la soirée en beauté, une partie de
          <a target="_blank" href="https://loupgarou.fandom.com/fr/wiki/Wiki_Loup-Garou">
            Loups-Garous de Thiercelieux
          </a>
          rassemble souvent tout le monde dans une atmosphère pleine de suspense et de fous rires !
        </p>

        <img class="m-auto rounded-md bg-white" src={~p"/images/jeux.png"} />
        <p class="text-xs faded italic text-center">
          Image 2 : Jeux de société
        </p>

        <p class="my-2">
          Pour adultes, ados, enfants <span class="underline">à partir de 6 ans</span>
          [<a class="text-xs" href="#mineurs">1</a>].
        </p>
        <p class="my-2">
          N'hésitez pas à venir seul(e), entre amis ou en famille - l'essentiel est de partager un bon moment ensemble 🎉 ! C'est
          <strong>gratuit</strong>
          pour tout le monde [<a
            class="text-xs"
            href="#places"
          >2</a>].
        </p>

        <p class="my-2">
          Pour voir les prochains dates et vous inscrire, rien de plus simple, cliquez sur l'onglet :
          <.link navigate={~p"/game"}>
            <svg
              class="size-[1.2em] inline text-[40px] font-white"
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
                >
                </path>
                <path
                  class="st0"
                  d="M293.532,231.202c-2.159,0-4.269,0.179-6.339,0.514c5.035-6.584,8.034-14.813,8.034-23.735
          c0-21.616-17.6-39.216-39.223-39.216c-21.624,0-39.224,17.6-39.224,39.216c0,8.922,2.999,17.151,8.034,23.735
          c-2.07-0.335-4.188-0.514-6.339-0.514c-21.633,0-39.224,17.599-39.224,39.215c0,21.633,17.591,39.232,39.224,39.232
          c12.091,0,22.912-5.508,30.106-14.137c-1.231,17.249-3.919,33.708-9.02,47.722h32.877c-5.093-14.014-7.781-30.473-9.02-47.722
          c7.203,8.629,18.023,14.137,30.114,14.137c21.633,0,39.216-17.6,39.216-39.232C332.748,248.801,315.165,231.202,293.532,231.202z"
                >
                </path>
                <path
                  class="st0"
                  d="M374.188,421.25c-0.928,0-1.833,0.073-2.713,0.211c2.151-2.827,3.455-6.371,3.455-10.217
          c0-9.296-7.578-16.882-16.883-16.882c-9.321,0-16.89,7.586-16.89,16.882c0,3.846,1.296,7.39,3.455,10.217
          c-0.888-0.138-1.793-0.211-2.722-0.211c-9.321,0-16.89,7.569-16.89,16.874c0,9.321,7.569,16.89,16.89,16.89
          c5.198,0,9.851-2.379,12.955-6.086c-0.529,7.431-1.694,14.503-3.886,20.549h14.161c-2.192-6.046-3.357-13.118-3.886-20.549
          c3.104,3.708,7.764,6.086,12.955,6.086c9.322,0,16.882-7.569,16.882-16.89C391.07,428.819,383.509,421.25,374.188,421.25z"
                >
                </path>
                <path
                  class="st0"
                  d="M187.008,96.429c0-9.304-7.578-16.874-16.89-16.874c-0.92,0-1.833,0.072-2.722,0.211
          c2.168-2.827,3.447-6.371,3.447-10.218c0-9.296-7.561-16.882-16.866-16.882c-9.321,0-16.898,7.586-16.898,16.882
          c0,3.846,1.287,7.391,3.455,10.218c-0.88-0.139-1.792-0.211-2.722-0.211c-9.304,0-16.882,7.569-16.882,16.874
          c0,9.321,7.578,16.89,16.882,16.89c5.207,0,9.86-2.379,12.956-6.087c-0.53,7.432-1.687,14.504-3.879,20.549h14.153
          c-2.192-6.046-3.349-13.118-3.886-20.549c3.105,3.708,7.757,6.087,12.963,6.087C179.43,113.32,187.008,105.75,187.008,96.429z"
                >
                </path>
              </g>
            </svg>
          </.link>
        </p>

        <p class="my-2">
          Une question ?
          <a href="mailto:soireejeuxmontardon@gmail.com">soireejeuxmontardon@gmail.com</a>
        </p>

        <p class="italic text-xs" id="mineurs">
          [1] Les mineurs doivent être accompagnés d'un adulte.
        </p>
        <p class="italic text-xs" id="places">
          [2] Places limitées.
        </p>

        <div class="card bg-base-100 w-96 shadow-sm m-auto my-4">
          <figure>
            <img
              src={~p"/images/laaps-art.jpg"}
              alt="Image du bâtiment du Laaps'art"
            />
          </figure>
          <p class="text-xs faded italic text-center">
            Image 3 : Bâtiment du Laaps'Art
          </p>
          <div class="card-body">
            <h2 class="card-title">Laaps'Art / Micro-Folie</h2>
            <p>2 chemin Penouilh, 64121 Montardon</p>

            <div class="card-actions justify-end">
              <a
                class="btn btn-primary"
                target="_blank"
                href="https://maps.app.goo.gl/HQUYzmbUWaF96dAa8"
              >
                Ouvrir sur Google Maps
              </a>
            </div>
          </div>
        </div>

        <p class="faded italic text-xs">
          Source image 1 :
          <a target="_blank" href="https://www.larepubliquedespyrenees.fr/">
            https://www.larepubliquedespyrenees.fr/
          </a>
        </p>
        <p class="faded italic text-xs">
          Source image 2 :
          <a target="_blank" href="https://www.prunay-le-gillon.fr/">
            https://www.prunay-le-gillon.fr/
          </a>
        </p>
        <p class="faded italic text-xs">
          Source image 3 :
          <a target="_blank" href="https://www.montardon.org/">https://www.montardon.org/</a>
        </p>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      news = Laaps.Game.news()

      {:ok,
       assign(socket,
         page_title: "Accueil - Soirée Jeux Montardon",
         news: news,
         loading: false
       )}
    else
      {:ok,
       assign(socket,
         page_title: "Accueil - Soirée Jeux Montardon",
         news: [],
         loading: true
       )}
    end
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, request_path: URI.parse(url).path)}
  end
end
