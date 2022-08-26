defmodule MyLiveWeb.GameLive do
  use Phoenix.LiveView, layout: {MyLiveWeb.LayoutView, "live.html"}

  alias MyLive.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    state = new_game_state()
    |> Map.put(:session_id, session["live_socket_id"])
    |> Map.put(:current_user, user)
    {:ok, assign(socket, state)}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <h2>
      <%= if @won do %>
        Great job!
      <% else %>
        <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
        <% end %>
      <% end %>
    </h2>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    <button phx-click="new-game">Start a new game</button>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    won = guess == socket.assigns.correct_guess
    {new_score, message} = handle_guess(guess, socket.assigns.score, won)
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: new_score,
        won: won)
    }
  end
  def handle_event("new-game", _unused, socket) do
    state = new_game_state()
    |> Map.put(:session_id, socket.assigns.session_id)
    |> Map.put(:current_user, socket.assigns.current_user)
    {
      :noreply,
      assign(socket, state)
    }
  end

  defp handle_guess(guess, score, false) do
    message = "Your guess: #{guess}. Wrong. Guess again. "
    new_score = score - 1
    {new_score, message}
  end

  defp handle_guess(guess, _score, true) do
    message = "Your guess: #{guess}. This is correct! CONGRATULATIONS  :)"
    new_score = 10
    {new_score, message}
  end

  defp new_game_state() do
    %{score: 0, correct_guess: "5", message: "Make a guess:", won: false}
  end
end
