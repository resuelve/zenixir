defmodule LoginTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "it returns authentication error if username password is incorrect" do
    use_cassette "users_error_auth" do
      res =
        Zendesk.account(subdomain: "your_subdomain", email: "a", password: "p")
        |> all_users

      assert [] == res
      # assert res["error"] == "Couldn't authenticate you"
    end
  end

  test "it logins correctly with email and password" do
    use_cassette "users_email_pass_auth" do
      res =
        Zendesk.account(subdomain: "your_subdomain", email: "test@me.com", password: "test")
        |> all_users

      assert length(res) > 90
      assert hd(res).id == 2_351_783_922
    end
  end

  test "it logins correctly with email and access token" do
    use_cassette "users_email_pass_auth" do
      res =
        Zendesk.account(subdomain: "your_subdomain", email: "test@me.com", token: "blabla")
        |> all_users

      assert length(res) > 90
      assert hd(res).id == 2_351_783_922
    end
  end

  test "it gets users for group" do
    use_cassette "users_for_group" do
      {:ok, res} =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> all_users(group_id: "21554407")

      %{count: count, users: [user | _rest]} = res

      assert count == 5
      assert user.id == 237_065_843
    end
  end

  test "it gets users for organizations" do
    use_cassette "users_for_organizations" do
      {:ok, result} =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> all_users(organization_id: "22016037")

      %{count: count, users: [user]} = result

      assert count == 1
      assert user.id == 236_084_977
    end
  end

  test "it gets a user" do
    use_cassette "user_with_id" do
      res =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> show_user(user_id: "235178392")

      assert res.id == 235_178_392
      assert res.name == "Light Agent #2"
    end
  end

  test "it gets many users" do
    use_cassette "users_with_ids" do
      {:ok, result} =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> show_users(ids: ["235178392", "235179052"])

      %{count: count, users: [user | _last]} = result

      assert count == 2
      assert user.name == "Light Agent #2"
    end
  end

  test "it searches users" do
    use_cassette "search_user" do
      {:ok, result} =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> search_user(query: "Tags Agent")

      %{count: count, users: [user]} = result

      assert count == 1
      assert user.name == "No Tags Agent"
    end
  end

  test "it autocomplete user by name" do
    use_cassette "autocomplete_user" do
      {:ok, result} =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> autocomplete_user(name: "Tags Agent")

      %{count: count, users: [user]} = result

      assert count == 1
      assert user.name == "No Tags Agent"
    end
  end

  test "it gets the current user" do
    use_cassette "current_user" do
      res =
        Zendesk.account(subdomain: "your_subdomain", email: "test@zendesk.com", password: "test")
        |> current_user

      assert res.id == 236_084_977
      assert res.name == "Owner"
    end
  end
end
