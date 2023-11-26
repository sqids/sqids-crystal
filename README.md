# [Sqids Crystal](https://sqids.org/crystal)

Sqids (pronounced "squids") is a small library that lets you generate YouTube-looking IDs from numbers. It's good for link shortening, fast & URL-safe ID generation and decoding back into numbers for quicker database lookups.

## Getting started

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  sqids:
    github: sqids/sqids-crystal
```

And then execute:

```sh
shards install
```

## Examples

Simple encode & decode:

```crystal
sqids = Sqids.new
id = sqids.encode([1, 2, 3]) # "86Rf07"
numbers = sqids.decode(id) # [1, 2, 3]
```

> **Note**
> 🚧 Because of the algorithm's design, **multiple IDs can decode back into the same sequence of numbers**. If it's important to your design that IDs are canonical, you have to manually re-encode decoded numbers and check that the generated ID matches.

Enforce a *minimum* length for IDs:

```crystal
sqids = Sqids.new(min_length: 10)
id = sqids.encode([1, 2, 3]) # "86Rf07xd4z"
numbers = sqids.decode(id) # [1, 2, 3]
```

Randomize IDs by providing a custom alphabet:

```crystal
sqids = Sqids.new(alphabet: "FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE")
id = sqids.encode([1, 2, 3]) # "B4aajs"
numbers = sqids.decode(id) # [1, 2, 3]
```

Prevent specific words from appearing anywhere in the auto-generated IDs:

```crystal
sqids = Sqids.new(blocklist: Set.new(%w[86Rf07]))
id = sqids.encode([1, 2, 3]) # "se8ojk"
numbers = sqids.decode(id) # [1, 2, 3]
```

## License

[MIT](LICENSE)
