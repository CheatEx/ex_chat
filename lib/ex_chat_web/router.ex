defmodule ExChatWeb.Router do
  use ExChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline,
      module: ExChat.Guardian,
      error_handler: ExChatWeb.AuthController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource,
      allow_blank: true
  end

  pipeline :browser_auth do
    plug Guardian.Plug.Pipeline,
      module: ExChat.Guardian,
      error_handler: ExChatWeb.AuthController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExChatWeb do
    pipe_through :browser

    resources "/users", UserController, [:new, :create]
    resources "/sessions", SessionController, only: [:create, :delete, :new]
    get "/", ChatController, :redirect_index
  end

  scope "/", ExChatWeb do
    pipe_through [:browser, :browser_auth]

    resources "/users", UserController, only: [:show, :index, :update]
    resources "/chat", ChatController, [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExChatWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ExChatWeb.Telemetry
    end
  end
end
