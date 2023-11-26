require "./spec_helper"

describe Sqids do
  default_alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  it "encodes and decodes simple numbers" do
    sqids = Sqids.new(min_length: default_alphabet.size.to_u8)

    numbers = [1, 2, 3] of UInt64
    id = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM"

    sqids.encode(numbers).should eq(id)
    sqids.decode(id).should eq(numbers)
  end

  it "encodes and decodes incremental" do
    numbers = [1, 2, 3] of UInt64
    map = {
       6 => "86Rf07",
       7 => "86Rf07x",
       8 => "86Rf07xd",
       9 => "86Rf07xd4",
      10 => "86Rf07xd4z",
      11 => "86Rf07xd4zB",
      12 => "86Rf07xd4zBm",
      13 => "86Rf07xd4zBmi",
    }
    map[default_alphabet.size + 0] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM"
    map[default_alphabet.size + 1] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMy"
    map[default_alphabet.size + 2] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf"
    map[default_alphabet.size + 3] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf1"

    map.each do |min_length, id|
      sqids = Sqids.new(min_length: min_length.to_u8)

      sqids.encode(numbers).should eq(id)
      sqids.encode(numbers).size.should eq(min_length)
      sqids.decode(id).should eq(numbers)
    end
  end

  it "encodes and decodes incremental numbers" do
    sqids = Sqids.new(min_length: default_alphabet.size.to_u8)

    ids = {
      "SvIzsqYMyQwI3GWgJAe17URxX8V924Co0DaTZLtFjHriEn5bPhcSkfmvOslpBu" => [0, 0] of UInt64,
      "n3qafPOLKdfHpuNw3M61r95svbeJGk7aAEgYn4WlSjXURmF8IDqZBy0CT2VxQc" => [0, 1] of UInt64,
      "tryFJbWcFMiYPg8sASm51uIV93GXTnvRzyfLleh06CpodJD42B7OraKtkQNxUZ" => [0, 2] of UInt64,
      "eg6ql0A3XmvPoCzMlB6DraNGcWSIy5VR8iYup2Qk4tjZFKe1hbwfgHdUTsnLqE" => [0, 3] of UInt64,
      "rSCFlp0rB2inEljaRdxKt7FkIbODSf8wYgTsZM1HL9JzN35cyoqueUvVWCm4hX" => [0, 4] of UInt64,
      "sR8xjC8WQkOwo74PnglH1YFdTI0eaf56RGVSitzbjuZ3shNUXBrqLxEJyAmKv2" => [0, 5] of UInt64,
      "uY2MYFqCLpgx5XQcjdtZK286AwWV7IBGEfuS9yTmbJvkzoUPeYRHr4iDs3naN0" => [0, 6] of UInt64,
      "74dID7X28VLQhBlnGmjZrec5wTA1fqpWtK4YkaoEIM9SRNiC3gUJH0OFvsPDdy" => [0, 7] of UInt64,
      "30WXpesPhgKiEI5RHTY7xbB1GnytJvXOl2p0AcUjdF6waZDo9Qk8VLzMuWrqCS" => [0, 8] of UInt64,
      "moxr3HqLAK0GsTND6jowfZz3SUx7cQ8aC54Pl1RbIvFXmEJuBMYVeW9yrdOtin" => [0, 9] of UInt64,
    }

    ids.each do |id, numbers|
      sqids.encode(numbers).should eq(id)
      sqids.decode(id).should eq(numbers)
    end
  end

  it "encodes with different min lengths" do
    [0, 1, 5, 10, default_alphabet.size].each do |min_length|
      cases : Array(Array(UInt64)) = [
        [0] of UInt64,
        [0, 0, 0, 0, 0] of UInt64,
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] of UInt64,
        [100, 200, 300] of UInt64,
        [1_000, 2_000, 3_000] of UInt64,
        [1_000_000] of UInt64,
        [UInt64::MAX],
      ]
      cases.each do |numbers|
        sqids = Sqids.new(min_length: min_length.to_u8)

        id = sqids.encode(numbers)
        id.size.should be >= min_length
        sqids.decode(id).should eq(numbers)
      end
    end
  end
end
