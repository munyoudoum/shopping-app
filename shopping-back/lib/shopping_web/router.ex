defmodule ShoppingWeb.Router do
  use ShoppingWeb, :router

  pipeline :auth do
    plug Shopping.UserManager.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ShoppingWeb do
    pipe_through [:api, :auth]
    post "/users", UserController, :register
    post "/users/login", UserController, :login
    # automatically generated routes for product_inventories
    # TODO: allow only GET all
    resources "/product_inventories", InventoryController, except: [:new, :edit]
  end

  # protected routes
  scope "/api", ShoppingWeb do
    pipe_through [:api, :auth, :ensure_auth]
    get "/users/me", UserController, :me
    post "/purchase", PurchaseController, :purchase
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:shopping, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ShoppingWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
