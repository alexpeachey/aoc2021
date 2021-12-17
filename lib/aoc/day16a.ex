defmodule AOC.Day16a do
  import AOC

  @hex_map %{
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }

  def solution(path) do
    path
    |> read_lines()
    |> List.first()
    |> hex_to_bits()
    |> bits_to_packet()
    |> version_sum()
  end

  def version_sum({packet, _}) do
    version_sum(packet)
  end

  def version_sum(%{version: version, payload: payload}) do
    version + version_sum(payload)
  end

  def version_sum(packets) when is_list(packets) do
    packets
    |> Enum.map(&version_sum/1)
    |> Enum.sum()
  end

  def version_sum(n) when is_integer(n), do: 0

  def bits_to_packet(<<version::binary-size(3), type::binary-size(3), payload_bits::binary>>) do
    packet = %{
      version: String.to_integer(version, 2),
      type: String.to_integer(type, 2)
    }

    {payload, remainder} = bits_to_payload(packet, payload_bits)
    {Map.put(packet, :payload, payload), remainder}
  end

  @spec bits_to_payload(%{:type => 4, optional(any) => any}, <<_::40, _::_*8>>) :: any
  def bits_to_payload(%{type: 4}, bits) do
    {literal, remainder} =
      bits
      |> bits_to_literal()

    {String.to_integer(literal, 2), remainder}
  end

  def bits_to_payload(_packet, <<"0", packet_len::binary-size(15), packets::binary>>) do
    packets
    |> packets_by_length(packet_len |> String.to_integer(2))
  end

  def bits_to_payload(_packet, <<"1", num_packets::binary-size(11), packets::binary>>) do
    packets
    |> packets_by_count(num_packets |> String.to_integer(2))
  end

  def packets_by_length(bits, length) do
    {packet, remainder} = bits_to_packet(bits)
    packet_length = String.length(bits) - String.length(remainder)

    if packet_length == length do
      {[packet], remainder}
    else
      {next_packets, remainder} = packets_by_length(remainder, length - packet_length)

      {[packet | next_packets], remainder}
    end
  end

  def packets_by_count(bits, 0), do: {[], bits}

  def packets_by_count(bits, count) do
    {packet, remainder} = bits_to_packet(bits)
    {next_packets, remainder} = packets_by_count(remainder, count - 1)
    {[packet | next_packets], remainder}
  end

  def bits_to_literal(<<"1", n::binary-size(4), rest::binary>>) do
    {trailing, remainder} = bits_to_literal(rest)
    {n <> trailing, remainder}
  end

  def bits_to_literal(<<"0", n::binary-size(4), remainder::binary>>) do
    {n, remainder}
  end

  def hex_to_bits(n) do
    n
    |> String.split("", trim: true)
    |> Enum.map(fn d -> @hex_map[d] end)
    |> Enum.join("")
  end
end
