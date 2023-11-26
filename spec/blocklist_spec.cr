require "./spec_helper"

describe Sqids do
  it "uses default blocklist if no custom blocklist is provided" do
    sqids = Sqids.new

    sqids.decode("aho1e").should eq([4_572_721])
    sqids.encode([4_572_721] of UInt64).should eq("JExTR")
  end

  it "does not use any blocklist if an empty blocklist is provided" do
    sqids = Sqids.new(blocklist: Set(String).new)

    sqids.decode("aho1e").should eq([4_572_721])
    sqids.encode([4_572_721] of UInt64).should eq("aho1e")
  end

  it "uses provided blocklist if non-empty blocklist is provided" do
    sqids = Sqids.new(blocklist: Set.new(["ArUO"]))

    sqids.decode("aho1e").should eq([4_572_721])
    sqids.encode([4_572_721] of UInt64).should eq("aho1e")

    sqids.decode("ArUO").should eq([100_000])
    sqids.encode([100_000] of UInt64).should eq("QyG4")
    sqids.decode("QyG4").should eq([100_000])
  end

  it "uses blocklist to prevent certain encodings" do
    sqids = Sqids.new(blocklist: Set.new(%w[JSwXFaosAN OCjV9JK64o rBHf 79SM 7tE6]))

    sqids.encode([1_000_000, 2_000_000] of UInt64).should eq("1aYeB7bRUt")
    sqids.decode("1aYeB7bRUt").should eq([1_000_000, 2_000_000])
  end

  it "can decode blocklist words" do
    sqids = Sqids.new(blocklist: Set.new(%w[86Rf07 se8ojk ARsz1p Q8AI49 5sQRZO]))

    sqids.decode("86Rf07").should eq([1, 2, 3])
    sqids.decode("se8ojk").should eq([1, 2, 3])
    sqids.decode("ARsz1p").should eq([1, 2, 3])
    sqids.decode("Q8AI49").should eq([1, 2, 3])
    sqids.decode("5sQRZO").should eq([1, 2, 3])
  end

  it "matches against a short blocklist word" do
    sqids = Sqids.new(blocklist: Set.new(["pnd"]))

    sqids.decode(sqids.encode([1_000] of UInt64)).should eq([1_000])
  end

  it "blocklist filtering in constructor" do
    # lowercase blocklist in only-uppercase alphabet
    sqids = Sqids.new(alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", blocklist: Set.new(["sxnzkl"]))

    id = sqids.encode([1, 2, 3] of UInt64)
    numbers = sqids.decode(id)

    id.should eq("IBSHOZ") # without blocklist, would've been "SXNZKL"
    numbers.should eq([1, 2, 3])
  end

  it "max encoding attempts" do
    alphabet = "abc"
    min_length = 3_u8
    blocklist = Set.new(%w[cab abc bca])

    sqids = Sqids.new(alphabet: alphabet, min_length: min_length, blocklist: blocklist)

    min_length.should eq(alphabet.size)
    min_length.should eq(blocklist.size)

    expect_raises(ArgumentError) { sqids.encode([0] of UInt64) }
  end
end
