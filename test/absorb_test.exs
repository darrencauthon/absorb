defmodule AbsorbTest do
  use ExUnit.Case

  test "the first test directory" do
    assert Absorb.Files.at("test_files/one") == ['files.txt']
  end

end
