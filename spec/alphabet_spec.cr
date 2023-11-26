require "./spec_helper"

describe Sqids do
  it "encodes and decodes using simple alphabet" do
    sqids = Sqids.new(alphabet: "0123456789abcdef")

    numbers = [1, 2, 3] of UInt64
    id = "489158"

    sqids.encode(numbers).should eq(id)
    sqids.decode(id).should eq(numbers)
  end

  it "decodes after encoding with a short alphabet" do
    sqids = Sqids.new(alphabet: "abc")

    numbers = [1, 2, 3] of UInt64
    encoded = sqids.encode(numbers)

    sqids.decode(encoded).should eq(numbers)
  end

  it "decodes after encoding with a long alphabet" do
    sqids = Sqids.new(alphabet: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+|{}[];:'\"/?.>,<`~")

    numbers = [1, 2, 3] of UInt64
    encoded = sqids.encode(numbers)

    sqids.decode(encoded).should eq(numbers)
  end

  it "fails when alphabet has multibyte characters" do
    expect_raises(ArgumentError) do
      Sqids.new(alphabet: "ë1092")
    end
  end

  it "fails when alphabet characters are repeated" do
    expect_raises(ArgumentError) do
      Sqids.new(alphabet: "aabcdefg")
    end
  end

  it "fails when alphabet is too short" do
    expect_raises(ArgumentError) do
      Sqids.new(alphabet: "ab")
    end
  end
end
