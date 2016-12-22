defmodule VroomTest do
  use ExUnit.Case
  doctest Vroom

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Vroom.Repo, [])
    :ok
  end

  test "add_video: success" do
    assert {:ok, video} = Vroom.add_video(%{name: "Video 1", url: "http://youtube.com/video1", description: "video short description"})

    assert video.name == "Video 1"
  end

  test "add_video: failure" do
    assert {:error, _} = Vroom.add_video(%{name: "Video 1", description: "video short description"})
    assert {:error, _} = Vroom.add_video(%{name: "", url: "url", description: "video short description"})
  end

end
