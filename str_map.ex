defmodule StrMap do
    @moduledoc false

    def get!(map, path_to_elem) do
        path = parse_path(path_to_elem)
        get_element(path, map)
    end

    def put!(map, path_to_elem, value) do
        path = parse_path(path_to_elem)
        set_element(path, map, value, [{:base, map}], nil)
    end

    defp parse_path(path) do
        path_list = String.split(path, ".", [:global])
        parse_path(path_list, [])
    end

    defp parse_path([], acc) do
        acc
    end
    defp parse_path([ph|pt], acc) do
        path_list = String.split(ph, "[")
        key = case path_list do
            [_,h1|_] ->
                [str_num, _] = String.split(h1, "]")
                {num, _} = Integer.parse(str_num)
                num
            [h] ->
                h
        end
        parse_path(pt, acc ++ [key])
    end

    defp get_element([], data) do
        data
    end
    defp get_element([h|t], data) do
        el = case is_integer(h) do
            true ->
                Enum.at(data, h)
            false ->
                Map.get(data, h)
        end
        get_element(t, el)
    end

    defp set_element([h], el, value, final, prev_h) do
        data = case is_map(el) do
            true -> el
            false when is_integer(h) -> el
            false -> %{}
        end

        el1 = case is_integer(h) do
            true ->
                set_list_element(h, data, value)
            false ->
                Map.put(data, h, value)
        end
        final1 = [{prev_h, el1}|final]
        combine(final1)
    end
    defp set_element([h|t], data, value, final, _) do
        el = case is_integer(h) do
            true ->
                Enum.at(data, h)
            false ->
                Map.get(data, h)
        end
        set_element(t, el, value, [{h, el}|final], h)
    end

    defp combine([{k,m},{:base, m1}]) do
        Map.put(m1, k, m)
    end
    defp combine([{k,m},{k1,m1}|t]) when k == k1 do
        m2 = m
        combine([{k1, m2}|t])
    end
    defp combine([{k,m},{k1,m1}|t]) when is_map(m1) do
        m2 = Map.put(m1, k, m)
        combine([{k1, m2}|t])
    end
    defp combine([{k,m},{k1,m1}|t]) when is_list(m1) do
        m2 = set_list_element(k, m1, m)
        combine([{k1, m2}|t])
    end

    defp set_list_element(h, data, value) do
        case  h < length(data) do
            true ->
                {_, acc1} = List.foldl(data, {0, []}, fn(d, {i, acc}) ->
                    case i == h do
                        true ->
                            {i + 1, [value|acc]}
                        false ->
                            {i + 1, [d|acc]}
                    end
                end)
                Enum.reverse(acc1)
            false ->
                data ++ [value]
        end
    end
end