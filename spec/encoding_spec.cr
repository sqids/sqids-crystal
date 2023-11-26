require "./spec_helper"

describe Sqids do
  it "simple" do
    sqids = Sqids.new

    numbers = [1, 2, 3] of UInt64
    id = "86Rf07"

    sqids.encode(numbers).should eq(id)
    sqids.decode(id).should eq(numbers)
  end

  it "different inputs" do
    sqids = Sqids.new

    numbers = [0, 0, 0, 1, 2, 3, 100, 1_000, 100_000, 1_000_000, UInt64::MAX] of UInt64
    sqids.decode(sqids.encode(numbers)).should eq(numbers)
  end

  it "incremental numbers" do
    sqids = Sqids.new

    ids = {
      "bM" => [0_u64],
      "Uk" => [1_u64],
      "gb" => [2_u64],
      "Ef" => [3_u64],
      "Vq" => [4_u64],
      "uw" => [5_u64],
      "OI" => [6_u64],
      "AX" => [7_u64],
      "p6" => [8_u64],
      "nJ" => [9_u64],
    }

    ids.each do |id, numbers|
      sqids.encode(numbers).should eq(id)
      sqids.decode(id).should eq(numbers)
    end
  end

  it "incremental numbers, same index 0" do
    sqids = Sqids.new

    ids = {
      "SvIz" => [0_u64, 0_u64],
      "n3qa" => [0_u64, 1_u64],
      "tryF" => [0_u64, 2_u64],
      "eg6q" => [0_u64, 3_u64],
      "rSCF" => [0_u64, 4_u64],
      "sR8x" => [0_u64, 5_u64],
      "uY2M" => [0_u64, 6_u64],
      "74dI" => [0_u64, 7_u64],
      "30WX" => [0_u64, 8_u64],
      "moxr" => [0_u64, 9_u64],
    }

    ids.each do |id, numbers|
      sqids.encode(numbers).should eq(id)
      sqids.decode(id).should eq(numbers)
    end
  end

  it "incremental numbers, same index 1" do
    sqids = Sqids.new

    ids = {
      "SvIz" => [0_u64, 0_u64],
      "nWqP" => [1_u64, 0_u64],
      "tSyw" => [2_u64, 0_u64],
      "eX68" => [3_u64, 0_u64],
      "rxCY" => [4_u64, 0_u64],
      "sV8a" => [5_u64, 0_u64],
      "uf2K" => [6_u64, 0_u64],
      "7Cdk" => [7_u64, 0_u64],
      "3aWP" => [8_u64, 0_u64],
      "m2xn" => [9_u64, 0_u64],
    }

    ids.each do |id, numbers|
      sqids.encode(numbers).should eq(id)
      sqids.decode(id).should eq(numbers)
    end
  end

  it "multi input" do
    sqids = Sqids.new

    numbers = (0_u64..99_u64).to_a
    output = sqids.decode(sqids.encode(numbers))
    numbers.should eq(output)
  end

  it "encoding no numbers" do
    sqids = Sqids.new
    sqids.encode([] of UInt64).should eq("")
  end

  it "decoding empty string" do
    sqids = Sqids.new
    sqids.decode("").should eq([] of UInt64)
  end

  it "decoding an ID with an invalid character" do
    sqids = Sqids.new
    sqids.decode("*").should eq([] of UInt64)
  end
end
