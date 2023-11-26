# A [Sqids](https://sqids.org/) encoder and decoder.
#
# Example:
#
# ```
# sqids = Sqids.new
#
# id = sqids.encode([1, 2, 3])
# # => "86Rf07"
#
# numbers = sqids.decode(id)
# # => [1, 2, 3]
# ```
class Sqids
  private DEFAULT_ALPHABET   = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  private DEFAULT_MIN_LENGTH = 0_u8
  private DEFAULT_BLOCKLIST  = Set.new(%w[0rgasm 1d10t 1d1ot 1di0t 1diot 1eccacu10 1eccacu1o 1eccacul0 1eccaculo 1mbec11e 1mbec1le 1mbeci1e 1mbecile a11upat0 a11upato a1lupat0 a1lupato aand ah01e ah0le aho1e ahole al1upat0 al1upato allupat0 allupato ana1 ana1e anal anale anus arrapat0 arrapato arsch arse ass b00b b00be b01ata b0ceta b0iata b0ob b0obe b0sta b1tch b1te b1tte ba1atkar balatkar bastard0 bastardo batt0na battona bitch bite bitte bo0b bo0be bo1ata boceta boiata boob boobe bosta bran1age bran1er bran1ette bran1eur bran1euse branlage branler branlette branleur branleuse c0ck c0g110ne c0g11one c0g1i0ne c0g1ione c0gl10ne c0gl1one c0gli0ne c0glione c0na c0nnard c0nnasse c0nne c0u111es c0u11les c0u1l1es c0u1lles c0ui11es c0ui1les c0uil1es c0uilles c11t c11t0 c11to c1it c1it0 c1ito cabr0n cabra0 cabrao cabron caca cacca cacete cagante cagar cagare cagna cara1h0 cara1ho caracu10 caracu1o caracul0 caraculo caralh0 caralho cazz0 cazz1mma cazzata cazzimma cazzo ch00t1a ch00t1ya ch00tia ch00tiya ch0d ch0ot1a ch0ot1ya ch0otia ch0otiya ch1asse ch1avata ch1er ch1ng0 ch1ngadaz0s ch1ngadazos ch1ngader1ta ch1ngaderita ch1ngar ch1ngo ch1ngues ch1nk chatte chiasse chiavata chier ching0 chingadaz0s chingadazos chingader1ta chingaderita chingar chingo chingues chink cho0t1a cho0t1ya cho0tia cho0tiya chod choot1a choot1ya chootia chootiya cl1t cl1t0 cl1to clit clit0 clito cock cog110ne cog11one cog1i0ne cog1ione cogl10ne cogl1one cogli0ne coglione cona connard connasse conne cou111es cou11les cou1l1es cou1lles coui11es coui1les couil1es couilles cracker crap cu10 cu1att0ne cu1attone cu1er0 cu1ero cu1o cul0 culatt0ne culattone culer0 culero culo cum cunt d11d0 d11do d1ck d1ld0 d1ldo damn de1ch deich depp di1d0 di1do dick dild0 dildo dyke encu1e encule enema enf01re enf0ire enfo1re enfoire estup1d0 estup1do estupid0 estupido etr0n etron f0da f0der f0ttere f0tters1 f0ttersi f0tze f0utre f1ca f1cker f1ga fag fica ficker figa foda foder fottere fotters1 fottersi fotze foutre fr0c10 fr0c1o fr0ci0 fr0cio fr0sc10 fr0sc1o fr0sci0 fr0scio froc10 froc1o froci0 frocio frosc10 frosc1o frosci0 froscio fuck g00 g0o g0u1ne g0uine gandu go0 goo gou1ne gouine gr0gnasse grognasse haram1 harami haramzade hund1n hundin id10t id1ot idi0t idiot imbec11e imbec1le imbeci1e imbecile j1zz jerk jizz k1ke kam1ne kamine kike leccacu10 leccacu1o leccacul0 leccaculo m1erda m1gn0tta m1gnotta m1nch1a m1nchia m1st mam0n mamahuev0 mamahuevo mamon masturbat10n masturbat1on masturbate masturbati0n masturbation merd0s0 merd0so merda merde merdos0 merdoso mierda mign0tta mignotta minch1a minchia mist musch1 muschi n1gger neger negr0 negre negro nerch1a nerchia nigger orgasm p00p p011a p01la p0l1a p0lla p0mp1n0 p0mp1no p0mpin0 p0mpino p0op p0rca p0rn p0rra p0uff1asse p0uffiasse p1p1 p1pi p1r1a p1rla p1sc10 p1sc1o p1sci0 p1scio p1sser pa11e pa1le pal1e palle pane1e1r0 pane1e1ro pane1eir0 pane1eiro panele1r0 panele1ro paneleir0 paneleiro patakha pec0r1na pec0rina pecor1na pecorina pen1s pendej0 pendejo penis pip1 pipi pir1a pirla pisc10 pisc1o pisci0 piscio pisser po0p po11a po1la pol1a polla pomp1n0 pomp1no pompin0 pompino poop porca porn porra pouff1asse pouffiasse pr1ck prick pussy put1za puta puta1n putain pute putiza puttana queca r0mp1ba11e r0mp1ba1le r0mp1bal1e r0mp1balle r0mpiba11e r0mpiba1le r0mpibal1e r0mpiballe rand1 randi rape recch10ne recch1one recchi0ne recchione retard romp1ba11e romp1ba1le romp1bal1e romp1balle rompiba11e rompiba1le rompibal1e rompiballe ruff1an0 ruff1ano ruffian0 ruffiano s1ut sa10pe sa1aud sa1ope sacanagem sal0pe salaud salope saugnapf sb0rr0ne sb0rra sb0rrone sbattere sbatters1 sbattersi sborr0ne sborra sborrone sc0pare sc0pata sch1ampe sche1se sche1sse scheise scheisse schlampe schwachs1nn1g schwachs1nnig schwachsinn1g schwachsinnig schwanz scopare scopata sexy sh1t shit slut sp0mp1nare sp0mpinare spomp1nare spompinare str0nz0 str0nza str0nzo stronz0 stronza stronzo stup1d stupid succh1am1 succh1ami succhiam1 succhiami sucker t0pa tapette test1c1e test1cle testic1e testicle tette topa tr01a tr0ia tr0mbare tr1ng1er tr1ngler tring1er tringler tro1a troia trombare turd twat vaffancu10 vaffancu1o vaffancul0 vaffanculo vag1na vagina verdammt verga w1chsen wank wichsen x0ch0ta x0chota xana xoch0ta xochota z0cc01a z0cc0la z0cco1a z0ccola z1z1 z1zi ziz1 zizi zocc01a zocc0la zocco1a zoccola])

  private alias UInt = UInt8 | UInt16 | UInt32 | UInt64

  @alphabet : String
  @min_length : Int32
  @blocklist : Set(String)

  # Creates a Sqids encoder and decoder.
  #
  # Can take a custom alphabet.
  # By default, `"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"` is used.
  #
  # ```
  # sqids = Sqids.new(alphabet: "abc")
  #
  # id = sqids.encode([1, 2, 3])
  # # => "aacacbaa"
  #
  # numbers = sqids.decode(id)
  # # => [1, 2, 3]
  # ```
  #
  # Can take a minimum length,
  # which defaults to 0 (no minimum length).
  #
  # ```
  # sqids = Sqids.new(min_length: 10_u8)
  #
  # sqids.encode([1, 2, 3])
  # # => "86Rf07xd4z"
  # ```
  #
  # Can take a custom blocklist of words to avoid.
  # Defaults to a long list of words.
  #
  # ```
  # sqids = Sqids.new(blocklist: Set.new(%w[86Rf07]))
  #
  # id = sqids.encode([1, 2, 3])
  # # => "se8ojk"
  #
  # numbers = sqids.decode(id)
  # # => [1, 2, 3]
  # ```
  def initialize(alphabet : String = DEFAULT_ALPHABET, min_length : UInt8 = DEFAULT_MIN_LENGTH, blocklist : Set(String) = DEFAULT_BLOCKLIST)
    raise ArgumentError.new("Alphabet cannot contain multibyte characters") if contains_multibyte_chars(alphabet)
    raise ArgumentError.new("Alphabet size must be at least 3") if alphabet.size < 3

    if alphabet.chars.uniq.size != alphabet.size
      raise ArgumentError.new("Alphabet must contain unique characters")
    end

    filtered_blocklist = blocklist
      .select { |word| word.size >= 3 && (word.downcase.chars - alphabet.downcase.chars).empty? }
      .map { |word| word.downcase }
      .to_set

    @alphabet = shuffle(alphabet)
    @min_length = Int32.new(min_length)
    @blocklist = filtered_blocklist
  end

  # Encode an array of numbers into a Sqid string.
  #
  # If the array is empty, an empty string is returned.
  #
  # ```
  # sqids = Sqids.new
  #
  # sqids.encode([1, 2, 3] of UInt64)
  # # => "86Rf07"
  # ```
  def encode(numbers : Array(UInt8 | UInt16 | UInt32 | UInt64)) : String
    # Note that we don't use the `UInt` alias in the type above because
    # it doesn't expand in the API documentation. It's easier to understand
    # the full type union than a private alias.
    return "" if numbers.empty?
    encode_numbers(numbers)
  end

  # Like `encode`, but takes signed integers.
  #
  # If any of the numbers are negative, an `OverflowError` is raised.
  #
  # ```
  # sqids = Sqids.new
  #
  # sqids.encode([1, 2, 3])
  # # => "86Rf07"
  # ```
  def encode(numbers : Array(Int8 | Int16 | Int32 | Int64)) : String
    return "" if numbers.empty?
    uints = numbers.map do |n|
      raise OverflowError.new("Number must be positive") if n.negative?
      UInt64.new(n)
    end
    encode_numbers(uints)
  end

  # Decode a Sqid string into an array of numbers.
  #
  # If the argument is an empty string, an empty array is returned.
  #
  # ```
  # sqids = Sqids.new
  #
  # sqids.decode("86Rf07")
  # # => [1, 2, 3]
  # ```
  def decode(id : String) : Array(UInt64)
    ret = [] of UInt64

    return ret if id.empty?

    alphabet_chars = @alphabet.chars.to_set
    id.chars.each do |c|
      return ret unless alphabet_chars.includes?(c)
    end

    prefix = id[0]
    offset = @alphabet.index(prefix)
    return ret if offset.nil?

    alphabet = @alphabet.byte_slice(offset, @alphabet.size) + @alphabet.byte_slice(0, offset)
    alphabet = alphabet.reverse

    id = id[1, id.size]

    while id.size.positive?
      separator = alphabet[0]

      chunks = id.split(separator, 2)
      if chunks.any?
        return ret if chunks[0] == ""

        ret.push(to_number(chunks[0], alphabet.byte_slice(1, alphabet.size - 1)))
        alphabet = shuffle(alphabet) if chunks.size > 1
      end

      id = chunks.size > 1 ? chunks[1] : ""
    end

    ret
  end

  private def shuffle(alphabet)
    chars = alphabet.chars

    i = 0
    j = chars.size - 1
    while j.positive?
      r = ((i * j) + chars[i].ord + chars[j].ord) % chars.size
      chars[i], chars[r] = chars[r], chars[i]
      i += 1
      j -= 1
    end

    chars.join
  end

  private def encode_numbers(numbers : Array(UInt), increment : Int32 = 0) : String
    raise ArgumentError.new("Reached max attempts to re-generate the ID") if increment > @alphabet.size

    offset = numbers.size
    numbers.each_with_index do |v, i|
      offset += @alphabet[v % @alphabet.size].ord + i
    end
    offset = offset % @alphabet.size
    offset = (offset + increment) % @alphabet.size

    alphabet = @alphabet.byte_slice(offset) + @alphabet.byte_slice(0, offset)

    prefix = alphabet[0]
    alphabet = alphabet.reverse
    ret = [prefix] of String | Char

    numbers.each_with_index do |num, i|
      ret.push(to_id(num, alphabet.byte_slice(1)))

      next unless i < numbers.size - 1

      ret.push(alphabet[0])
      alphabet = shuffle(alphabet)
    end

    id = ret.join

    if @min_length > id.size
      id += alphabet[0]

      while (@min_length - id.size).positive?
        alphabet = shuffle(alphabet)
        id += alphabet.byte_slice(0, [@min_length - id.size, alphabet.size].min)
      end
    end

    id = encode_numbers(numbers, increment: increment + 1) if blocked_id?(id)

    id
  end

  private def to_id(num : UInt, alphabet : String) : String
    id = [] of Char
    chars = alphabet.chars

    result = num
    loop do
      id.unshift(chars[(result % chars.size).to_i32])
      result //= chars.size
      break if result == 0
    end

    id.join
  end

  private def to_number(id, alphabet) : UInt64
    chars = alphabet.chars
    id.chars.reduce(0_u64) { |a, v| (a * chars.size) + chars.index(v).as(Int32) }
  end

  private def blocked_id?(id)
    id = id.downcase

    @blocklist.any? do |word|
      if word.size <= id.size
        if id.size <= 3 || word.size <= 3
          id == word
        elsif word.chars.any? { |c| c.ascii_number? }
          id.starts_with?(word) || id.ends_with?(word)
        else
          id.includes?(word)
        end
      end
    end
  end

  private def contains_multibyte_chars(input_str)
    input_str.bytesize != input_str.size
  end
end
